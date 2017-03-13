class PrestacionPrincipal < ActiveRecord::Base
  attr_accessible :activa, :codigo, :deleted_at, :nombre
  
  has_many :prestaciones
  has_many :prestaciones_pdss, through: :prestaciones  

  scope :activas,->{}
  def full_codigo_y_nombre
    "#{self.codigo} - #{nombre}"
  end
end