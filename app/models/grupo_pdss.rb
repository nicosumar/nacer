# -*- encoding : utf-8 -*-
class GrupoPdss < ActiveRecord::Base

  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre, :orden

  # Asociaciones
  has_many :subgrupos_pdss

end
