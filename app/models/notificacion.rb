class Notificacion < ActiveRecord::Base
  
  belongs_to :unidad_de_alta_de_datos
  attr_accessible :enlace, :fecha_lectura, :mensaje, :unidad_de_alta_de_datos_id, :tiene_vista, :fecha_evento

end
