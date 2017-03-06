# -*- encoding : utf-8 -*-
class NomencladoresController < ApplicationController
  before_filter :authenticate_user!

  def index
    if can? :read, Nomenclador then
      @nomencladores = Nomenclador.paginate(:page => params[:page], :per_page => 20, :order => "fecha_de_inicio desc")
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def show
    @nomenclador = Nomenclador.find(params[:id], :include => [ { :asignaciones_de_precios => { :prestacion => :unidad_de_medida } } ])
    if cannot? :read, @nomenclador
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def new
    if can? :create, Nomenclador then
      @nomenclador = Nomenclador.new
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def edit
    @nomenclador = Nomenclador.find(params[:id])
    if cannot? :update, @nomenclador
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def create
    if cannot? :create, Nomenclador
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end
    params_nomenclador = params[:nomenclador].permit(:nombre, :fecha_de_inicio, :activo)
    @nomenclador = Nomenclador.new(params_nomenclador)

    if @nomenclador.save
      redirect_to nomenclador_path(@nomenclador), :notice => 'El nomenclador se creó exitosamente.'
      return
    else
      render :action => "new"
    end
  end

  def update
    @nomenclador = Nomenclador.find(params[:id])
    if cannot? :update, @nomenclador
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    if @nomenclador.update_attributes(params[:nomenclador])
      redirect_to nomenclador_path(@nomenclador), :notice => 'La información del nomenclador se actualizó correctamente.'
    else
      render :action => "edit"
    end
  end

  def new_asignar_precios
    # Busco el nomenclador
    @nomenclador = Nomenclador.find(params[:id])
    
    if (can? :create, Nomenclador) && @nomenclador.can_edit?
      # Busco el nomenclador seleccionado
      @old_nomenclador = Nomenclador.where("id != ?", params[:id]).order("fecha_de_inicio DESC").first
      @secciones_pdss = SeccionPdss.all
      # Asigno los precios del nomenclador anterior al nuevo. 
      if @old_nomenclador.present? && @nomenclador.asignaciones_de_precios.count < 1
        @old_nomenclador.asignaciones_de_precios.actuales.each do |asignacion_de_precio_actual|
          nueva_asignacion_de_precio = asignacion_de_precio_actual.dup
          @nomenclador.asignaciones_de_precios << nueva_asignacion_de_precio
        end
        @nomenclador.save!
      end
    
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def new_asignar_precios_por_grupo_pdss
    @nomenclador = Nomenclador.find(params[:id])
    if (can? :create, Nomenclador) && @nomenclador.can_edit? 
      @grupo_pdss = GrupoPdss.find(params[:grupo_pdss_id])
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def update_asignar_precios
    @nomenclador = Nomenclador.find(params[:id])
    if (cannot? :update, @nomenclador) || !@nomenclador.can_edit? 
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    if @nomenclador.update_attributes(params[:nomenclador])
      redirect_to new_asignar_precios_nomenclador_path(@nomenclador), :notice => 'Los precios del grupo se actualizaron correctamente.'
    else
      render :action => "new_asignar_precios_por_grupo_pdss"
    end
  end

#  def destroy
#  end
end
