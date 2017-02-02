# -*- encoding : utf-8 -*-
class PlantillasDeReglasController < ApplicationController

  before_filter :authenticate_user!
  before_filter :verificar_lectura

  # GET /plantillas_de_reglas
  def index
    @plantillas_de_reglas = PlantillaDeReglas.all
  end

  # GET /plantillas_de_reglas/1
  def show
    @plantilla_de_reglas = PlantillaDeReglas.find(params[:id])
  end

  # GET /plantillas_de_reglas/new
  def new
    @plantilla_de_reglas = PlantillaDeReglas.new

    @reglas = Regla.all
    @reglas_ids = @plantilla_de_reglas.reglas.collect{ |r| r.id }
  end

  # GET /plantillas_de_reglas/1/edit
  def edit
    @plantilla_de_reglas = PlantillaDeReglas.find(params[:id], include: :reglas)

    @reglas = Regla.all
    @reglas_ids = @plantilla_de_reglas.reglas.collect{ |r| r.id }
  end

  # POST /plantillas_de_reglas
  def create
    @plantilla_de_reglas = PlantillaDeReglas.new(params[:plantilla_de_reglas])

    @plantilla_de_reglas.reglas = Regla.find( (params[:reglas_en_plantilla][:id]).reject(&:blank?) || [] )

    if @plantilla_de_reglas.save
      redirect_to @plantilla_de_reglas, :flash => { :tipo => :ok, :titulo => "Se creo la plantilla #{@plantilla_de_reglas.nombre} correctamente" } 
    else
      @reglas = Regla.all
      @reglas_ids = @plantilla_de_reglas.reglas.collect{ |r| r.id }
      render action: "new"
    end
  end

  # PUT /plantillas_de_reglas/1
  def update
    @plantilla_de_reglas = PlantillaDeReglas.find(params[:id])

    @plantilla_de_reglas.reglas = Regla.find( (params[:reglas_en_plantilla][:id]).reject(&:blank?) || [] )

    if @plantilla_de_reglas.update_attributes(params[:plantilla_de_reglas])
      redirect_to @plantilla_de_reglas, :flash => { :tipo => :ok, :titulo => "Se actualizó la plantilla #{@plantilla_de_reglas.nombre} correctamente" } 
    else
      @reglas = Regla.all
      @reglas_ids = @plantilla_de_reglas.reglas.collect{ |r| r.id }
      render action: "edit" 
    end
  end

  # DELETE /plantillas_de_reglas/1
  def destroy
    @plantilla_de_reglas = PlantillaDeReglas.find(params[:id])
    @plantilla_de_reglas.destroy

    redirect_to plantillas_de_reglas_url 
  end

  def verificar_lectura
    if cannot? :read, PlantillaDeReglas
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

end
