class EstadoDelProceso < ActiveRecord::Base
  has_many :liquidaciones_sumar_anexos_medicos
  has_many :liquidaciones_sumar_anexos_administrativos
  has_many :liquidaciones_informes
  has_many :informes_debitos_prestacionales
  has_many :cargas_masivas
  
  attr_accessible :codigo, :nombre
end
