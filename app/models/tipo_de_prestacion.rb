# -*- encoding : utf-8 -*-
class TipoDePrestacion < ActiveRecord::Base
  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre

  # id_del_codigo
  # Devuelve el ID asociado con el código pasado
  def self.id_del_codigo(codigo)
    return nil if codigo.blank?

    # Buscar el codigo en la tabla y devolver su ID (si existe)
    tipo = self.find_by_codigo(codigo.strip.upcase)
    return tipo.id if tipo
  end

end
