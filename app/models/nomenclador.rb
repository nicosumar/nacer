class Nomenclador < ActiveRecord::Base
  has_many :asignaciones_de_precios
  has_many :asignaciones_de_nomenclador
  has_many :efectores, :through => :asignaciones_de_nomenclador

  validates_presence_of :nombre, :fecha_de_inicio, :activo
end
