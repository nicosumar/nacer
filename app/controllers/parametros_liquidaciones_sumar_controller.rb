# -*- encoding : utf-8 -*-
class ParametrosLiquidacionesSumarController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura

  # GET /parametros_liquidaciones_sumar/1
  def show
    @parametro_liquidacion_sumar = ParametroLiquidacionSumar.find(params[:id])
  end

  # GET /parametros_liquidaciones_sumar/1/edit
  def edit
    @parametro_liquidacion_sumar = ParametroLiquidacionSumar.find(params[:id])

    if @parametro_liquidacion_sumar.liquidaciones_sumar.first.prestaciones_liquidadas.count > 1
      redirect_to @parametro_liquidacion_sumar.liquidaciones_sumar.first, :flash => { :tipo => :error, :titulo => "La liquidacion ya ha sido procesada. Los cambios no se realizarán." } 
      return
    end
    
    @nomencladores = Nomenclador.all.collect {|n| [n.nombre, n.id]}
    @formulas = Formula.all.collect {|d| [d.descripcion, d.id]}
    @estados = EstadoDeLaPrestacion.all.collect {|d| [d.nombre, d.id]}

  end

  # PUT /parametros_liquidaciones_sumar/1
  def update
    @parametro_liquidacion_sumar = ParametroLiquidacionSumar.find(params[:id])

    if @parametro_liquidacion_sumar.update_attributes(params[:parametro_liquidacion_sumar])
      redirect_to @parametro_liquidacion_sumar, :flash => { :tipo => :ok, :titulo => "Se actualizaron los parametros correctamente" } 
    else
      @nomencladores = Nomenclador.all.collect {|n| [n.nomenclador, n.id]}
      @formulas = Formula.all.collect {|d| [d.descipcion, d.id]}

      render action: "edit" 
    end
  end

  private

  def verificar_lectura
    if cannot? :read, ParametroLiquidacionSumar
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

end
