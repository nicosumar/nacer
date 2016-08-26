class CantidadDePrestacionesPorPeriodo < ActiveRecord::Base

  attr_accessible :cantidad_maxima, :intervalo, :periodo, :prestacion_id

  validates :cantidad_maxima, presence: true

  belongs_to :prestacion

end
