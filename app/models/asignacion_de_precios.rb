# -*- encoding : utf-8 -*-
class AsignacionDePrecios < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :nomenclador_id, :prestacion_id, :precio_por_unidad, :adicional_por_prestacion, :unidades_maximas
  attr_accessible :observaciones, :created_at, :updated_at, :dato_reportable_id, :area_de_prestacion_id

  # Los atributos siguientes solo pueden asignarse durante la creación
  attr_readonly :nomenclador_id, :prestacion_id

  # Asociaciones
  belongs_to :nomenclador
  belongs_to :prestacion
  belongs_to :dato_reportable
  belongs_to :area_de_prestacion

  # Validaciones
  validates_presence_of :nomenclador_id, :prestacion_id, :precio_por_unidad
  validates_numericality_of :precio_por_unidad
  validates_numericality_of :adicional_por_prestacion
  validate :precio_mayor_que_cero
  validate :adicional_mayor_o_igual_que_cero
  #validate :debe_ser_unica

  scope :actuales, -> {select("DISTINCT on (prestacion_id, area_de_prestacion_id, dato_reportable_id) *").order("prestacion_id ASC, area_de_prestacion_id ASC, dato_reportable_id ASC, created_at DESC")}

  # precio_mayor_que_cero
  # Verifica que el precio_por_unidad sea mayor que cero (si existe)
  def precio_mayor_que_cero
    if precio_por_unidad && precio_por_unidad <= 0.0
      errors.add(:precio_por_unidad, 'debe tener un valor estrictamente mayor que cero')
      return false
    end
    return true
  end

  # adicional_mayor_o_igual_que_cero
  # Verifica que el adicional_por_prestacion sea mayor o igual que cero (si existe)
  def adicional_mayor_o_igual_que_cero
    if adicional_por_prestacion && adicional_por_prestacion < 0.0
      errors.add(:adicional_por_prestacion, 'debe tener un valor mayor o igual que cero')
      return false
    end
    return true
  end

  def debe_ser_unica    
    if AsignacionDePrecios.where("id != ?", self.id).where(nomenclador_id: nomenclador_id, prestacion_id: prestacion_id, area_de_prestacion_id: area_de_prestacion_id, dato_reportable_id: dato_reportable_id).present?
      errors.add(:base, 'Ya existe una asignación de precios con estas características para esta prestación')
      return false
    end
    return true
  end


end
