class Formula < ActiveRecord::Base
  has_many :parametros_liquidaciones_sumar
  attr_accessible :descripcion, :formula, :observaciones, :activa
end
