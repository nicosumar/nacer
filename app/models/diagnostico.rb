# -*- encoding : utf-8 -*-
class Diagnostico < ActiveRecord::Base

  has_many :prestaciones_liquidadas

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre

  # Devuelve el valor del campo 'nombre', pero truncado a 100 caracteres.
  def nombre_corto
    if nombre.length > 100 then
      nombre.first(77) + "..." + nombre.last(20)
    else
      nombre
    end
  end
  
  def nombre_y_codigo
     codigo + " - " + nombre_corto 
  end

end
