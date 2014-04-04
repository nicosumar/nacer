# -*- encoding : utf-8 -*-
class PrestacionesLiquidadasController < ApplicationController

  def por_afiliado_efector
    begin
      if params[:parametros_adicionales][:efector_id].present? and params[:parametros_adicionales][:valor_encadenado].present?
        # capturo los parametros
        afiliado_id = params[:parametros_adicionales][:valor_encadenado] # En este caso el valor encadenado es el id de afiliado
        efector_id  = params[:parametros_adicionales][:efector_id]
        concepto_id = params[:parametros_adicionales][:concepto_de_facturacion_id]

        #Solo busca prestaciones en estado PAGADA para un afiliado.
        @prestaciones_liquidadas =  PrestacionLiquidada.includes(:prestacion_incluida, :prestacion)
                                                       .pagadas_por_afiliado_efector_y_concepto(Afiliado.find(afiliado_id), Efector.find(efector_id), ConceptoDeFacturacion.find(concepto_id))


        respond_to do |format|
          if @prestaciones_liquidadas.present? and @prestaciones_liquidadas.size > 0
            format.json{
              render json: {total: @prestaciones_liquidadas.size, prestaciones: @prestaciones_liquidadas.map!{ |p| {id:p.id, text: "#{p.prestacion.codigo}" }} }
            }
          else
            format.json{
              render json: {total: 0, prestaciones: []}
            }
          end
        end
      else
        respond_to do |format|
          format.json{
              render json: {total: 0, prestaciones: []}
          }
        end
      end
    rescue Exception => e
      respond_to do |format|
        format.json{
            render json: {total: 0, prestaciones: []}
        }
      end
    end
  end

end
