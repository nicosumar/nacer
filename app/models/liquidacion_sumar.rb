class LiquidacionSumar < ActiveRecord::Base
  belongs_to :formula
  belongs_to :grupo_de_efectores_liquidacion
  belongs_to :concepto_de_facturacion
  belongs_to :periodo
  belongs_to :plantilla_de_reglas


  attr_accessible :descripcion, :formula_id, :grupo_de_efectores_liquidacion_id, :concepto_de_facturacion_id, :periodo_id

  validates :descripcion, presence: true
  validates :grupo_de_efectores_liquidacion, presence:true
  validates :formula, presence: true
  validates :concepto_de_facturacion, presence: true
  validates :periodo, presence: true

end
