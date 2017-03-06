class SolicitudAddenda < ActiveRecord::Base
  belongs_to :efector
  attr_accessible :fecha_envio_a_efector, :fecha_revision_legal, :fecha_revision_medica, :fecha_solicitud, :observaciones
end
