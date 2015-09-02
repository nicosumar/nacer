# -*- encoding : utf-8 -*-
class PrestacionesController < ApplicationController
  before_filter :authenticate_user!

  def autorizadas

    begin

      cadena = params[:q]
      ids = eval( params[:ids] ) if params[:ids].present?
      x = params[:page]
      y = params[:per]
      

      beneficiario = Afiliado.where(clave_de_beneficiario: params[:clave_de_beneficiario]).first
      fecha_de_la_prestacion = params[:fecha_de_la_prestacion].to_date
      efector = Efector.find(params[:efector_id])

      condicion_id = "1=1"
      if ids.present? 
        condicion_id = "prestacion_id = #{ids.to_s}"
      end

      # Generar el listado de prestaciones válidas
      autorizadas_por_efector =
        Prestacion.includes(:diagnosticos).find(
          efector.prestaciones_autorizadas_al_dia(fecha_de_la_prestacion).
                  joins("join prestaciones on prestaciones.id = prestaciones_autorizadas.prestacion_id").
                  where("(prestaciones.codigo ilike '%#{cadena}%' OR prestaciones.nombre ilike '%#{cadena}%')").
                  where(condicion_id).
                  paginate(page: x, per_page: y).
                  collect{ |p| p.prestacion_id }
        )

      autorizadas_por_grupo = beneficiario.grupo_poblacional_al_dia(fecha_de_la_prestacion).
                                          prestaciones_autorizadas.
                                          where("(prestaciones.codigo ilike '%#{cadena}%' OR prestaciones.nombre ilike '%#{cadena}%')")
      autorizadas_por_sexo = beneficiario.sexo.prestaciones_autorizadas.
                                              where("(prestaciones.codigo ilike '%#{cadena}%' OR prestaciones.nombre ilike '%#{cadena}%')")
      @prestaciones = autorizadas_por_efector.keep_if do |p|
        autorizadas_por_sexo.member?(p) && autorizadas_por_grupo.member?(p)
      end

      hash_prestaciones = []
      @prestaciones.each do |p|
        
        hash_dr= []
        hash_diagnosticos = []

        p.datos_reportables.order(:nombre_de_grupo, :orden_de_grupo).select("datos_reportables.*, datos_reportables_requeridos.id dr_id").each do |dr|

          hash_valores_enum = []
          
          if dr.clase_para_enumeracion.present? 
            eval(dr.clase_para_enumeracion).all.each do |val|
              hash_valores_enum << {
                id: val.id,
                nombre: val.nombre
              }
            end
          end

          hash_dr << {
            nombre_de_grupo: (dr.nombre_de_grupo.present? ? dr.nombre_de_grupo : ""),
            codigo_de_grupo: (dr.codigo_de_grupo.present? ? dr.codigo_de_grupo : ""),
            nombre: dr.nombre,
            dato_reportable_id: dr.dr_id,
            orden: (dr.orden_de_grupo.present? ? dr.orden_de_grupo : ""),
            tipo: dr.tipo_ruby,
            enumerable: dr.clase_para_enumeracion.present?,
            valores: hash_valores_enum
          }
        end
        
        p.diagnosticos.each do |d|
          hash_diagnosticos << {
            id: d.id,
            nombre: d.nombre_y_codigo
          }
        end

        hash_prestaciones << {
          id: p.id,
          nombre: p.nombre_corto,
          codigo: p.codigo,
          es_comunitaria: p.comunitaria,
          es_catastrofica: p.es_catastrofica,
          unidad_de_medida_nombre: p.unidad_de_medida.nombre,
          unidad_de_medida_max: p.unidades_maximas,
          diagnosticos: hash_diagnosticos,
          datos_reportables: hash_dr
        }

      end
      
      respond_to do |format|
          format.json {
            render json: {total: hash_prestaciones.size, prestaciones: hash_prestaciones }
          }
      end
    rescue Exception => e
      respond_to do |format|
        format.json {
          render json: {total: 0, prestaciones: [] }, status: :ok
        }
      end #end response
    end #end begin rescue 
  end
end
