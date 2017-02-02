class TipoDeExpediente < ActiveRecord::Base
  has_many :conceptos_de_facturacion
  
  attr_accessible :codigo, :nombre, :nombre_de_secuencia, :mascara
end
