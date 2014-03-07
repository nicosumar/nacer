# -*- encoding : utf-8 -*-
class ExpedientesSumarController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura
  before_filter :verificar_creacion, only: [:create, :new]

  # GET /expedientes_sumar
  # GET /expedientes_sumar.json
  def index
    @expedientes_sumar = ExpedienteSumar.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @expedientes_sumar }
    end
  end

  # GET /expedientes_sumar/1
  # GET /expedientes_sumar/1.json
  def show
    @expediente_sumar = ExpedienteSumar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @expediente_sumar }
    end
  end

  # GET /expedientes_sumar/new
  # GET /expedientes_sumar/new.json
  def new
    @expediente_sumar = ExpedienteSumar.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expediente_sumar }
    end
  end

  # GET /expedientes_sumar/1/edit
  def edit
    @expediente_sumar = ExpedienteSumar.find(params[:id])
  end

  # POST /expedientes_sumar
  # POST /expedientes_sumar.json
  def create
    @expediente_sumar = ExpedienteSumar.new(params[:expediente_sumar])

    respond_to do |format|
      if @expediente_sumar.save
        format.html { redirect_to @expediente_sumar, notice: 'Expediente sumar was successfully created.' }
        format.json { render json: @expediente_sumar, status: :created, location: @expediente_sumar }
      else
        format.html { render action: "new" }
        format.json { render json: @expediente_sumar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /expedientes_sumar/1
  # PUT /expedientes_sumar/1.json
  def update
    @expediente_sumar = ExpedienteSumar.find(params[:id])

    respond_to do |format|
      if @expediente_sumar.update_attributes(params[:expediente_sumar])
        format.html { redirect_to @expediente_sumar, notice: 'Expediente sumar was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @expediente_sumar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expedientes_sumar/1
  # DELETE /expedientes_sumar/1.json
  def destroy
    @expediente_sumar = ExpedienteSumar.find(params[:id])
    @expediente_sumar.destroy

    respond_to do |format|
      format.html { redirect_to expedientes_sumar_url }
      format.json { head :no_content }
    end
  end

  def generar_caratulas_expedientes_por_liquidacion
     @liquidacion_sumar = LiquidacionSumar.find(params[:id])
    
    logger.warn("Entro al metodo!!!!!!!!!!")
    if LiquidacionInforme.where(liquidacion_sumar_id: @liquidacion_sumar.id).size >=1
      respond_to do |format|
        format.pdf { send_data render_to_string, filename: "caratulas_expedientes.pdf", type: 'application/pdf', disposition: 'attachment'}
      end
    else
      redirect_to( @liquidacion_sumar, :flash => { :tipo => :error, :titulo => "Debe generar las cuasifacturas primero"})
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
