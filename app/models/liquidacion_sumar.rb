class LiquidacionSumar < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :formula
  belongs_to :grupo_de_efectores_liquidacion
  belongs_to :concepto_de_facturacion
end
