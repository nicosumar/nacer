class InformeFiltro < ActiveRecord::Base
  
  #Relaciones
  belongs_to :informe_filtro_validador_ui
  belongs_to :informe
  
  #Atributos
  attr_accessible :nombre, :valor_por_defecto


end
