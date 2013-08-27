class Formula < ActiveRecord::Base
  has_many :liquidaciones
  attr_accessible :descripcion, :formula, :observaciones, :activa
end
