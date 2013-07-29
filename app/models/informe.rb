class Informe < ActiveRecord::Base
  attr_accessible :titulo
  attr_accessible :sql
  attr_accessible :metodo_en_controller
  attr_accessible :formato
  
  has_many :informes_filtros
  has_many :informes_uads
  has_many :esquemas, :through => :informes_uads, :class_name => 'UnidadDeAltaDeDatos'
  
end
