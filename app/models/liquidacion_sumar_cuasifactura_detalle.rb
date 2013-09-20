class LiquidacionSumarCuasifacturaDetalle < ActiveRecord::Base
  belongs_to :liquidaciones_sumar_cuasifacturas
  belongs_to :prestacion_incluida
  belongs_to :estado_de_la_prestacion
  attr_accessible :monto, :observaciones
end
