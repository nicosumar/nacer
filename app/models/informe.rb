class Informe < ActiveRecord::Base
  has_many :informes_filtros
  has_many :informes_uads
  has_many :esquemas, :through => :informes_uads, :class_name => 'UnidadDeAltaDeDatos'
  
  accepts_nested_attributes_for :informes_filtros, :reject_if => :all_blank, :allow_destroy => true
  
  attr_accessible :titulo
  attr_accessible :sql
  attr_accessible :metodo_en_controller
  attr_accessible :formato
  attr_accessible :informes_filtros_attributes

  #"Sexy" validations
  validates :titulo, presence: true
  validates :sql, presence: true
  validates :metodo_en_controller, presence: true
  validates :formato, presence: true

  validates_associated :informes_filtros
  



end
