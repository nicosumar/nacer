# -*- encoding : utf-8 -*-
class DocumentoGenerable < ActiveRecord::Base
  has_many :documentos_generables_por_conceptos
  has_many :conceptos_de_facturacion, through: :documentos_generables_por_conceptos
  
  attr_accessible :modelo, :nombre

  def self.reporte(liquidacion, modelo)
    DocumentoGenerablePorConcepto.reporte(liquidacion, DocumentoGenerable.where(modelo: modelo.to_s))
  end

  def iterar(liquidacion)
    t = DocumentoGenerablePorConcepto.where(concepto_de_facturacion_id: liquidacion.concepto_de_facturacion.id, 
                                        documento_generable_id: self.id).first.tipo_de_agrupacion  
    if t.present?
      t.iterar_efectores_y_prestaciones_de(liquidacion) do |e, pliquidadas|
        yield e, pliquidadas
      end
    end
    
  end


end
