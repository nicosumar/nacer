class Contacto < ActiveRecord::Base
  belongs_to :sexo
  has_many :efectores_a_cargo, :class_name => "Efector", :foreign_key => "efector_id", :through => :referentes

  validates_presence_of :mostrado
  validates_numericality_of :dni, :allow_nil => true
end
