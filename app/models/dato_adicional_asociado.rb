# -*- encoding : utf-8 -*-
class DatoAdicionalAsociado < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :dato_adicional_id, :observaciones, :prestacion_brindada_id, :valor

  # Asociaciones
  belongs_to :dato_adicional
  belongs_to :prestacion_brindada

end
