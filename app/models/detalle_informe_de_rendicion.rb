class DetalleInformeDeRendicion < ActiveRecord::Base
  
  belongs_to :informe_de_rendicion
  
  belongs_to :tipo_de_importe

  attr_accessible :cantidad, :detalle, :fecha_factura, :numero, :numero_cheque, :numero_factura, :importe

  validates :cantidad, presence: true
  validates :detalle, presence: true 
  validates :numero, presence: true 
  validates :numero_cheque, presence: true 
  validates :numero_factura, presence: true 
  validates :importe, presence: true 
  
end
