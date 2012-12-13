# -*- encoding : utf-8 -*-
class Sexo < ActiveRecord::Base

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    sexo = self.find_by_codigo(codigo.strip.upcase)

    if sexo
      return sexo.id
    else
      logger.warn "ADVERTENCIA: No se encontró el sexo '#{codigo.strip.upcase}'."
      return nil
    end
  end

end
