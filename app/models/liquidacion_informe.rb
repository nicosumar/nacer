class LiquidacionInforme < ActiveRecord::Base
  
  belongs_to :liquidacion_sumar
  belongs_to :liquidacion_sumar_cuasifactura
  belongs_to :liquidacion_sumar_anexo_administrativo
  belongs_to :liquidacion_sumar_anexo_medico
  belongs_to :estado_del_proceso
  belongs_to :efector
  
  attr_accessible :numero_de_expediente, :observaciones

  validates_presence_of :numero_de_expediente
end
