class PrestacionPrincipal < ActiveRecord::Base
  attr_accessible :activa, :codigo, :deleted_at, :nombre
  
  has_many :prestaciones
  has_many :prestaciones_pdss, through: :prestaciones  
  has_many :solicitudes_adddendas_prestaciones_principales
  scope :activas,->{}
  def full_codigo_y_nombre
    "#{self.codigo} - #{nombre}"
  end
end