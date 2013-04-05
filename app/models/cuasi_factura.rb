# -*- encoding : utf-8 -*-
class CuasiFactura < ActiveRecord::Base
  # Seguridad de asignaciones masivas
  attr_accessible :liquidacion_id, :efector_id, :nomenclador_id
  attr_accessible :fecha_de_presentacion, :numero, :total_informado, :observaciones
  attr_readonly :liquidacion_id, :efector_id, :nomenclador_id

  # Asociaciones
  belongs_to :liquidacion
  belongs_to :efector
  has_many :renglones_de_cuasi_facturas
  has_many :registros_de_prestaciones

  # Validaciones
  validates_presence_of :liquidacion_id, :efector_id, :nomenclador_id, :fecha_de_presentacion, :numero
end
