class InformeFiltro < ActiveRecord::Base
  attr_accessible :nombre, :valor_por_defecto
  
  belongs_to :informe_filtro_validador_ui
  belongs_to :informe

end
