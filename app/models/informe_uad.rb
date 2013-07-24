class InformeUad < ActiveRecord::Base
  
  belongs_to :informe
  belongs_to :unidad_de_alta_de_datos

  attr_accessible :incluido

end
