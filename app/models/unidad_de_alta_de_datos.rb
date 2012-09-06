class UnidadDeAltaDeDatos < ActiveRecord::Base

  # Asociaciones
  has_and_belongs_to_many :centros_de_inscripcion
  has_and_belongs_to_many :users

end
