class ConvenioDeGestion < ActiveRecord::Base
  belongs_to :efector
  has_many :prestaciones_autorizadas, :as => :autorizante_al_alta
  has_many :addendas
  has_many :referentes

  validates_presence_of :numero, :efector_id, :fecha_de_inicio, :fecha_de_finalizacion
  validates_uniqueness_of :efector_id, :numero
  validate :validar_fechas

  def validar_fechas
    unless fecha_de_suscripcion.nil? or fecha_de_inicio.nil? then
      if fecha_de_suscripcion > fecha_de_inicio then
        errors.add(:fecha_de_suscripcion, "no puede ser posterior a la fecha de inicio.")
        return false
      end
    end
    unless fecha_de_finalizacion.nil? or fecha_de_inicio.nil? then
      if fecha_de_finalizacion < fecha_de_inicio then
        errors.add(:fecha_de_finalizacion, "no puede ser anterior a la fecha de inicio.")
        return false
      end
    end
    return true
  end
end
