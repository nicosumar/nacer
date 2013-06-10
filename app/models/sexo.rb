# -*- encoding : utf-8 -*-
class Sexo < ActiveRecord::Base

  # Asociaciones
  has_and_belongs_to_many :prestaciones_autorizadas, :class_name => "Prestacion"

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    sexo = self.find_by_codigo(codigo.strip.upcase)
    if sexo
      return sexo.id
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
