# -*- encoding : utf-8 -*-
class LiquidacionesSumarController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura

  # GET /liquidaciones_sumar
  def index
    @liquidaciones_sumar = LiquidacionSumar.all
  end

  # GET /liquidaciones_sumar/1
  def show
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])
  end

  # GET /liquidaciones_sumar/new
  def new
    @liquidacion_sumar = LiquidacionSumar.new
    @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|cf| [cf.concepto, cf.id]}
    @grupo_de_efectores_liquidacion = GrupoDeEfectoresLiquidacion.all.collect {|g| [g.grupo, g.id]}
    @periodos_liquidacion = Periodo.all.collect {|p| [p.periodo, p.id]}
    @formulas = Formula.all.collect {|f| [f.descripcion, f.id]}
  end

  # GET /liquidaciones_sumar/1/edit
  def edit
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])
    @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|cf| [cf.concepto, cf.id]}
    @grupo_de_efectores_liquidacion = GrupoDeEfectoresLiquidacion.all.collect {|g| [g.grupo, g.id]}
    @periodo_liquidacion = Periodo.all.collect {|p| [p.periodo, p.id]}
    @formulas = Formula.all.collect {|f| [f.descripcion, f.id]}
  end

  # POST /liquidaciones_sumar
  def create
    @liquidacion_sumar = LiquidacionSumar.new(params[:liquidacion_sumar])

    if @liquidacion_sumar.save
      redirect_to @liquidacion_sumar, :flash => { :tipo => :ok, :titulo => 'Se actualizo el periodo correctamente' } 
    else
      @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|cf| [cf.concepto, cf.id]}
      @grupo_de_efectores_liquidacion = GrupoDeEfectoresLiquidacion.all.collect {|g| [g.grupo, g.id]}
      @periodo_liquidacion = Periodo.all.collect {|p| [p.periodo, p.id]}
      @formulas = Formula.all.collect {|f| [f.descripcion, f.id]}
      render action: "new" 
    end
  end

  # PUT /liquidaciones_sumar/1
  def update
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])

      if @liquidacion_sumar.update_attributes(params[:liquidacion_sumar])
        redirect_to @liquidacion_sumar, :flash => { :tipo => :ok, :titulo => 'Se actualizo el periodo correctamente' } 
      else
        @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|cf| [cf.concepto, cf.id]}
        @grupo_de_efectores_liquidacion = GrupoDeEfectoresLiquidacion.all.collect {|g| [g.grupo, g.id]}
        @periodo_liquidacion = Periodo.all.collect {|p| [p.periodo, p.id]}
        @formulas = Formula.all.collect {|f| [f.descripcion, f.id]}
        render action: "edit" 
      end
  end

  # DELETE /liquidaciones_sumar/1
  def destroy
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])
    @liquidacion_sumar.destroy

    redirect_to liquidaciones_sumar_url 
  end

  private

  def verificar_lectura
    if cannot? :read, LiquidacionSumar
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end
end
