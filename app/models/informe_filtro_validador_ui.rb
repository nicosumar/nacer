class InformeFiltroValidadorUi < ActiveRecord::Base
  belongs_to :informe_filtro
  

  attr_accessible :tipo
  
  
end
