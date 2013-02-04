# -*- encoding : utf-8 -*-
class AgrupacionDeBeneficiariosPrestacion < ActiveRecord::Base
  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :agrupacion_de_beneficiarios_id, :prestacion_id, :nombre, :activa

  # Validaciones
  validates_presence_of :agrupacion_de_beneficiarios_id, :prestacion_id, :nombre

end
