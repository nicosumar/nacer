# -*- encoding : utf-8 -*-
class Nomenclador < ActiveRecord::Base

  attr_accessible :nombre, :fecha_de_inicio, :activo, :created_at, :updated_at

  has_many :asignaciones_de_precios
  has_many :prestaciones, through: :asignaciones_de_precios
  has_many :asignaciones_de_nomenclador
  has_many :efectores, :through => :asignaciones_de_nomenclador
  has_one :regla

  


  validates_presence_of :nombre, :fecha_de_inicio, :activo
end
