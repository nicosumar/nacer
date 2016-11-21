class PrestacionLiquidadaDato < ActiveRecord::Base
  belongs_to :dato_reportable
  belongs_to :dato_reportable_requerido
  belongs_to :prestacion_liquidada
  
  attr_accessible :adicional_por_prestacion, :dato_reportable_nombre, :liquidacion_id, :precio_por_unidad, :prestacion_liquidada_id, :valor_big_decimal, :valor_date, :valor_integer, :valor_string

  def nombre
    self.dato_reportable.present? ? self.dato_reportable.nombre : "Base"
  end

  def cantidad
    self.dato_reportable.present? ? self.valor_integer : self.prestacion_liquidada.cantidad_de_unidades
  end

  def subtotal
    cantidad * precio_por_unidad
  end
end
