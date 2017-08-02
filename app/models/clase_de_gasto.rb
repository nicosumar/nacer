class ClaseDeGasto < ActiveRecord::Base
  
  has_many :tipos_de_gasto, :autosave => true, :dependent => :destroy
  attr_accessible :nombre, :numero
  
end
