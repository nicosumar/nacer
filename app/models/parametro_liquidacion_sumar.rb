class ParametroLiquidacionSumar < ActiveRecord::Base
  belongs_to :formula
  has_many   :liquidaciones_sumar
  belongs_to :prestacion_rechazada, class_name: "EstadoDeLaPrestacion", foreign_key: 'rechazar_estado_de_la_prestacion_id'
  belongs_to :prestacion_aceptada, class_name: "EstadoDeLaPrestacion", foreign_key: 'aceptar_estado_de_la_prestacion_id'
  belongs_to :prestacion_exceptuada, class_name: "EstadoDeLaPrestacion", foreign_key: 'excepcion_estado_de_la_prestacion_id'

  attr_accessible :dias_de_prestacion, :formula_id
  attr_accessible :rechazar_estado_de_la_prestacion_id, :aceptar_estado_de_la_prestacion_id, :excepcion_estado_de_la_prestacion_id
end
