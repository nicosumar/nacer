class HistoricoPrestacion < ActiveRecord::Base
  belongs_to :prestacion
  belongs_to :prestacion_anterior, foreign_key: :prestacion_anterior_id, class_name: "Prestacion"
  attr_accessible :prestacion, :prestacion_anterior
end
