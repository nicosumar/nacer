# -*- encoding : utf-8 -*-
class GrupoPdss < ActiveRecord::Base

  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :nombre, :codigo, :seccion_pdss_id, :prestaciones_modularizadas, :orden

  # Asociaciones
  belongs_to :seccion_pdss
  has_many :prestaciones_pdss
  has_and_belongs_to_many :grupos_poblacionales, join_table: "grupos_permitidos"
  has_and_belongs_to_many :sexos, join_table: "grupos_permitidos"

end
