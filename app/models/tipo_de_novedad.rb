# -*- encoding : utf-8 -*-
class TipoDeNovedad < ActiveRecord::Base

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    (tipo = self.find_by_codigo(codigo)) && tipo.id
  end
end
