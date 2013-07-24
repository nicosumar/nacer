class InformeFiltroValidadorUi < ActiveRecord::Base
  has_many :informes_filtros
  

  attr_accessible :tipo
  
  
end
