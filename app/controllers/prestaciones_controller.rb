# -*- encoding : utf-8 -*-
require 'will_paginate/array'

class PrestacionesController < ApplicationController
  before_filter :authenticate_user!

  def autorizadas

    begin

      cadena = params[:q]
      ids = eval( params[:ids] ) if params[:ids].present?
      comunitaria = eval(params[:comunitaria]) if params[:comunitaria].present?
      x = params[:page]
      y = params[:per]
      
      unless comunitaria
        beneficiario =
          NovedadDelAfiliado.where(
            :clave_de_beneficiario => params[:clave_de_beneficiario],
            :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["I", "R", "P", "Z", "U", "S"]),
            :tipo_de_novedad_id => TipoDeNovedad.id_del_codigo("A")
          ).first
        if not beneficiario.present?
          beneficiario =
            NovedadDelAfiliado.where(
              :clave_de_beneficiario => params[:clave_de_beneficiario],
              :estado_de_la_novedad_id => EstadoDeLaNovedad.where(:codigo => ["R", "P"]),
              :tipo_de_novedad_id => TipoDeNovedad.id_del_codigo("M")
            ).first
        end
        if not beneficiario.present?
          beneficiario = Afiliado.find_by_clave_de_beneficiario(params[:clave_de_beneficiario])
        end
      end

      fecha_de_la_prestacion = params[:fecha_de_la_prestacion].to_date
      efector = Efector.find(params[:efector_id])

      condicion_id = "1=1"
      if ids.present? 
        condicion_id = ["prestacion_id = ?", ids.to_s]
      else
        condicion_id = ["(prestaciones.codigo ilike ? OR prestaciones.nombre ilike ?)","%#{cadena}%", "%#{cadena}%"]
      end

      if comunitaria
        condicion_comunitaria =["comunitaria = ?", comunitaria]
      else
        condicion_comunitaria = "1=1"
      end

      # Generar el listado de prestaciones válidas
      autorizadas_por_efector =
        Prestacion.includes(:diagnosticos).where( id: (
          efector.prestaciones_autorizadas_al_dia(fecha_de_la_prestacion).
                  joins("join prestaciones on prestaciones.id = prestaciones_autorizadas.prestacion_id").
                  where(condicion_id ).
                  where(condicion_comunitaria).
                  collect{ |p| p.prestacion_id })
        ).order("prestaciones.codigo, prestaciones.nombre")

      unless comunitaria
        autorizadas_por_grupo = beneficiario.grupo_poblacional_al_dia(fecha_de_la_prestacion).
                                            prestaciones_autorizadas.
                                            where(condicion_id)
        autorizadas_por_sexo = beneficiario.sexo.prestaciones_autorizadas.
                                                where(condicion_id )
        prestaciones = autorizadas_por_efector.keep_if do |p|
          autorizadas_por_sexo.member?(p) && autorizadas_por_grupo.member?(p)
        end
      else
        prestaciones = autorizadas_por_efector
      end
      
      @prestaciones = prestaciones.paginate(page: x, per_page: y)

      hash_prestaciones = []
      @prestaciones.each do |p|
        
        hash_dr= []
        hash_diagnosticos = []

        p.datos_reportables.where("
            datos_reportables_requeridos.fecha_de_inicio <= ?
            AND (
              datos_reportables_requeridos.fecha_de_finalizacion > ?
              OR datos_reportables_requeridos.fecha_de_finalizacion IS NULL
            )",
            fecha_de_la_prestacion,
            fecha_de_la_prestacion
          ).order("nombre_de_grupo, orden_de_grupo NULLS FIRST").
          select("datos_reportables.*, datos_reportables_requeridos.id dr_id").each do |dr|
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
            render json: {total: prestaciones.size, prestaciones: hash_prestaciones }
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
