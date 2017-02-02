class InformeUad < ActiveRecord::Base
  
  belongs_to :informe
  belongs_to :esquema, :class_name => 'UnidadDeAltaDeDatos', :foreign_key => 'unidad_de_alta_de_datos_id'

  attr_accessible :informe_id
  attr_accessible :unidad_de_alta_de_datos_id
  attr_accessible :incluido

end
