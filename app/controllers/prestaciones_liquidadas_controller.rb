# -*- encoding : utf-8 -*-
class PrestacionesLiquidadasController < ApplicationController

  def por_afiliado_concepto_y_efector
    begin
      if params[:parametros_adicionales][:efector_id].present? and params[:parametros_adicionales][:valor_encadenado].present?
        # capturo los parametros
        afiliado_id = params[:parametros_adicionales][:valor_encadenado] # En este caso el valor encadenado es el id de afiliado
        efector_id  = params[:parametros_adicionales][:efector_id]
        concepto_id = params[:parametros_adicionales][:concepto_de_facturacion_id]

        # TODO: Ahora busco las prestaciones desde las liquidadas. Deberia buscarlas de las brindadas pero si un efector cambia de UAD 
        #       puedo no encontrar todas las prestaciones hasta que tenga un historico de cambios de uads.

        # Si afiliado_id es -1 significa que es una comunitaria
        if afiliado_id == "-1"
          @prestaciones_liquidadas = PrestacionLiquidada.pagadas_por_efector_y_concepto_comunitarias(Efector.find(efector_id), ConceptoDeFacturacion.find(concepto_id)).includes(:prestacion_incluida, :prestacion).order("fecha_de_la_prestacion desc")
        else

        #Solo busca prestaciones en estado PAGADA para un afiliado.
        @prestaciones_liquidadas =  PrestacionLiquidada.includes(:prestacion_incluida, :prestacion)
                                                       .pagadas_por_afiliado_efector_y_concepto(Afiliado.find(afiliado_id), Efector.find(efector_id), ConceptoDeFacturacion.find(concepto_id)).order("fecha_de_la_prestacion desc")
        end

        respond_to do |format|
          if @prestaciones_liquidadas.present? and @prestaciones_liquidadas.size > 0
            format.json{
              render json: {total: @prestaciones_liquidadas.size, prestaciones: @prestaciones_liquidadas.map!{ |p| {id:p.id, codigo: "#{p.prestacion_incluida.prestacion_codigo}", fecha: "#{p.fecha_de_la_prestacion}", nombre:"#{p.prestacion_incluida.nombre_corto}", monto: "#{p.monto}" }} }
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
