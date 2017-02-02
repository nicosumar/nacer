# -*- encoding : utf-8 -*-
class TiposPeriodosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura

  # GET /tipos_periodos
  def index
    @tipos_periodos = TipoPeriodo.all
  end

  # GET /tipos_periodos/1
  def show
    @tipo_periodo = TipoPeriodo.find(params[:id])
  end

  # GET /tipos_periodos/new
  def new
    @tipo_periodo = TipoPeriodo.new
  end

  # GET /tipos_periodos/1/edit
  def edit
    @tipo_periodo = TipoPeriodo.find(params[:id])
  end

  # POST /tipos_periodos
  def create
    @tipo_periodo = TipoPeriodo.new(params[:tipo_periodo])

    respond_to do |format|
      if @tipo_periodo.save
        format.html { redirect_to @tipo_periodo, :flash => { :tipo => :ok, :titulo => 'Se creo el periodo correctamente' } }
        format.json { render json: @tipo_periodo, status: :created, location: @tipo_periodo }
      else
        format.html { render action: "new" }
        format.json { render json: @tipo_periodo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tipos_periodos/1
  def update
    @tipo_periodo = TipoPeriodo.find(params[:id])

    respond_to do |format|
      if @tipo_periodo.update_attributes(params[:tipo_periodo])
        format.html { redirect_to @tipo_periodo, notice: 'El periodo se actualizo correctamente' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tipo_periodo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipos_periodos/1
  def destroy
    @tipo_periodo = TipoPeriodo.find(params[:id])
    @tipo_periodo.destroy


    redirect_to tipos_periodos_url 
  end

  private

  def verificar_lectura
    if cannot? :read, TipoPeriodo
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end
end
