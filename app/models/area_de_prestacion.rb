class AreaDePrestacion < ActiveRecord::Base
  # No se declara ningún atributo protegido ya que este modelo no tiene asociado ningún punto de interacción con el usuario
  attr_protected nil

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
