class NivelDeInstruccion < ActiveRecord::Base

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    nivel_de_instruccion = self.find_by_codigo(codigo.strip.upcase)

    if nivel_de_instruccion
      return nivel_de_instruccion.id
    else
      logger.warn "ADVERTENCIA: No se encontró el nivel de instrucción '#{codigo.strip}'."
      return nil
    end
  end

end
