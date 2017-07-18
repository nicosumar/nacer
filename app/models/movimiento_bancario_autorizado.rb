# -*- encoding : utf-8 -*-
class MovimientoBancarioAutorizado < ActiveRecord::Base

  belongs_to :cuenta_bancaria_origen, class_name: "CuentaBancaria", foreign_key: 'cuenta_bancaria_origen_id'
  belongs_to :cuenta_bancaria_destino, class_name: "CuentaBancaria", foreign_key: 'cuenta_bancaria_destino_id'
  belongs_to :concepto_de_facturacion

  attr_accessible :cuenta_bancaria_origen_id, :cuenta_bancaria_destino_id

end
