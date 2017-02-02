# -*- encoding : utf-8 -*-
class MetodoDeValidacionFallado < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :metodo_de_validacion_id, :prestacion_brindada_id

  # Asociaciones
  belongs_to :metodo_de_validacion, :inverse_of => :metodos_de_validacion_fallados
  belongs_to :prestacion_brindada, :inverse_of => :metodos_de_validacion_fallados

end
