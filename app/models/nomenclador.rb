# -*- encoding : utf-8 -*-
class Nomenclador < ActiveRecord::Base

  attr_accessible :nombre, :fecha_de_inicio, :activo, :created_at, :updated_at, :asignaciones_de_precios_attributes

  has_many :asignaciones_de_precios
  has_many :prestaciones, through: :asignaciones_de_precios
  has_many :asignaciones_de_nomenclador # Deprecated
  has_many :efectores, :through => :asignaciones_de_nomenclador # Deprecated
  has_one  :regla
  
  scope :ordenados, -> { order("fecha_de_inicio DESC") }

  accepts_nested_attributes_for :asignaciones_de_precios

  validates_presence_of :nombre, :fecha_de_inicio

  def can_edit?
    return false if PrestacionLiquidada.where("created_at > ?", self.fecha_de_inicio).present?
    return false if (DateTime.now.to_date - self.created_at.to_date) > 30
    return true
  end
end
