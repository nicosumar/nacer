class Addenda < ActiveRecord::Base
  belongs_to :convenio_de_gestion
  has_many :prestaciones_autorizadas_alta, :as => :autorizante_al_alta, :class_name => "PrestacionAutorizada"
  has_many :prestaciones_autorizadas_baja, :as => :autorizante_de_la_baja, :class_name => "PrestacionAutorizada"

  validates_presence_of :convenio_de_gestion_id, :fecha_de_inicio
  validate :validar_fechas

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
