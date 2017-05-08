class ProcesoDeSistema < ActiveRecord::Base
  belongs_to :tipo_proceso_de_sistema
  belongs_to :estado_proceso_de_sistema
  attr_accessible :descripcion, :fecha_completado
end
