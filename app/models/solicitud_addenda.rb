class SolicitudAddenda < ActiveRecord::Base
  
  belongs_to :efector
  belongs_to :convenio_de_gestion_sumar
  has_many :solicitudes_addendas_prestaciones_principales
  belongs_to :estado_solicitud_addenda
  
  attr_accessible :fecha_envio_efector, :fecha_revision_legal, :fecha_revision_medica, :fecha_solicitud
  
  
  
 def siguiente_numero_solicitud_addenda (convenio_de_gestion_sumar)
      


 end




end
