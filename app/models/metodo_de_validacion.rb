class MetodoDeValidacion < ActiveRecord::Base
  attr_accessible :genera_error, :mensaje, :metodo, :nombre
end
