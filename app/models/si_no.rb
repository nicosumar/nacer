class SiNo < ActiveRecord::Base

  # Devuelve el valor_bool asociado con el código pasado
  def self.valor_bool_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su valor_bool (si existe)
    si_no = self.find_by_codigo(codigo.strip.upcase)
    return si_no.valor_bool if si_no
  end

end
