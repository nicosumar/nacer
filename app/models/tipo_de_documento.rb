class TipoDeDocumento < ActiveRecord::Base

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    tipo_de_documento = self.find_by_codigo(codigo.strip.upcase)
    return tipo_de_documento.id if tipo_de_documento

    # TODO: Esto es horrible, eliminarlo una vez que se hayan consolidado los códigos
    # incluyendo códigos para extranjeros.
    # Diferencias comunes entre el sistema de gestión y este sistema
    case
      when codigo.first == 'C' && codigo != 'CERMI' && codigo != 'C01'
        return 5 # Código perteneciente a C09, CI de la provincia
      when codigo = 'CERMI'
        return 7 # Otro
    end
  end

end
