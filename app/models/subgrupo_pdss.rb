# -*- encoding : utf-8 -*-
class SubgrupoPdss < ActiveRecord::Base

  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :grupo_pdss_id, :nombre, :orden

  # Asociaciones
  belongs_to :grupo_pdss
  has_many :apartados_pdss

end
