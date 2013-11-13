class ConsolidadoSumarDetalle < ActiveRecord::Base
  belongs_to :consolidado_sumar
  belongs_to :efector
  belongs_to :convenio_de_administracion_sumar
  belongs_to :convenio_de_gestion_sumar
  
  attr_accessible :total
end
