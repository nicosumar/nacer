class EstadoDelProceso < ActiveRecord::Base
  
  # Asociaciones referentes a los procesos de liquidacion
  has_many :liquidaciones_sumar_anexos_medicos
  has_many :liquidaciones_sumar_anexos_administrativos
  has_many :liquidaciones_informes
  has_many :informes_debitos_prestacionales

  # Asociaciones referentes a los procesos de pago
  has_many :pagos_sumar
  
  attr_accessible :codigo, :nombre
end
