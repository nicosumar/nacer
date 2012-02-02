class Contacto < ActiveRecord::Base
  belongs_to :sexo

  validates_presence_of :mostrado
  validates_numericality_of :dni, :allow_nil => true
end
