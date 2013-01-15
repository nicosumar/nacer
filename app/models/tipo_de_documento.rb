# -*- encoding : utf-8 -*-
class TipoDeDocumento < ActiveRecord::Base

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si existe)
    tipo_de_documento = self.find_by_codigo(codigo.strip.upcase)

    if tipo_de_documento
      return tipo_de_documento.id
    else
      logger.warn "ADVERTENCIA: No se encontró el tipo de documento '#{codigo.strip.upcase}'."
      # TODO: Esto es horrible, eliminarlo una vez que se hayan consolidado los códigos
      # incluyendo códigos para extranjeros.
      # Diferencias comunes entre el sistema de gestión y este sistema
      case
        when codigo == 'C09'
          return 4 # Código perteneciente a C09, CI de la provincia
        when codigo == 'CERMI'
          return 6
        else
          return 7 # Otro
      end
    end
  end

end
