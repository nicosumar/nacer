# -*- encoding : utf-8 -*-
class AreaDePrestacion < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Seguridad en asignciones masivas
  attr_accessible :codigo, :nombre

  # Asociaciones
  #has_many :efectores

  # Validaciones
  #validates_presence_of :nombre

  def nombre_corto
    if nombre.length > 80 then
      nombre.first(77) + "..."
    else
      nombre
    end
  end
end
