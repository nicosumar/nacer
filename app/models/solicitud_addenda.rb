class SolicitudAddenda < ActiveRecord::Base
  
  belongs_to :efector
  belongs_to :convenio_de_gestion_sumar
  has_many :solicitudes_addendas_prestaciones_principales, :autosave => true,:dependent => :destroy

  belongs_to :estado_solicitud_addenda
  
  attr_accessible :fecha_envio_efector, :fecha_revision_legal, :fecha_revision_medica, :fecha_solicitud,:convenio_de_gestion_sumar_id, :firmante, :observaciones, :estado_solicitud_addenda_id
  
end
