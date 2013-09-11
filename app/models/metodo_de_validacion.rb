# -*- encoding : utf-8 -*-
class MetodoDeValidacion < ActiveRecord::Base

  # Seguridad de asignaciones masivas
  attr_accessible :genera_error, :mensaje, :metodo, :nombre

  # Asociaciones
  has_one :regla
  has_and_belongs_to_many :prestaciones
  has_and_belongs_to_many :prestaciones_brindadas

end
