# -*- encoding : utf-8 -*-
class MetodoDeValidacion < ActiveRecord::Base
  attr_accessible :genera_error, :mensaje, :metodo, :nombre
  has_one :regla
  has_and_belongs_to_many :prestaciones
end
