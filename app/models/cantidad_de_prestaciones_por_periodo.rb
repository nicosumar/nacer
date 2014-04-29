class CantidadDePrestacionesPorPeriodo < ActiveRecord::Base

  attr_accessible :cantidad_maxima, :intervalo, :periodo, :prestacion_id

  belongs_to :prestacion

end
