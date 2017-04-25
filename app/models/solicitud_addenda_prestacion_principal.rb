class SolicitudAddendaPrestacionPrincipal < ActiveRecord::Base
  belongs_to :solicitud_addenda
  belongs_to :prestacion_principal

  attr_accessible :aprobado_por_medica, :es_autorizacion, :observaciones
end
