class SubcodigoDeGasto < ActiveRecord::Base
  belongs_to :codigo_de_gasto
  attr_accessible :nombre, :numero
end
