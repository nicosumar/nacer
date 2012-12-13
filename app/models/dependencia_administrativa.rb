# -*- encoding : utf-8 -*-
class DependenciaAdministrativa < ActiveRecord::Base
  has_many :efectores

  validates_presence_of :nombre

  def nombre_corto
    if nombre.length > 80 then
      nombre.first(77) + "..."
    else
      nombre
    end
  end
end
