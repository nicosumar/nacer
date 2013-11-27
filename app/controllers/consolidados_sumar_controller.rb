# -*- encoding : utf-8 -*-
class ConsolidadosSumarController < ApplicationController
  
  # GET /consolidados_sumar/1.pdf
  def show
    @consolidado_sumar = ConsolidadoSumar.find(params[:id])

    if  @consolidado_sumar.liquidacion_sumar.concepto_de_facturacion.present? and 
        @consolidado_sumar.periodo.present? and 
        @consolidado_sumar.efector.present? and
        @consolidado_sumar.fecha.present?

      respond_to do |format|
        format.pdf { send_data render_to_string, filename: "consolidadosumar#{@consolidado_sumar.numero_de_consolidado}.pdf", 
        type: 'application/pdf', disposition: 'attachment'} #'attachment'} #'inline'}
      end
    end
  end

 
end
