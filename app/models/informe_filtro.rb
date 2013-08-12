class InformeFiltro < ActiveRecord::Base
  
  #Relaciones
  has_one :informe_filtro_validador_ui
  belongs_to :informe
  
  #"sexy" validations
  validates :nombre, presence: true
  validates :valor_por_defecto, presence: true
  
  #Atributos
  attr_accessible :nombre, :valor_por_defecto, :informe_filtro_validador_ui



end
