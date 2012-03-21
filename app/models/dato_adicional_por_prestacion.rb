class DatoAdicionalPorPrestacion < ActiveRecord::Base
  belongs_to :dato_adicional
  belongs_to :prestacion
end
