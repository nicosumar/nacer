class InformeDebitoPrestacional < ActiveRecord::Base
  belongs_to :concepto_de_facturacion
  belongs_to :efector
  belongs_to :tipo_de_debito_prestacional
  belongs_to :estado_del_proceso

  attr_accessible :informado_sirge, :procesado_para_debito
  attr_accessible :concepto_de_facturacion_id, :efector_id, :tipo_de_debito_prestacional_id, :estado_del_proceso_id

  validates :concepto_de_facturacion, presence: true
  validates :efector, presence: true
  validates :tipo_de_debito_prestacional, presence: true
  validates :estado_del_proceso, presence: true

end
