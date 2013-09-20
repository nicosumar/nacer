class LiquidacionSumarCuasifactura < ActiveRecord::Base
  
  belongs_to :liquidacion_sumar
  belongs_to :efector

  attr_accessible :monto_total, :numero_cuasifactura, :observaciones


end
