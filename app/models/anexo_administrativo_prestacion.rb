class AnexoAdministrativoPrestacion < ActiveRecord::Base
  belongs_to :liquidacion_sumar_anexo_administrativo
  belongs_to :prestacion_liquidada
  belongs_to :estado_de_la_prestacion
  belongs_to :motivo_de_rechazo
  attr_accessible :observaciones
end
