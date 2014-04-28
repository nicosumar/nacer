class NotaDeDebito < ActiveRecord::Base
  belongs_to :efector
  belongs_to :concepto_de_facturacion
  belongs_to :tipo_de_nota_debito
  
  attr_accessible :monto, :numero, :observaciones, :remanente, :reservado
  attr_accessible :efector_id, :concepto_de_facturacion_id, :tipo_de_nota_debito_id 

  validates :monto, presence: true 
end
