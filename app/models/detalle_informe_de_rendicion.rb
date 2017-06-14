class DetalleInformeDeRendicion < ActiveRecord::Base
  
  belongs_to :informe_de_rendicion
  belongs_to :tipo_de_importe

  attr_accessible :cantidad, :detalle, :fecha_factura, :numero, :numero_cheque, :numero_factura, :importe, :informe_de_rendicion_id, :tipo_de_importe_id

  #validates_numericality_of :cantidad, presence: true, greater_than_or_equal_to: 0
  validates :detalle, presence: true 
  #validates_numericality_of :numero, presence: true, greater_than_or_equal_to: 0 
  #validates_numericality_of :numero_cheque, presence: true, greater_than_or_equal_to: 0 
  #validates_numericality_of :numero_factura, presence: true, greater_than_or_equal_to: 0 
  #validates_numericality_of :importe, presence: true, greater_than_or_equal_to: 0 
  
end