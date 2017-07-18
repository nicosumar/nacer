class DetalleInformeDeRendicion < ActiveRecord::Base
  
  belongs_to :informe_de_rendicion
  belongs_to :tipo_de_importe
  belongs_to :tipo_de_gasto

  attr_accessible :cuenta, :cantidad, :detalle, :fecha_factura, :numero, :numero_cheque, :numero_factura, :importe, :informe_de_rendicion_id, :tipo_de_importe_id, :tipo_de_gasto_id

  validates :detalle, presence: true

	def importe_servicios

	 	return (tipo_de_importe_id == 1) ? importe : 0

	end

	def importe_obras

	 	return (tipo_de_importe_id == 2) ? importe : 0

	end

	def importe_ctes

	 	return (tipo_de_importe_id == 3) ? importe : 0

	end

	def importe_capital

	 	return (tipo_de_importe_id == 4) ? importe : 0

	end

end