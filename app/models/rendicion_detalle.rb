class RendicionDetalle < ActiveRecord::Base
  attr_accessible :cant, :detalle, :fecha, :importe_gasto, :nro_cheque, :nro_factura, :rendicion_id, :tipo_de_gasto_id, :fecha
  validates :cant, :detalle, :fecha, :importe_gasto, :nro_cheque, :nro_factura, :tipo_de_gasto_id, :fecha, presence: true
  validates :nro_factura, numericality: true
  belongs_to :tipo_de_gasto
  belongs_to :rendicion 
end