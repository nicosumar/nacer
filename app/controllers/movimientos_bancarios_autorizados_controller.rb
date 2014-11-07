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

  # POST /movimientos_bancarios_autorizados.js
  def create
    @movimiento_bancario_autorizado =  @concepto_de_facturacion.movimientos_bancarios_autorizados.new(params[:movimiento_bancario_autorizado])

    respond_to do |format|
      begin
        @movimiento_bancario_autorizado.save!

      rescue ActiveRecord::RecordNotUnique => e
        if e.message.include? "cuenta_bancaria_origen_id, cuenta_bancaria_destino_id, concepto_de_facturacion_id"
          @movimiento_bancario_autorizado.errors.add(:duplicado, "El movimiento bancario ya existe para este concepto.")
        end
      rescue Exception => e
        @movimiento_bancario_autorizado.errors.add(:otro, e.message)
      end
      format.js
    end
  end

  # DELETE /movimientos_bancarios_autorizados/1.js
  def destroy
    @movimiento_bancario_autorizado = MovimientoBancarioAutorizado.find(params[:id])
    @movimiento_bancario_autorizado.destroy

    respond_to do |format|
      format.js
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
    if cannot? :manage, MovimientoBancarioAutorizado
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

  def verificar_creacion
    if cannot? :manage, MovimientoBancarioAutorizado
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end
end
