class DatoReportableSirge < ActiveRecord::Base

  # Atributos accesibles
  attr_accessible :codigo, :funcion_de_transformacion, :nombre, :sirge_id

  # Asociaciones
  has_many :datos_reportables_sirge
  has_many :prestaciones, through: :datos_reportables_sirge
end
