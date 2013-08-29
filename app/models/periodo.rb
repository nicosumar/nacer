class Periodo < ActiveRecord::Base

  belongs_to :tipo_periodo
  belongs_to :concepto_de_facturacion
  has_one :liquidacion_sumar
  
  attr_accessible :fecha_cierre, :fecha_recepcion, :periodo, :tipo_periodo_id

  validates :fecha_cierre, presence: true
  validates :periodo, presence: true
  validates :tipo_periodo, presence: true

  def prestacion_html
  	"Nombre: #{self.periodo} Fecha de Cierre: #{self.fecha_cierre}
  	 Fecha de Recepcoin: #{self.fecha_recepcion}
  	 Tipo de periodo: #{self.tipo_periodo.descripcion}
  	"
  end
end
