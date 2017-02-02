# -*- encoding : utf-8 -*-
class ConceptosDeFacturacionController < ApplicationController
  # GET /conceptos_de_facturacion
  def index
    @conceptos_de_facturacion = ConceptoDeFacturacion.includes(:formula, :tipo_de_expediente).all
  end

  # GET /conceptos_de_facturacion/1
  def show
    @concepto_de_facturacion = ConceptoDeFacturacion.find(params[:id], :include => [:prestaciones, :formula, :tipo_de_expediente])
  end

  # GET /conceptos_de_facturacion/new
  def new
    @concepto_de_facturacion = ConceptoDeFacturacion.new
    @prestaciones = Prestacion.all
    @prestaciones_ids = @concepto_de_facturacion.prestaciones.collect{ |p| p.id }
    @tipos_de_expedientes = TipoDeExpediente.all.collect {|t| [t.nombre, t.id]}
    @formulas = Formula.all.collect {|f| [f.descripcion, f.id]}
  end

  # GET /conceptos_de_facturacion/1/edit
  def edit
    @concepto_de_facturacion = ConceptoDeFacturacion.find(params[:id])
    @prestaciones = Prestacion.all
    @prestaciones_ids = @concepto_de_facturacion.prestaciones.collect{ |p| p.id }
    @tipos_de_expedientes = TipoDeExpediente.all.collect {|t| [t.nombre, t.id]}
    @formulas = Formula.all.collect {|f| [f.descripcion, f.id]}
  end

  # POST /conceptos_de_facturacion
  def create
    @concepto_de_facturacion = ConceptoDeFacturacion.new(params[:concepto_de_facturacion])

    @concepto_de_facturacion.prestaciones = Prestacion.find( (params[:concepto_en_prestaciones][:id]).reject(&:blank?) || [] )

    if @concepto_de_facturacion.save
      redirect_to @concepto_de_facturacion, :flash => { :tipo => :ok, :titulo => 'Se creó el concepto correctamente' }
    else
      @prestaciones = Prestacion.all
      @prestaciones_ids = @concepto_de_facturacion.prestaciones.collect{ |p| p.id }
      @tipos_de_expedientes = TipoDeExpediente.all.collect {|t| [t.nombre, t.id]}
      @formulas = Formula.all.collect {|f| [f.descripcion, f.id]}
      render action: "new"
    end

  end

  # PUT /conceptos_de_facturacion/1
  def update
    @concepto_de_facturacion = ConceptoDeFacturacion.find(params[:id])

    @concepto_de_facturacion.prestaciones = Prestacion.find( (params[:concepto_en_prestaciones][:id]).reject(&:blank?) || [] )

    if @concepto_de_facturacion.update_attributes(params[:concepto_de_facturacion])
      redirect_to @concepto_de_facturacion, :flash => { :tipo => :ok, :titulo => 'Se actualizó el concepto correctamente' }
    else
      @prestaciones = Prestacion.all
      @prestaciones_ids = @concepto_de_facturacion.prestaciones.collect{ |p| p.id }
      @tipos_de_expedientes = TipoDeExpediente.all.collect {|t| [t.nombre, t.id]}
      @formulas = Formula.all.collect {|f| [f.descripcion, f.id]}
      render action: "edit"
    end
  end

  # DELETE /conceptos_de_facturacion/1
  def destroy
    @concepto_de_facturacion = ConceptoDeFacturacion.find(params[:id])
    @concepto_de_facturacion.destroy

    redirect_to conceptos_de_facturacion_url
  end

end
