# -*- encoding : utf-8 -*-
class DocumentoGenerablePorConcepto < ActiveRecord::Base
  belongs_to :concepto_de_facturacion
  belongs_to :documento_generable
  belongs_to :tipo_de_agrupacion
  
  attr_accessible :concepto_de_facturacion_id, :documento_generable_id, :tipo_de_agrupacion_id, :report_layout

end
