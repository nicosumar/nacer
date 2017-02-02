# -*- encoding : utf-8 -*-
class DiagnosticosController < ApplicationController
  before_filter :authenticate_user!

  def por_prestacion
    
    begin

      cadena = params[:q]
      #ids = eval( params[:ids] ) if params[:ids].present?
      x = params[:page]
      y = params[:per]

      prestacion = Prestacion.find(params[:prestacion_brindada_prestacion_id])

      diagnosticos = prestacion.diagnosticos.where("nombre ilike '%#{cadena}%' OR codigo ilike '%{cadena}%'").paginate(page: x, per_page: y)
      
      diagnosticos = diagnosticos.map do |d|
        {
          id: d.id,
          nombre: d.nombre_y_codigo
        }
      end

      respond_to do |format|
          format.json {
            render json: {total: diagnosticos.size, diagnosticos: diagnosticos }
          }
      end
    rescue Exception => e
      respond_to do |format|
        format.json {
          render json: {total: 0, diagnosticos: [] }, status: :ok
        }
      end #end response
    end #end begin rescue 
  end
end
