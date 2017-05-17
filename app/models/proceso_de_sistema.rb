class ProcesoDeSistema < ActiveRecord::Base
  belongs_to :tipo_proceso_de_sistema
  belongs_to :estado_proceso_de_sistema
  has_one :delayed_job, :class_name => 'Delayed::Backend::ActiveRecord::Job'
  attr_accessible :descripcion, :fecha_completado,:estado_proceso_de_sistema_id,:tipo_proceso_de_sistema_id,:entidad_relacionada_id
end
