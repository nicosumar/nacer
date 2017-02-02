class PrestacionLiquidadaAdvertencia < ActiveRecord::Base
  belongs_to :prestacion_liquidada
  belongs_to :metodo_de_validacion
  attr_accessible :comprobacion, :mensaje
end
