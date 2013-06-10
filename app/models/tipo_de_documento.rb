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
      # TODO: Esto es horrible, eliminarlo una vez que se hayan consolidado los códigos
      # incluyendo códigos para extranjeros.
      # Diferencias comunes entre el sistema de gestión y este sistema
      case
        when codigo == 'C09'
          return self.id_del_codigo("CI")
        when codigo == 'CERMI'
          return self.id_del_codigo("CM")
        else
          return self.id_del_codigo("OTRO")
      end
    end
  end
  def self.id_del_codigo!(codigo)
    codigo_id = self.id_del_codigo(codigo)
    raise ActiveRecord::RecordNotFound if codigo_id.nil?
    return codigo_id
  end

end
