# -*- encoding : utf-8 -*-
class SiNo < ActiveRecord::Base

  # Devuelve el valor booleano asociado con el código pasado
  def self.valor_bool_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su valor booleano (si existe)
    si_no = self.find_by_codigo(codigo.strip.upcase)

    if si_no
      return si_no.valor_bool
    else
      logger.warn "ADVERTENCIA: No se encontró el valor bool asociado al codigo '#{codigo.strip.upcase}'."
      return nil
    end
  end

end
