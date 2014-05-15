# -*- encoding : utf-8 -*-
class DocumentoGenerable < ActiveRecord::Base
  has_many :documentos_generables_por_conceptos
  has_many :conceptos_de_facturacion, through: :documentos_generables_por_conceptos
  
  attr_accessible :modelo, :nombre
end
