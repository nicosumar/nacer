# -*- encoding : utf-8 -*-
class ConvenioDeAdministracionSumar < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :numero, :efector_id, :administrador_id, :firmante_id, :fecha_de_suscripcion, :fecha_de_inicio
  attr_accessible :fecha_de_finalizacion, :observaciones

  # Los atributos siguientes solo pueden asignarse durante la creación
  attr_readonly :numero, :administrador_id, :efector_id

  # Asociaciones
  belongs_to :administrador, :class_name => "Efector"
  belongs_to :firmante, :class_name => "Referente"
  belongs_to :efector

  # Validaciones
  validates_presence_of :numero, :administrador_id, :efector_id, :fecha_de_inicio
  validates_uniqueness_of :numero, :efector_id
  validate :verificar_fechas

  # verificar_fechas
  # Verifica que todos los campos de fecha contengan valores lógicos
  def verificar_fechas
    error_de_fecha = false

    # Fecha de suscripción
    if fecha_de_suscripcion && fecha_de_inicio && fecha_de_suscripcion > fecha_de_inicio
      errors.add(:fecha_de_suscripcion, 'no puede ser posterior a la fecha de inicio')
      error_de_fecha = true
    end

    # Fechas de inicio y finalización
    if fecha_de_inicio && fecha_de_finalizacion && fecha_de_inicio > fecha_de_finalizacion
      errors.add(:fecha_de_inicio, 'no puede ser posterior a la fecha de finalización')
      error_de_fecha = true
    end

    return !error_de_fecha
  end

end
