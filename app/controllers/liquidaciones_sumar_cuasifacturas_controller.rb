# -*- encoding : utf-8 -*-
class LiquidacionesSumarCuasifacturasController < ApplicationController

  before_filter :authenticate_user!
  
  # GET /liquidaciones_sumar_cuasifacturas
  def index
    @liquidaciones_sumar_cuasifacturas = LiquidacionSumarCuasifactura.all
  end

  # GET /liquidaciones_sumar_cuasifacturas/1.pdf
  def show
    @liquidacion_sumar_cuasifactura = LiquidacionSumarCuasifactura.find(params[:id])

    respond_to do |format|
      format.pdf { send_data render_to_string, filename: "cuasifactura#{@liquidacion_sumar_cuasifactura.numero_cuasifactura}.pdf", 
      type: 'application/pdf', disposition: 'inline'} #'attachment'} #'inline'}
    end
  end
  
end
