class AnexoMedicoPrestacion < ActiveRecord::Base
  belongs_to :liquidacion_sumar_anexo_medico
  belongs_to :prestacion_liquidada
  belongs_to :estado_de_la_prestacion
  belongs_to :motivo_de_rechazo
  attr_accessible :observaciones
end
