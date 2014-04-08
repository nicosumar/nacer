# -*- encoding : utf-8 -*-
class AfiliadosController < ApplicationController
  before_filter :authenticate_user!

  require 'will_paginate/array'

  def show
    # Verificar los permisos del usuario
    if cannot? :read, Afiliado
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end

    # Obtener el beneficiario solicitado
    begin
      @afiliado = Afiliado.find(params[:id], :include => [:clase_de_documento, :tipo_de_documento, :sexo,
        :pais_de_nacimiento, :lengua_originaria, :tribu_originaria, :alfabetizacion_del_beneficiario,
        :domicilio_departamento, :domicilio_distrito, :lugar_de_atencion_habitual, :tipo_de_documento_de_la_madre,
        :alfabetizacion_de_la_madre, :tipo_de_documento_del_padre, :alfabetizacion_del_padre,
        :tipo_de_documento_del_tutor, :alfabetizacion_del_tutor, :discapacidad, :centro_de_inscripcion])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :notice => "El beneficiario solicitado no existe. El incidente será reportado al administrador del sistema.")
      return
    end

  end

  def busqueda_por_aproximacion
    begin
      cadena = params[:q].split(" ")
      x = params[:page]
      y = params[:per]

      numero = nil
      nombres = []

      cadena.each do |lexema|
        if lexema.to_i.to_s == lexema and numero.blank?
          numero = lexema
        elsif lexema.to_i.to_s == lexema and numero.present?
          next
        else
          nombres << lexema
        end
      end

      @afiliados = Afiliado.busqueda_por_aproximacion(numero, nombres.join(" "))
      if @afiliados[0].present? and @afiliados[0].size > 0
        #@afiliados[0].map!{ |af| {id: af.afiliado_id, text: "#{af.nombre}, #{af.apellido} (#{af.tipo_de_documento.codigo}: #{af.numero_de_documento})"}}
        @afiliados[0].map! do |af| 
          { 
            id: af.afiliado_id, 
            nombre: "#{af.apellido}, #{af.nombre}",
            documento: "#{af.tipo_de_documento.codigo}: #{af.numero_de_documento}",
            fecha_de_nacimiento: "#{af.fecha_de_nacimiento}",
            edad: "#{af.edad}",
            nombre_madre: "#{af.nombre_de_la_madre}, #{af.apellido_de_la_madre}",
            documento_madre:  af.tipo_de_documento_de_la_madre.present? ? "#{af.tipo_de_documento_de_la_madre.codigo}: #{af.numero_de_documento_de_la_madre}" : nil ,
            nombre_padre: "#{af.nombre_del_padre}, #{af.apellido_del_padre}",
            documento_padre: af.tipo_de_documento_del_padre.present? ? "#{af.tipo_de_documento_del_padre.codigo}: #{af.numero_de_documento_del_padre}" : nil,
            nombre_tutor: "#{af.nombre_del_tutor}, #{af.apellido_del_tutor}",
            documento_tutor: af.tipo_de_documento_del_tutor.present? ? "#{af.tipo_de_documento_del_tutor.codigo}: #{af.numero_de_documento_del_tutor}" : nil
          }
        end
      end

      respond_to do |format|
        if @afiliados[0].present? and @afiliados[0].size > 0
          format.json { 
            render json: {total: @afiliados[0].size ,afiliados: @afiliados[0].paginate(:page => x, :per_page => y) } 
          }
        else
          format.json { render json: {total: 0, afiliados: []}  }
        end
      end
      
    rescue Exception => e
      respond_to do |format|
        format.json { render json: {total: 0, afiliados: []}  }
      end
    end
  end

end
