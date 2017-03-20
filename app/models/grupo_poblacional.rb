# -*- encoding : utf-8 -*-
class GrupoPoblacional < ActiveRecord::Base
  attr_accessible :codigo, :nombre

  # Asociaciones
  has_and_belongs_to_many :prestaciones_autorizadas, :class_name => "Prestacion"
  has_and_belongs_to_many :grupos_pdss, join_table: "grupos_permitidos"

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    grupo_poblacional = self.find_by_codigo(codigo.strip.upcase)
    if grupo_poblacional
      return grupo_poblacional.id
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
