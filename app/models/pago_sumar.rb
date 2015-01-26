# -*- encoding : utf-8 -*-
class PagoSumar < ActiveRecord::Base
  belongs_to :efector
  belongs_to :concepto_de_facturacion
  belongs_to :cuenta_bancaria_origen, class_name: "CuentaBancaria", foreign_key: 'cuenta_bancaria_origen_id'
  belongs_to :cuenta_bancaria_destino, class_name: "CuentaBancaria", foreign_key: 'cuenta_bancaria_origen_id'
  belongs_to :fecha_de_proceso
  has_many   :expedientes_sumar
  has_many   :aplicaciones_de_notas_de_debito

  attr_accessible :fecha_de_notificacion, :fecha_informado_sirge, :informado_sirge, :notificado
  attr_accessible :cuenta_bancaria_origen_id, :cuenta_bancaria_destino_id, :efector_id, :concepto_de_facturacion_id
  
  accepts_nested_attributes_for :expedientes_sumar
  attr_accessible :expedientes_sumar
end