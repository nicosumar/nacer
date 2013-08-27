class TipoPeriodo < ActiveRecord::Base
  
  has_many :periodos

  attr_accessible :descripcion, :tipo
  
  validates :descripcion, presence: true
  validates :tipo, presence: true
end
