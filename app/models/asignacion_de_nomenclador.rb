class AsignacionDeNomenclador < ActiveRecord::Base
  belongs_to :efector
  belongs_to :nomenclador

  validates_presence_of :efector_id, :nomenclador_id, :fecha_de_inicio

  def activo?
    return true if @fecha_de_finalizacion.nil?
  end
end
