# -*- encoding : utf-8 -*-
class AfiliadosController < ApplicationController
  before_filter :authenticate_user!

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

end
