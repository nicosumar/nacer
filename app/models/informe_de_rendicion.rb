class InformeDeRendicion < ActiveRecord::Base

	belongs_to :estado_del_proceso
	belongs_to :efector

	has_many :detalles_informe_de_rendicion, :autosave => true, :dependent => :destroy
  	
  	attr_accessible :fecha_informe, :total, :efector_id, :estado_del_proceso_id
  	
  	accepts_nested_attributes_for :detalles_informe_de_rendicion, :reject_if => :all_blank, :allow_destroy => true
  	
end
