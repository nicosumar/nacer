class InformeDebitoPrestacional < ActiveRecord::Base
  belongs_to :concepto_de_facturacion
  belongs_to :efector
  belongs_to :tipo_de_debito_prestacional
  belongs_to :estado_del_proceso

  attr_accessible :informado_sirge, :procesado_para_debito,:concepto_de_facturacion, :efector, :tipo_de_debito_prestacional, :estado_del_proceso

  validates :concepto_de_facturacion, presence: true
  validates :efector, presence: true
  validates :tipo_de_debito_prestacional, presence: true
  validates :estado_del_proceso, presence: true

end
