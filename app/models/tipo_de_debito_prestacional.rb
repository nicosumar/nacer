class TipoDeDebitoPrestacional < ActiveRecord::Base
  
  has_many :informes_debitos_prestacionales
  
  attr_accessible :nombre

  validates :nombre, presence: true
end
