# -*- encoding : utf-8 -*-
class DocumentoGenerablePorConcepto < ActiveRecord::Base
  belongs_to :concepto_de_facturacion
  belongs_to :documento_generable
  belongs_to :tipo_de_agrupacion
  
  attr_accessible :concepto_de_facturacion_id, :documento_generable_id, :tipo_de_agrupacion_id, :report_layout
  attr_accessible :genera_numeracion, :funcion_de_numeracion

  def generar(liquidacion)
    return eval("#{self.documentos_generables.modelo}.generar_desde_liquidacion(liquidacion, self)")
  end

  def obtener_numeracion(id_de_modelo)
  	if genera_numeracion
      return eval("#{self.documento_generable.modelo}.connection.select_value('#{documento_generable.funcion_de_numeracion}(id_de_modelo)')")
    else
      return nil
    end
  end


end
