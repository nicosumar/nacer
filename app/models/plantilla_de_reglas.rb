# -*- encoding : utf-8 -*-
class PlantillaDeReglas < ActiveRecord::Base
  
  has_and_belongs_to_many :reglas
  has_many :liquidaciones_sumar

  attr_accessible :nombre, :observaciones

  validates_presence_of :nombre, :observaciones
  validates_uniqueness_of :nombre

end
