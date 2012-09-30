class Addenda < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Seguridad de asignaciones masivas
  attr_readonly :convenio_de_gestion_id, :fecha_de_inicio
  attr_accessible :firmante, :fecha_de_suscripcion, :observaciones

  # Asociaciones
  belongs_to :convenio_de_gestion
  has_many :prestaciones_autorizadas_alta, :as => :autorizante_al_alta, :class_name => "PrestacionAutorizada"
  has_many :prestaciones_autorizadas_baja, :as => :autorizante_de_la_baja, :class_name => "PrestacionAutorizada"

  # Validaciones
  validates_presence_of :convenio_de_gestion_id, :fecha_de_inicio
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
