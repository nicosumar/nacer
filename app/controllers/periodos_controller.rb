# -*- encoding : utf-8 -*-
class PeriodosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura


  # GET /periodos
   def index
    @periodos = Periodo.all
  end

  # GET /periodos/1
  def show
    @periodo = Periodo.find(params[:id])
  end

  # GET /periodos/new
  def new
    @periodo = Periodo.new
    @tipos_periodos = TipoPeriodo.all.collect {|tp| [tp.descripcion, tp.id]}
    @conceptos = ConceptoDeFacturacion.all.collect {|c| [c.concepto, c.id]}
  end

  # GET /periodos/1/edit
  def edit
    @periodo = Periodo.find(params[:id])
    @tipos_periodos = TipoPeriodo.all.collect {|tp| [tp.descripcion, tp.id]}
    @conceptos = ConceptoDeFacturacion.all.collect {|c| [c.concepto, c.id]}
  end

  # POST /periodos
  def create
    @periodo = Periodo.new(params[:periodo])


    if @periodo.save
      redirect_to @periodo, :flash => { :tipo => :ok, :titulo => 'Se creo el periodo correctamente' } 
    else
      @tipos_periodos = TipoPeriodo.all.collect {|tp| [tp.descripcion, tp.id]}
      @conceptos = ConceptoDeFacturacion.all.collect {|c| [c.concepto, c.id]}
      render action: "new" 
    end
  end

  # PUT /periodos/1
  def update
    @periodo = Periodo.find(params[:id])

    if @periodo.update_attributes(params[:periodo])
      redirect_to @periodo, :flash => { :tipo => :ok, :titulo => 'Se actualizo el periodo correctamente' } 
    else
      @tipos_periodos = TipoPeriodo.all.collect {|tp| [tp.descripcion, tp.id]}
      @conceptos = ConceptoDeFacturacion.all.collect {|c| [c.concepto, c.id]}
      render action: "edit" 
    end
  end

  # DELETE /periodos/1
  def destroy
    @periodo = Periodo.find(params[:id])
    @periodo.destroy
  
    redirect_to periodos_url 
  end

  private

  def verificar_lectura
    if cannot? :read, Periodo
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

end
