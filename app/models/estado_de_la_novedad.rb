# -*- encoding : utf-8 -*-
class EstadoDeLaNovedad < ActiveRecord::Base

  # id_del_codigo
  # Devuelve el ID asociado con el código pasado
  def self.id_del_codigo(codigo)
    return nil if codigo.blank?
    find_by_codigo(codigo)
  end
end
