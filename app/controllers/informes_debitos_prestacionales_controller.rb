# -*- encoding : utf-8 -*-
class InformesDebitosPrestacionalesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura
  before_filter :verificar_creacion, only: [:create, :new]

  # GET /informes_debitos_prestacionales
  def index
    @informes_debitos_prestacionales = InformeDebitoPrestacional.includes(:concepto_de_facturacion, :efector, :estado_del_proceso).all
  end

  # GET /informes_debitos_prestacionales/1
  def show
    @informe_debito_prestacional = InformeDebitoPrestacional.includes(detalles_de_debitos_prestacionales: [{afiliado: :tipo_de_documento}, :estado_del_proceso]).find(params[:id])
  end

  # GET /informes_debitos_prestacionales/new
  def new
    @informe_debito_prestacional = InformeDebitoPrestacional.new
    @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|cf| [cf.concepto, cf.id]}
    @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
    @tipos_de_debitos = TipoDeDebitoPrestacional.all.collect {|td| [td.nombre, td.id]}
  end

  # GET /informes_debitos_prestacionales/1/edit
  def edit
    @informe_debito_prestacional = InformeDebitoPrestacional.find(params[:id])
    @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|cf| [cf.concepto, cf.id]}
    @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
    @tipos_de_debitos = TipoDeDebitoPrestacional.all.collect {|td| [td.nombre , td.id]}
  end

  # POST /informes_debitos_prestacionales
  def create
    @informe_debito_prestacional = InformeDebitoPrestacional.new(params[:informe_debito_prestacional])

    if @informe_debito_prestacional.save
      redirect_to @informe_debito_prestacional, :flash => { :tipo => :ok, :titulo => "Se creó el informe N° #{@informe_debito_prestacional.id}" }
    else
      @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|cf| [cf.concepto, cf.id]}
      @efectores = Efector.all.collect {|e| [e.nombre, e.id]}
      @tipos_de_debitos = TipoDeDebitoPrestacional.all.collect {|td| [td.nombre, td.id]}
      render action: "new" 
    end
  end

  # PUT /informes_debitos_prestacionales/1
  def update
    @informe_debito_prestacional = InformeDebitoPrestacional.find(params[:id])

    if @informe_debito_prestacional.update_attributes(params[:informe_debito_prestacional])
      redirect_to @informe_debito_prestacional, :flash => { :tipo => :ok, :titulo => "El informe de debito N°#{@informe_debito_prestacional.id} se actualizó correctamente" }
    else
      render action: "edit" 
    end
  end

  # DELETE /informes_debitos_prestacionales/1
  # DELETE /informes_debitos_prestacionales/1.json
  def destroy
    @inform_debito_prestacional = InformeDebitoPrestacional.find(params[:id])
    @inform_debito_prestacional.destroy

    respond_to do |format|
      format.html { redirect_to informes_debitos_prestacionales_url }
      format.json { head :no_content }
    end
  end

  def iniciar
    @informe_debito_prestacional = InformeDebitoPrestacional.find(params[:id])
    if @informe_debito_prestacional.iniciar
      redirect_to @informe_debito_prestacional, :flash => { :tipo => :ok, :titulo => "El informe de debito N°#{@informe_debito_prestacional.id} inicio correctamente" }
    else
      redirect_to @informe_debito_prestacional, :flash => { :tipo => :error, :titulo => "El informe de debito N°#{@informe_debito_prestacional.id} no pudo iniciarse" }
    end
  end

  private

  def verificar_lectura
    if cannot? :read, LiquidacionSumar
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

  def verificar_creacion
    if cannot? :create, LiquidacionSumar
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

end
