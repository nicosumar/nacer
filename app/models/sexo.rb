class Sexo < ActiveRecord::Base

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    sexo = self.find_by_codigo(codigo.strip.upcase)
    return sexo.id if sexo
  end

end
