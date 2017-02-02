class DatoReportableRequeridoSirge < ActiveRecord::Base

  # Asociaciones
  belongs_to :prestacion
  belongs_to :dato_reportable_sirge

  # Atributos accesibles
  attr_accessible :prestacion, :dato_reportable_sirge, :orden

  # Validaciones
  validates :prestacion, :dato_reportable_sirge, :orden, presence: true

end
