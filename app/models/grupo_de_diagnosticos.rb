# -*- encoding : utf-8 -*-
class GrupoDeDiagnosticos < ActiveRecord::Base
  
  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre

  # Asociaciones
  has_many :diagnosticos, inverse_of: :grupo_de_diagnosticos

end
