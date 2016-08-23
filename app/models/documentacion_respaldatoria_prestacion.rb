class DocumentacionRespaldatoriaPrestacion < ActiveRecord::Base

	attr_accessible :documentacion_respaldatoria_id, :prestacion_id, :fecha_de_inicio, :created_at, :updated_at

  belongs_to :prestacion
  belongs_to :documentacion_respaldatoria
	  
end
