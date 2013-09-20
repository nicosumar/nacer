# -*- encoding : utf-8 -*-
class LiquidacionesSumarCuasifacturasController < ApplicationController
  # GET /liquidaciones_sumar_cuasifacturas
  # GET /liquidaciones_sumar_cuasifacturas.json
  def index
    @liquidaciones_sumar_cuasifacturas = LiquidacionSumarCuasifactura.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @liquidaciones_sumar_cuasifacturas }
    end
  end

  # GET /liquidaciones_sumar_cuasifacturas/1.pdf
  def show
    @liquidacion_sumar_cuasifactura = LiquidacionSumarCuasifactura.find(params[:id])

    respond_to do |format|
      format.pdf { send_data render_to_string, filename: "cuasifactura#{@liquidacion_sumar_cuasifactura.numero_cuasifactura}.pdf", 
      type: 'application/pdf', disposition: 'inline'}
    end
  end

  
end
