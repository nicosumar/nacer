# -*- encoding : utf-8 -*-
class LineaDeCuidado < ActiveRecord::Base

  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre

  scope :ordenadas, -> { order("nombre ASC") }

  def nombre_y_codigo
    return self.nombre + " - " + self.codigo
  end
end
