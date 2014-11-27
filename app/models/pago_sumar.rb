class PagoSumar < ActiveRecord::Base
  belongs_to :efector
  belongs_to :concepto_de_facturacion
  belongs_to :cuenta_bancaria_origen, class_name: "CuentaBancaria", foreign_key: 'cuenta_bancaria_origen_id'
  belongs_to :cuenta_bancaria_detino, class_name: "CuentaBancaria", foreign_key: 'cuenta_bancaria_origen_id'
  belongs_to :fecha_de_proceso
  has_many   :informes_para_pago
  has_many   :aplicaciones_de_notas_de_debito

  attr_accessible :fecha_de_notificacion, :fecha_informado_sirge, :informado_sirge, :notificado
  
  attr_accessible :cuenta_bancaria_origen_id, :cuenta_bancaria_destino_id
end