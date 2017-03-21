# -*- encoding : utf-8 -*-
require 'will_paginate/array'

class PrestacionesPrincipalesController < ApplicationController
  load_and_authorize_resource except: [:index]
  before_filter :authenticate_user!
  before_filter :set_prestacion_principal, only: [:update, :edit, :show, :destroy]

  def index
    @prestaciones_principales = PrestacionPrincipal.like_codigo(params[:codigo])
    @prestaciones_principales = @prestaciones_principales.paginate(page: params[:page], per_page: params[:per])
    respond_to do |format|
      format.html
      format.json { render json: @prestaciones_principales.order("nombre ASC") }
    end 
  end

  def new
    @prestacion_principal = PrestacionPrincipal.new
    set_prestaciones_existentes
  end

  def create
    @prestacion_principal = PrestacionPrincipal.new params[:prestacion_principal]    
    if @prestacion_principal.save
      if duplicar_prestacion_y_redireccionar params[:duplicar_prestacion_id]
        redirect_to edit_prestacion_principal_url(@prestacion_principal)
      else
        redirect_to @prestacion_principal
      end
    else
      render :new
    end
  end

  def edit
    set_prestaciones_existentes
  end

  def update 
    prestacion_ids = []
    params[:prestacion_principal][:prestaciones_attributes].each{|key, hash| prestacion_ids << hash["id"]}
    params[:prestacion_principal][:prestacion_ids] = prestacion_ids
    params[:prestacion_principal][:prestaciones_attributes] = params[:prestacion_principal][:prestaciones_attributes].each{|key, hash| hash["prestacion_principal_id"] = @prestacion_principal.id if @prestacion_principal.id.present? }
    params[:prestacion_principal][:prestaciones_attributes] = params[:prestacion_principal][:prestaciones_attributes].each{|key, hash| hash["prestacion_principal_id"] = nil if hash["_destroy"] == "1" }
    @prestacion_principal.prestacion_ids = prestacion_ids
    @prestacion_principal.attributes = params[:prestacion_principal]
    if @prestacion_principal.save
      if duplicar_prestacion_y_redireccionar params[:duplicar_prestacion_id]
        redirect_to edit_prestacion_principal_url(@prestacion_principal)
      else
        redirect_to @prestacion_principal
      end
    else
      render :edit
    end
  end

  def show
    @prestacion_principal = @prestacion_principal.decorate
  end

  private

    def set_prestacion_principal
      @prestacion_principal = PrestacionPrincipal.find(params[:id])
    end

    def set_prestaciones_existentes
      @prestacion_principal = PrestacionPrincipal.new unless @prestacion_principal.present?

      if params[:validator].present?
        @objeto_de_la_prestacion_id = params[:validator][:objeto_de_la_prestacion_id]
        @diagnostico_id = params[:validator][:diagnostico_id]
        @codigo = ObjetoDeLaPrestacion.find(@objeto_de_la_prestacion_id).codigo_para_la_prestacion if @objeto_de_la_prestacion_id.present?
        prestaciones = Prestacion.like_codigo(@codigo).by_diagnostico(@diagnostico_id).where(prestacion_principal_id: nil)
        prestaciones.each do |prestacion|
          @prestacion_principal.association(:prestaciones).add_to_target(prestacion)
        end
      end
    end

    def duplicar_prestacion_y_redireccionar prestacion_id
      # Verifico si duplico y redirecciono al edit.
      if prestacion_id.present?
        prestacion_a_duplicar = Prestacion.find(prestacion_id)
        if prestacion_a_duplicar.present?
          nueva_prestacion = prestacion_a_duplicar.duplicar
          nueva_prestacion.prestacion_principal = @prestacion_principal
          return nueva_prestacion.save
        end
      end
      return false
    end

end
