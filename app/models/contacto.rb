class Contacto < ActiveRecord::Base
  belongs_to :sexo
  validates_presence_of :mostrado
end
