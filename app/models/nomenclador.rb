# -*- encoding : utf-8 -*-
class Nomenclador < ActiveRecord::Base

  attr_accessible :nombre, :fecha_de_inicio, :activo, :created_at, :updated_at, :asignaciones_de_precios_attributes, :asignaciones_de_nomenclador_attributes

  has_many :asignaciones_de_precios
  has_many :prestaciones, through: :asignaciones_de_precios
  has_many :asignaciones_de_nomenclador
  has_many :efectores, :through => :asignaciones_de_nomenclador
  has_one  :regla
  
  accepts_nested_attributes_for :asignaciones_de_precios, :asignaciones_de_nomenclador

  validates_presence_of :nombre, :fecha_de_inicio, :activo
end
