class InformeParaPago < ActiveRecord::Base
  belongs_to :liquidacion_informe
  belongs_to :pago_sumar
  attr_accessible :monto_aprobado
end
