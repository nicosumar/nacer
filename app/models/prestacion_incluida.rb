class PrestacionIncluida < ActiveRecord::Base

  has_many :prestaciones_liquidadas
  belongs_to :prestacion 

  def nombre_corto
    if prestacion_nombre.length > 90 then
      prestacion_nombre.first(67) + "..." + prestacion_nombre.last(20)
    else
      prestacion_nombre
    end
  end
  
end
