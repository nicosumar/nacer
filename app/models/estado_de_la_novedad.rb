# -*- encoding : utf-8 -*-
class EstadoDeLaNovedad < ActiveRecord::Base

  # id_del_codigo
  # Devuelve el ID asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    estado_de_la_novedad = self.find_by_codigo(codigo.strip.upcase)
    if estado_de_la_novedad
      return estado_de_la_novedad.id
    else
      return nil
    end
  end
  def self.id_del_codigo!(codigo)
    codigo_id = self.id_del_codigo(codigo)
    raise ActiveRecord::RecordNotFound if codigo_id.nil?
    return codigo_id
  end
end
