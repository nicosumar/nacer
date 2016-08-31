# -*- encoding : utf-8 -*-
class DatoReportableRequerido < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :prestacion, :dato_reportable, :fecha_de_inicio, :fecha_de_finalizacion, :minimo, :maximo, :necesario, :obligatorio, :dato_reportable_id

  # Asociaciones
  belongs_to :dato_reportable
  belongs_to :prestacion

  validates_presence_of :prestacion, :dato_reportable, :fecha_de_inicio

end
