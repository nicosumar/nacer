class UnidadDeAltaDeDatos < ActiveRecord::Base

  # Asociaciones
  has_and_belongs_to_many :centros_de_inscripcion

end
