class LiquidacionSumar < ActiveRecord::Base
  belongs_to :formula
  belongs_to :grupo_de_efectores_liquidacion
  belongs_to :concepto_de_facturacion
  belongs_to :periodo

  attr_accessible :descripcion, :formula_id, :grupo_de_efectores_liquidacion_id, :concepto_de_facturacion_id, :periodo_id

end
