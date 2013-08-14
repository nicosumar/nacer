class InformeFiltro < ActiveRecord::Base
  
  #Relaciones
  belongs_to :informe_filtro_validador_ui
  belongs_to :informe
  
  #"sexy" validations
  validates :nombre, presence: true
  validates :valor_por_defecto, presence: true
  
  #Atributos
  attr_accessible :nombre, :valor_por_defecto, :informe_filtro_validador_ui_id, :posicion

end
