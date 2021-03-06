# -*- encoding : utf-8 -*-
class Addenda < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :convenio_de_gestion_id, :firmante, :fecha_de_suscripcion, :fecha_de_inicio, :observaciones, :numero

  # Los atributos siguientes solo pueden asignarse durante la creación
  attr_readonly :convenio_de_gestion_id, :fecha_de_inicio, :numero

  # Asociaciones
  belongs_to :convenio_de_gestion
  has_many :prestaciones_autorizadas_alta, :as => :autorizante_al_alta, :class_name => "PrestacionAutorizada"
  has_many :prestaciones_autorizadas_baja, :as => :autorizante_de_la_baja, :class_name => "PrestacionAutorizada"

  # Validaciones
  validates_presence_of :convenio_de_gestion_id, :fecha_de_inicio
  validates_uniqueness_of :numero
  validate :validar_fechas

  # Verifica que la fecha de suscripción no sea posterior a la fecha de inicio
  def validar_fechas
    unless fecha_de_suscripcion.nil? or fecha_de_inicio.nil? then
      if fecha_de_suscripcion > fecha_de_inicio then
        errors.add(:fecha_de_suscripcion, "no puede ser posterior a la fecha de inicio.")
        return false
      end
    end
    return true
  end
end
