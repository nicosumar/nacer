class ConsolidadoSumar < ActiveRecord::Base
  belongs_to :efector
  belongs_to :firmate, class_name: "Contacto"
  belongs_to :periodo
  belongs_to :liquidacion_sumar

  has_many :consolidados_sumar_detalles
  attr_accessible :fecha, :numero_de_consolidado
end
