class Liquidacion < ActiveRecord::Base
  # Seguridad de asignaciones masivas
  attr_readonly :efector_id, :mes_de_prestaciones, :año_de_prestaciones
  attr_accessible :fecha_de_recepcion, :numero_de_expediente, :fecha_de_notificacion, :fecha_de_transferencia, :fecha_de_orden_de_pago
  attr_accessible :debitos_ugsp, :debitos_ace, :observaciones

  # Asociaciones
  belongs_to :efector
  has_many :cuasi_facturas

  # Validaciones
  validates_presence_of :efector_id, :mes_de_prestaciones, :año_de_prestaciones, :fecha_de_recepcion, :numero_de_expediente
  validates_uniqueness_of :numero_de_expediente
end
