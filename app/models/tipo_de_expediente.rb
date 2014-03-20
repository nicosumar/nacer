class TipoDeExpediente < ActiveRecord::Base
  attr_accessible :codigo, :nombre, :nombre_de_secuencia, :mascara
end
