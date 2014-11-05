# -*- encoding : utf-8 -*-
class MovimientosBancariosAutorizadosController < ApplicationController

  before_filter :get_concepto_de_facturacion
  before_filter :authenticate_user!
  before_filter :verificar_lectura
  before_filter :verificar_creacion, only: [:create]

  # GET /movimientos_bancarios_autorizados
  def index
    @movimientos_bancarios_autorizados = @concepto_de_facturacion.movimientos_bancarios_autorizados.all
    @movimiento_bancario_autorizado = MovimientoBancarioAutorizado.new

    # Datos para selects
    # => Para cuentas bancarias de origen
    @organismos_gubernamentales = OrganismoGubernamental.includes(:entidad, :cuentas_bancarias).collect {|og| [og.nombre, og.entidad.id]}
    @organismo_gubernamental_id = nil
    @cuentas_bancarias_gubernamentales = OrganismoGubernamental.select("organismos_gubernamentales.id").joins(:cuentas_bancarias).includes(:entidad, :cuentas_bancarias).collect do |og|
      og.cuentas_bancarias.collect do |cb|
        [ cb.nombre, cb.id, {class: og.entidad.id} ]
      end
    end.flatten(1).uniq
    # => para cuentas bancarias destino
    @efectores = Efector.joins(:cuentas_bancarias).includes(:entidad).collect {|e| [e.nombre, e.entidad.id ]}
    @efector_id = nil
    @cuentas_bancarias_efectores = Efector.select("efectores.id").joins(:cuentas_bancarias).includes(:entidad, :cuentas_bancarias).collect do |e|
      e.cuentas_bancarias.collect do |cb|
        [cb.nombre, cb.id, {class: e.entidad.id}]
      end
    end.flatten(1).uniq
  end

  # GET /movimientos_bancarios_autorizados/1
  # GET /movimientos_bancarios_autorizados/1.json
  def show
    @movimiento_bancario_autorizado = MovimientoBancarioAutorizado.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movimiento_bancario_autorizado }
    end
  end

  # GET /movimientos_bancarios_autorizados/new
  # GET /movimientos_bancarios_autorizados/new.json
  def new
    @movimiento_bancario_autorizado = MovimientoBancarioAutorizado.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movimiento_bancario_autorizado }
    end
  end

  # GET /movimientos_bancarios_autorizados/1/edit
  def edit
    @movimiento_bancario_autorizado = MovimientoBancarioAutorizado.find(params[:id])
  end

  # POST /movimientos_bancarios_autorizados
  # POST /movimientos_bancarios_autorizados.json
  def create
    @movimiento_bancario_autorizado = MovimientoBancarioAutorizado.new(params[:movimiento_bancario_autorizado])

    respond_to do |format|
      if @movimiento_bancario_autorizado.save
        format.html { redirect_to @movimiento_bancario_autorizado, notice: 'Movimiento bancario autorizado was successfully created.' }
        format.json { render json: @movimiento_bancario_autorizado, status: :created, location: @movimiento_bancario_autorizado }
      else
        format.html { render action: "new" }
        format.json { render json: @movimiento_bancario_autorizado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /movimientos_bancarios_autorizados/1
  # PUT /movimientos_bancarios_autorizados/1.json
  def update
    @movimiento_bancario_autorizado = MovimientoBancarioAutorizado.find(params[:id])

    respond_to do |format|
      if @movimiento_bancario_autorizado.update_attributes(params[:movimiento_bancario_autorizado])
        format.html { redirect_to @movimiento_bancario_autorizado, notice: 'Movimiento bancario autorizado was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @movimiento_bancario_autorizado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movimientos_bancarios_autorizados/1
  # DELETE /movimientos_bancarios_autorizados/1.json
  def destroy
    @movimiento_bancario_autorizado = MovimientoBancarioAutorizado.find(params[:id])
    @movimiento_bancario_autorizado.destroy

    respond_to do |format|
      format.html { redirect_to movimientos_bancarios_autorizados_url }
      format.json { head :no_content }
    end
  end

  private

  def get_concepto_de_facturacion
    
    begin
      @concepto_de_facturacion = ConceptoDeFacturacion.find(params[:concepto_de_facturacion_id])
    rescue Exception => e
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})  
    end
  end

  def verificar_lectura
    if cannot? :read, MovimientoBancarioAutorizado
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

  def verificar_creacion
    if cannot? :create, MovimientoBancarioAutorizado
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end
end
