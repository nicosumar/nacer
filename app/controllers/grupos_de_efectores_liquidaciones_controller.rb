# -*- encoding : utf-8 -*-
class GruposDeEfectoresLiquidacionesController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /grupos_de_efectores_liquidaciones
  def index
    @grupos_de_efectores_liquidaciones = GrupoDeEfectoresLiquidacion.all
  end

  # GET /grupos_de_efectores_liquidaciones/1
  def show
    @grupo_de_efector_liquidacion = GrupoDeEfectoresLiquidacion.find(params[:id])
  end

  # GET /grupos_de_efectores_liquidaciones/new
  def new
    @grupo_de_efector_liquidacion = GrupoDeEfectoresLiquidacion.new
    @efectores = Efectores.all.collect 
    @efectores_ids = @grupo_de_efector_liquidacion.efectores.collect{ |p| p.id }
  end

  # GET /grupos_de_efectores_liquidaciones/1/edit
  def edit
    @grupo_de_efector_liquidacion = GrupoDeEfectoresLiquidacion.find(params[:id])
    @efectores = Efectores.all
    @efectores_ids = @grupo_de_efector_liquidacion.efectores.collect{ |p| p.id }
  end

  # POST /grupos_de_efectores_liquidaciones
  def create
    @grupo_de_efector_liquidacion = GrupoDeEfectoresLiquidacion.new(params[:grupo_de_efector_liquidacion])

    if @grupo_de_efector_liquidacion.save
      redirect_to @grupo_de_efector_liquidacion, notice: 'Grupo de efectores liquidacion was successfully created.' 
    else
      render action: "new" 
    end

  end

  # PUT /grupos_de_efectores_liquidaciones/1
  def update
    @grupo_de_efector_liquidacion = GrupoDeEfectoresLiquidacion.find(params[:id])

    if @grupo_de_efector_liquidacion.update_attributes(params[:grupo_de_efector_liquidacion])
      redirect_to @grupo_de_efector_liquidacion, notice: 'Grupo de efectores liquidacion was successfully updated.' 
    else
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
