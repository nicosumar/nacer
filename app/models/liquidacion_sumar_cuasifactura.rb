class LiquidacionSumarCuasifactura < ActiveRecord::Base
  belongs_to :liquidacion
  belongs_to :efector
  belongs_to :prestacion_incluida
  belongs_to :estado_de_la_prestacion
  attr_accessible :monto, :observaciones
end
