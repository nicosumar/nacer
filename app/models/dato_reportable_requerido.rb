# -*- encoding : utf-8 -*-
class DatoReportableRequerido < ActiveRecord::Base

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :prestacion, :dato_reportable, :fecha_de_inicio, :fecha_de_finalizacion, :minimo, :maximo, :necesario, :obligatorio, :dato_reportable_id

  # Asociaciones
  belongs_to :dato_reportable
  belongs_to :prestacion

  validates_presence_of :prestacion, :dato_reportable, :fecha_de_inicio

  scope :activos, -> {where("fecha_de_finalizacion IS NULL")}

  after_initialize :set_default_fecha_de_inicio

  def set_default_fecha_de_inicio
    self.fecha_de_inicio = DateTime.parse("2016-01-01").to_date if self.fecha_de_inicio.blank?
  end
end
