class Regla < ActiveRecord::Base
  attr_accessible :nombre, :observaciones, :permitir
  attr_accessible :efector_id, :nomenclador_id, :prestacion_id, :metodo_de_validacion_id

  belongs_to :metodo_de_validacion
  belongs_to :efector
  belongs_to :nomenclador
  belongs_to :prestacion
  has_and_belongs_to_many :plantillas_de_reglas

  validates_presence_of :nombre, :metodo_de_validacion, :efector, :nomenclador, :prestacion
  validates_uniqueness_of :nombre
end
