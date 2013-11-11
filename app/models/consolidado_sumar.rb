class ConsolidadoSumar < ActiveRecord::Base
  belongs_to :efector
  belongs_to :firmate
  belongs_to :periodo
  belongs_to :liquidacion_sumar
  attr_accessible :fecha, :numero_de_consolidado
end
