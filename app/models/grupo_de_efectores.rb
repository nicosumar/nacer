# -*- encoding : utf-8 -*-
class GrupoDeEfectores < ActiveRecord::Base
  validates_presence_of :nombre, :tipo_de_efector

  def nombre_corto
    if nombre.length > 80 then
      nombre.first(77) + "..."
    else
      nombre
    end
  end
end
