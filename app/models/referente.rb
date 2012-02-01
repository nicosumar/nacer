class Referente < ActiveRecord::Base
  belongs_to :efector
  belongs_to :contacto

  validates_presence_of :efector_id, :contacto_id

  def actual?()
    @fecha_finalizacion.nil?
  end

  def self.actual_del_efector(efector)
    Referente.where("efector_id = '?' AND fecha_de_finalizacion IS NULL", efector).first
  end
end
