# -*- encoding : utf-8 -*-
class EstadoDeLaPrestacion < ActiveRecord::Base

  # Seguridad de asignaciones masivas
  attr_accessible :codigo, :indexable, :nombre, :pendiente

  # id_del_codigo
  # Devuelve el ID asociado con el código pasado
  def self.id_del_codigo(codigo)
    return nil if codigo.blank?
    find_by_codigo(codigo).id
  end

end
