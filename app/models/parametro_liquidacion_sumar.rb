class ParametroLiquidacionSumar < ActiveRecord::Base
  belongs_to :formula
  belongs_to :nomenclador 
  has_many   :liquidaciones_sumar


  attr_accessible :dias_de_prestacion, :formula_id, :nomenclador_id
end
