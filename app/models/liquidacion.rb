# -*- encoding : utf-8 -*-
class Liquidacion < ActiveRecord::Base
  # Seguridad de asignaciones masivas
  attr_accessible :efector_id, :mes_de_prestaciones, :anio_de_prestaciones, :fecha_de_recepcion, :numero_de_expediente
  attr_accessible :fecha_de_notificacion, :fecha_de_transferencia, :fecha_de_orden_de_pago, :debitos_ugsp, :debitos_ace
  attr_accessible :observaciones
  attr_readonly :efector_id, :mes_de_prestaciones, :anio_de_prestaciones

  # Asociaciones
  belongs_to :efector
  has_many :cuasi_facturas

  # Validaciones
  validates_presence_of :efector_id, :mes_de_prestaciones, :anio_de_prestaciones, :fecha_de_recepcion, :numero_de_expediente
  validates_uniqueness_of :numero_de_expediente
  validates_uniqueness_of :mes_de_prestaciones, :scope => [:efector_id, :anio_de_prestaciones]
end
