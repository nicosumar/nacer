class ConceptoDeFacturacion < ActiveRecord::Base
  
  has_many :prestaciones
  has_many :periodos

  attr_accessible :concepto, :descripcion, :prestaciones, :concepto_facturacion_id

  validates :concepto, presence: true
  validates :descripcion, presence: true

end
