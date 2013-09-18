class LiquidacionSumarCuasifacturaDetalle < ActiveRecord::Base
  belongs_to :liquidacion_sumar
  belongs_to :efector
  attr_accessible :monto, :numero_cuasifactura, :observaciones
end
