class AplicacionDeNotaDeDebito < ActiveRecord::Base
  belongs_to :nota_de_debito
  attr_accessible :monto, :pago_sumar, :fecha_de_aplicacion
end
