class TipoDeAgrupacion < ActiveRecord::Base
  
  has_many :documentos_generables_por_conceptos

  attr_accessible :nombre, :codigo
end
