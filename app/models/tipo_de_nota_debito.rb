class TipoDeNotaDebito < ActiveRecord::Base
  has_many :notas_de_debito
  attr_accessible :codigo, :nombre, :nombre_de_secuencia, :mascara
end
