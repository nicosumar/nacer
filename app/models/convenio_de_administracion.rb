class ConvenioDeAdministracion < ActiveRecord::Base
  belongs_to :administrador, :class_name => "Efector"
  belongs_to :efector

  validates_presence_of :numero, :administrador_id, :efector_id, :fecha_de_inicio, :fecha_de_finalizacion
  validates_uniqueness_of :efector_id
end
