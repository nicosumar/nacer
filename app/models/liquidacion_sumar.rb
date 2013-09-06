class LiquidacionSumar < ActiveRecord::Base
  belongs_to :formula
  belongs_to :grupo_de_efectores_liquidacion
  belongs_to :concepto_de_facturacion
  belongs_to :periodo
  belongs_to :plantilla_de_reglas


  attr_accessible :descripcion, :formula_id, :grupo_de_efectores_liquidacion_id, :concepto_de_facturacion_id, :periodo_id, :plantilla_de_reglas_id

  validates_presence_of :descripcion, :grupo_de_efectores_liquidacion, :formula, :concepto_de_facturacion, :periodo
  
end
