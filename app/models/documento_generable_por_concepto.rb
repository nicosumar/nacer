# -*- encoding : utf-8 -*-
class DocumentoGenerablePorConcepto < ActiveRecord::Base
  belongs_to :concepto_de_facturacion
  belongs_to :documento_generable
  belongs_to :tipo_de_agrupacion
  
  attr_accessible :concepto_de_facturacion_id, :documento_generable_id, :tipo_de_agrupacion_id, :report_layout
  attr_accessible :genera_numeracion, :funcion_de_numeracion, :orden

  validates_presence_of :concepto_de_facturacion_id, :documento_generable_id, :tipo_de_agrupacion_id, :orden

  def generar(liquidacion)
    return eval("#{self.documento_generable.modelo}.generar_desde_liquidacion!(liquidacion, self)")
  end

  def obtener_numeracion(id_de_modelo)
  	if genera_numeracion 
      case self.documento_generable.modelo
      
      when 'LiquidacionSumarCuasifactura'
        # Si es de esta provincia lo genero
        
        if LiquidacionSumarCuasifactura.find(id_de_modelo).efector.provincia.id == Parametro.valor_del_parametro(:id_de_esta_provincia)
          return ActiveRecord::Base.connection.select_value("select #{self.funcion_de_numeracion}(#{id_de_modelo})")
        else #es de otra provincia.
          return nil
        end
      else # Otro modelo (LiquidacionInforme, ExpedienteSumar, etc)
        return ActiveRecord::Base.connection.select_value("select #{self.funcion_de_numeracion}(#{id_de_modelo})")
      end
    else
      return nil
    end
  end

  # 
  # Devuelve el reporte para un Documento Generable segun su liquidación
  # @param liquidacion [LiquidacionSumar] [Liquidacion refereida]
  # @param documento_generable [DocumentoGenerable] [La clase que se corresponde al documento generable]
  # 
  # @return [String] [string con el documento generable]
  def self.reporte(liquidacion, documento_generable)
    DocumentoGenerablePorConcepto.where(concepto_de_facturacion_id: liquidacion.concepto_de_facturacion, documento_generable_id: documento_generable).first.report_layout
  end

end
