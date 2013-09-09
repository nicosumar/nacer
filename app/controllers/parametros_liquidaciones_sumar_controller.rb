class ParametrosLiquidacionesSumarController < ApplicationController

  # GET /parametros_liquidaciones_sumar/1
  def show
    @parametro_liquidacion_sumar = ParametroLiquidacionSumar.find(params[:id])
  end

  # GET /parametros_liquidaciones_sumar/1/edit
  def edit
    @parametro_liquidacion_sumar = ParametroLiquidacionSumar.find(params[:id])

    @nomencladores = Nomenclador.all.collect {|n| [n.nombre, n.id]}
    @formulas = Formula.all.collect {|d| [d.descripcion, d.id]}
  end

  # PUT /parametros_liquidaciones_sumar/1
  def update
    @parametro_liquidacion_sumar = ParametroLiquidacionSumar.find(params[:id])

    if @parametro_liquidacion_sumar.update_attributes(params[:parametro_liquidacion_sumar])
      redirect_to @parametro_liquidacion_sumar, notice: 'Parametro liquidacion sumar was successfully updated.' 
    else
      @nomencladores = Nomenclador.all.collect {|n| [n.nomenclador, n.id]}
      @formulas = Formula.all.collect {|d| [d.descipcion, d.id]}

      render action: "edit" 
    end
  end

end
