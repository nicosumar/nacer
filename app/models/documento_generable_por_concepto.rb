# -*- encoding : utf-8 -*-
class DocumentoGenerablePorConcepto < ActiveRecord::Base
  belongs_to :concepto_de_facturacion
  belongs_to :documento_generable
  belongs_to :tipo_de_agrupacion
  
  attr_accessible :concepto_de_facturacion_id, :documento_generable_id, :tipo_de_agrupacion_id, :report_layout

  # 
  # Genera los documentos asociados al concepto correspondiente
  # 
  # @return [type] [description]
  def generar

    eval(self.documento_generable.modelo).

  end
end
