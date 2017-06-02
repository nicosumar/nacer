class CodigoDeGasto < ActiveRecord::Base
  attr_accessible :nombre, :numero
  has_many :subcodigos_de_gastos, :autosave => true,:dependent => :destroy
end
