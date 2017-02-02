# -*- encoding : utf-8 -*-
class Parametro < ActiveRecord::Base

  attr_accessible :nombre, :tipo_postgres, :tipo_ruby, :valor

  # Devuelve el valor asociado con el nombre del parámetro indicado
  def self.valor_del_parametro(parametro)
    parametro = self.find_by_nombre(parametro.to_s.camelize)
    return nil if !parametro

    case
      when parametro.tipo_ruby == 'Integer'
        valor = parametro.valor.to_i
      when parametro.tipo_ruby == 'String'
        valor = parametro.valor.to_s
      when parametro.tipo_ruby == 'Date'
        anio, mes, dia = parametro.valor.split('-')
        valor = Date.new(anio.to_i, mes.to_i, dia.to_i)
      else
        valor = parametro.valor
    end
  end

end
