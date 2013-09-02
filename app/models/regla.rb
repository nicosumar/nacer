class Regla < ActiveRecord::Base
  attr_accessible :nombre, :observaciones, :permitir

  belongs_to :metodo_de_validacion
  belongs_to :efector
  belongs_to :nomenclador
  belongs_to :prestacion
end
