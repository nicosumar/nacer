class AsignacionDePrecios < ActiveRecord::Base
  belongs_to :nomenclador
  belongs_to :prestacion

  validates_presence_of :nomenclador_id, :prestacion_id, :precio_por_unidad
  validates_numericality_of :precio_por_unidad
  validates_numericality_of :adicional_por_prestacion, :unless => "@adicional_por_prestacion.nil?"
  validate :precio_mayor_que_cero
  validate :adicional_mayor_o_igual_que_cero

  def precio_mayor_que_cero
    return false if not @precio_por_unidad.nil? and @precio_por_unidad <= 0.0
  end

  def adicional_mayor_o_igual_que_cero
    return false if not @adicional_por_prestacion.nil? and @adicional_por_prestacion < 0.0
  end
end
