class InformeDebitoPrestacional < ActiveRecord::Base
  belongs_to :concepto_de_facturacion
  belongs_to :efector
  belongs_to :tipo_de_debito_prestacional
  belongs_to :estado_del_proceso
  has_many   :detalles_de_debitos_prestacionales

  attr_accessible :informado_sirge, :procesado_para_debito, :fecha_inicio, :fecha_finalizacion, :fecha_de_proceso
  attr_accessible :concepto_de_facturacion_id, :efector_id, :tipo_de_debito_prestacional_id, :estado_del_proceso_id
   
  validates :concepto_de_facturacion, presence: true
  validates :efector, presence: true
  validates :tipo_de_debito_prestacional, presence: true
  validates :estado_del_proceso, presence: true

  # Actualiza el estado del informe a "En Curso". Ademas guarda la fecha en la que se inicio
  def iniciar
    self.estado_del_proceso = EstadoDelProceso.find(2) #Estado En curso
    self.fecha_inicio = Date.today
    self.save
  end

end
