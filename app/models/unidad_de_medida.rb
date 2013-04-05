# -*- encoding : utf-8 -*-
class UnidadDeMedida < ActiveRecord::Base

  # Seguridad de asignaciones masivas
  attr_accessible :nombre, :codigo, :solo_enteros

  # Validaciones
  validates_presence_of :nombre

end
