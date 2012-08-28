class NivelDeInstruccion < ActiveRecord::Base

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    nivel_de_instruccion = self.find_by_codigo(codigo.strip.upcase)
    return nivel_de_instruccion.id if nivel_de_instruccion
  end

end
