class SolicitudAddendaPrestacion < ActiveRecord::Base
  belongs_to :solicitud_addenda
  attr_accessible :aprobacion_medica, :es_autorizacion, :observaciones
end
