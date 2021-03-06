# -*- encoding : utf-8 -*-
class GruposDeEfectoresLiquidacionesController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /grupos_de_efectores_liquidaciones
  def index
    @grupos_de_efectores_liquidaciones = GrupoDeEfectoresLiquidacion.all
  end

  # GET /grupos_de_efectores_liquidaciones/1
  def show
    @grupo_de_efector_liquidacion = GrupoDeEfectoresLiquidacion.find(params[:id], include: [:efectores])
  end

  # GET /grupos_de_efectores_liquidaciones/new
  def new
    @grupo_de_efector_liquidacion = GrupoDeEfectoresLiquidacion.new
    @efectores = Efector.where("unidad_de_alta_de_datos_id is not null and grupo_de_efectores_liquidacion_id is null")
  end

  # GET /grupos_de_efectores_liquidaciones/1/edit
  def edit
    @grupo_de_efector_liquidacion = GrupoDeEfectoresLiquidacion.find(params[:id])
    @efectores = Efector.where(" unidad_de_alta_de_datos_id is not null " +
                               " and (grupo_de_efectores_liquidacion_id is null " +
                               "       OR " +
                               "       grupo_de_efectores_liquidacion_id = #{@grupo_de_efector_liquidacion.id} "+
                               "     )"
                              )
    @efectores_ids = @grupo_de_efector_liquidacion.efectores.collect{ |p| p.id }
  end

  # POST /grupos_de_efectores_liquidaciones
  def create
    @grupo_de_efector_liquidacion = GrupoDeEfectoresLiquidacion.new(params[:grupo_de_efectores_liquidacion])

    @grupo_de_efector_liquidacion.efectores = Efector.find( (params[:grupo_liquidacion_en_efectores][:id]).reject(&:blank?) || [] )

    if @grupo_de_efector_liquidacion.save
      redirect_to @grupo_de_efector_liquidacion, :flash => { :tipo => :ok, :titulo => "El grupo '#{@grupo_de_efector_liquidacion.grupo}' se creo correctamente" } 
    else
      @efectores = Efector.where("unidad_de_alta_de_datos_id is not null")
      @efectores_ids = @grupo_de_efector_liquidacion.efectores.collect{ |p| p.id }
      render action: "new" 
    end

  end

  # PUT /grupos_de_efectores_liquidaciones/1
  def update
    @grupo_de_efector_liquidacion = GrupoDeEfectoresLiquidacion.find(params[:id])

    @grupo_de_efector_liquidacion.efectores = Efector.find( (params[:grupo_liquidacion_en_efectores][:id]).reject(&:blank?) || [] )

    if @grupo_de_efector_liquidacion.update_attributes(params[:grupo_de_efectores_liquidacion])
      redirect_to @grupo_de_efector_liquidacion, :flash => { :tipo => :ok, :titulo => "El grupo '#{@grupo_de_efector_liquidacion.grupo}' se actualizo correctamente" } 
    else
      @efectores = Efector.where(" unidad_de_alta_de_datos_id is not null " +
                               " and (grupo_de_efectores_liquidacion_id is null " +
                               "       OR " +
                               "       grupo_de_efectores_liquidacion_id = #{@grupo_de_efector_liquidacion.id} "+
                               "     )"
                              )
      @efectores_ids = @grupo_de_efector_liquidacion.efectores.collect{ |p| p.id }
      render action: "edit" 
    end
  end

  # DELETE /grupos_de_efectores_liquidaciones/1
  def destroy
    @grupo_de_efector_liquidacion = GrupoDeEfectoresLiquidacion.find(params[:id])
    @grupo_de_efector_liquidacion.destroy

    redirect_to grupos_de_efectores_liquidaciones_url 
  end

end
