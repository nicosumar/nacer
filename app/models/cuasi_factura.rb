class CuasiFactura < ActiveRecord::Base
  # Seguridad de asignaciones masivas
  attr_readonly :liquidacion_id, :efector_id, :nomenclador_id
  attr_accessible :fecha_de_presentacion, :numero_de_liquidacion, :observaciones

  # Asociaciones
  belongs_to :liquidacion
  belongs_to :efector
  belongs_to :nomenclador
  has_many :renglones_de_cuasi_facturas
  has_many :registros_de_prestaciones

  # Validaciones
  validates_presence_of :liquidacion_id, :efector_id, :nomenclador_id, :fecha_de_presentacion, :numero_de_liquidacion
end
