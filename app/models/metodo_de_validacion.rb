# -*- encoding : utf-8 -*-
class MetodoDeValidacion < ActiveRecord::Base

  # Seguridad de asignaciones masivas
  attr_accessible :genera_error, :mensaje, :metodo, :nombre

  # Asociaciones
  has_one :regla
  has_and_belongs_to_many :prestaciones
  has_many :metodos_de_validacion_fallados, :inverse_of => :metodo_de_validacion
  has_many :prestaciones_brindadas, :through => :metodos_de_validacion_fallados

end
