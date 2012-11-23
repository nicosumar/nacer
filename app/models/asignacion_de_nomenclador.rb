class AsignacionDeNomenclador < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :efector_id, :nomenclador_id, :fecha_de_inicio, :fecha_de_finalizacion, :observaciones

  # Los atributos siguientes solo pueden asignarse durante la creación
  attr_readonly :efector_id, :nomenclador_id, :fecha_de_inicio

  # Asociaciones
  belongs_to :efector
  belongs_to :nomenclador

  # Validaciones
  validates_presence_of :efector_id, :nomenclador_id, :fecha_de_inicio
  validate :verificar_fechas

  # verificar_fechas
  # Verifica que todos los campos de fecha contengan valores lógicos
  def verificar_fechas
    # Fecha de inicio
    if fecha_de_inicio && fecha_de_finalizacion && fecha_de_inicio > fecha_de_finalizacion
      errors.add(:fecha_de_inicio, 'no puede ser posterior a la fecha de finalización')
    end
  end

  # activa?
  # Indica si la asignación de nomenclador está activa actualmente
  def activa?
    return true if @fecha_de_finalizacion.nil?
  end
end
