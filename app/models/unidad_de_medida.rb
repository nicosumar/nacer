# -*- encoding : utf-8 -*-
class UnidadDeMedida < ActiveRecord::Base

  # Seguridad de asignaciones masivas
  attr_accessible :nombre, :codigo, :solo_enteros

  # Validaciones
  validates_presence_of :nombre

  # id_del_codigo
  # Devuelve el ID asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    unidad_de_medida = self.find_by_codigo(codigo)

    if unidad_de_medida
      return unidad_de_medida.id
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
