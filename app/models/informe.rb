class Informe < ActiveRecord::Base
  attr_accessible :titulo
  attr_accessible :sql
  attr_accessible :metodo_en_controller
  
  has_many :informes_filtros
end
