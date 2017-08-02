class TipoDeGasto < ActiveRecord::Base
  
  belongs_to :clase_de_gasto
  attr_accessible :descripcion, :nombre, :numero, :references, :clase_de_gasto_id
  
end
