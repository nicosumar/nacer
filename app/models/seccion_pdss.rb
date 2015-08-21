# -*- encoding : utf-8 -*-
class SeccionPdss < ActiveRecord::Base

  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre, :orden

  # Asociaciones
  has_many :grupos_pdss

end
