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
  validate :fecha_de_inicio_superior_al_anterior

  after_create :cerrar_nomenclador_anterior

  def can_edit?
    return false if PrestacionLiquidada.where("created_at > ?", self.fecha_de_inicio).present?
    return false if (DateTime.now.to_date - self.created_at.to_date) > 30
    return true
  end

  private

    def cerrar_nomenclador_anterior
      new_date = self.fecha_de_inicio - 1.days
      Nomenclador.where(fecha_de_finalizacion: nil).where("id != ?", self.id).update_all(fecha_de_finalizacion: new_date)
    end
 
    def fecha_de_inicio_superior_al_anterior
      if self.new_record?
        last_nomenclador = Nomenclador.where(fecha_de_finalizacion: nil).order("fecha_de_inicio DESC").first
      else
        last_nomenclador = Nomenclador.where(fecha_de_finalizacion: nil).where("id != ?", self.id).order("fecha_de_inicio DESC").first
      end
      if fecha_de_inicio.present? && last_nomenclador.present?
        if self.fecha_de_inicio < last_nomenclador.fecha_de_inicio
          errors.add(:fecha_de_inicio, "Fecha de inicio no puede ser menor a la fecha de inicio del último nomenclador")
        end
        if last_nomenclador.fecha_de_finalizacion.present? && self.fecha_de_inicio < last_nomenclador.fecha_de_finalizacion
          errors.add(:fecha_de_inicio, "Fecha de inicio no puede ser menor a la fecha de finalización del último nomenclador")
        end
      end
    end
end
