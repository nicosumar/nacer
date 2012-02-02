class Referente < ActiveRecord::Base
  belongs_to :efector
  belongs_to :contacto

  validates_presence_of :efector_id, :contacto_id, :fecha_de_inicio
  validate :validar_fechas

  def validar_fechas
    if fecha_de_finalizacion && fecha_de_finalizacion <= fecha_de_inicio
      errors.add(:fecha_de_finalizacion, "debe ser posterior a la fecha de inicio.")
      return false
    end

    referentes = Referente.where({:efector_id => efector_id}, {:include => :contacto})
    referentes.each do |r|
      if r.id != id
        case
          when fecha_de_inicio < r.fecha_de_inicio && (fecha_de_finalizacion.nil? || fecha_de_finalizacion > r.fecha_de_inicio)
            errors.add(:fecha_de_inicio, "crearía un periodo que se superpone con el de otro referente (" + r.contacto.mostrado + ").")
            if fecha_de_finalizacion
              errors.add(:fecha_de_finalizacion, "crearía un periodo que se superpone con el de otro referente (" + r.contacto.mostrado + ").")
            end
            return false
          when fecha_de_inicio >= r.fecha_de_inicio && r.fecha_de_finalizacion && fecha_de_inicio < r.fecha_de_finalizacion
            errors.add(:fecha_de_inicio, "crearía un periodo que se superpone con el de otro referente (" + r.contacto.mostrado + ").")
            if fecha_de_finalizacion
              errors.add(:fecha_de_finalizacion, "crearía un periodo que se superpone con el de otro referente (" + r.contacto.mostrado + ").")
            end
            return false
        end
      end
    end

    return true
  end

  def actual?()
    @fecha_finalizacion.nil?
  end

  def self.actual_del_efector(efector)
    Referente.where("efector_id = '?' AND fecha_de_finalizacion IS NULL", efector).first
  end
end
