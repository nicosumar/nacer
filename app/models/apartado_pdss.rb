# -*- encoding : utf-8 -*-
class ApartadoPdss < ActiveRecord::Base

  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre, :orden, :subgrupo_pdss_id

  # Asociaciones
  belongs_to :subgrupo_pdss

end
