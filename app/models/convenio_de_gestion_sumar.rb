# -*- encoding : utf-8 -*-
class ConvenioDeGestionSumar < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :numero, :efector_id, :email, :fecha_de_suscripcion, :fecha_de_inicio
  attr_accessible :fecha_de_finalizacion, :observaciones, :firmante_id

  # Los atributos siguientes solo pueden asignarse durante la creación
  attr_readonly :numero, :efector_id

  # Asociaciones
  belongs_to :efector
  belongs_to :firmante, :class_name => "Referente"
  has_many :prestaciones_autorizadas, :as => :autorizante_al_alta
  has_many :prestaciones_pdss_autorizadas, :as => :autorizante_al_alta
  has_many :addendas_sumar

  # Validaciones
  validates_presence_of :numero, :efector_id, :fecha_de_inicio
  validates_uniqueness_of :efector_id
  validates_uniqueness_of :numero
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

  def prestaciones_pdss_autorizadas_ids(*ignorar)
    prestaciones_pdss_autorizadas.collect{|ppa| ppa.prestacion_pdss_id}
  end

end
