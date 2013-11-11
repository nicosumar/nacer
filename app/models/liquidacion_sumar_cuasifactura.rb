class LiquidacionSumarCuasifactura < ActiveRecord::Base
  
  belongs_to :liquidacion_sumar
  belongs_to :efector

  scope :para, lambda {|efector, liquidacion| where(efector_id: efector.id, liquidacion_id: liquidacion.id)}

  attr_accessible :monto_total, :numero_cuasifactura, :observaciones


end
