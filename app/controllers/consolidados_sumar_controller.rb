# -*- encoding : utf-8 -*-
class ConsolidadosSumarController < ApplicationController
  
  # GET /consolidados_sumar/1.pdf
  def show
    @consolidado_sumar = ConsolidadoSumar.find(params[:id])

    respond_to do |format|
      #format.html 
      format.pdf { send_data render_to_string, filename: "cuasifactura#{@consolidado_sumar.numero_de_consolidado}.pdf", 
      type: 'application/pdf', disposition: 'inline'} #'attachment'} #'inline'}
    end
  end

 
end
