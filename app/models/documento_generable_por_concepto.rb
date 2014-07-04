# -*- encoding : utf-8 -*-
class DocumentoGenerablePorConcepto < ActiveRecord::Base
  belongs_to :concepto_de_facturacion
  belongs_to :documento_generable
  belongs_to :tipo_de_agrupacion
  
  attr_accessible :concepto_de_facturacion_id, :documento_generable_id, :tipo_de_agrupacion_id, :report_layout
  attr_accessible :genera_numeracion, :funcion_de_numeracion, :orden

  validates_presence_of :concepto_de_facturacion_id, :documento_generable_id, :tipo_de_agrupacion_id, :orden

  def generar(liquidacion)
    return eval("#{self.documento_generable.modelo}.generar_desde_liquidacion(liquidacion, self)")
  end

  def obtener_numeracion(id_de_modelo)
  	if genera_numeracion
      return ActiveRecord::Base.connection.select_value("select #{self.funcion_de_numeracion}(#{id_de_modelo})")
    else
      return nil
    end
  end

end
