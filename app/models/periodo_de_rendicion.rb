class PeriodoDeRendicion < ActiveRecord::Base
  attr_accessible :fecha_desde, :fecha_hasta, :nombre
   has_many :rendiciones
end 
