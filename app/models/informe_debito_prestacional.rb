class InformeDebitoPrestacional < ActiveRecord::Base
  belongs_to :concepto_de_facturacion
  belongs_to :efector
  belongs_to :tipo_de_debito_prestacional
  belongs_to :estado_del_proceso
  attr_accessible :informado_sirge, :procesado_para_debito
end
