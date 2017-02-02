# -*- encoding : utf-8 -*-
module ModelHelper

  # a_fecha
  # Intenta devolver una instancia de la clase Date, parseando la cadena pasada como parámetro
  # El formato de la fecha esperado debe ser ISO8601, o bien el formato local de Argentina (DD/MM/AAAA)
  def a_fecha(cadena)
    begin
      Date.strptime(cadena, "%Y-%m-%d")
    rescue ArgumentError
      begin
        Date.strptime(cadena, "%d/%m/%Y")
      rescue ArgumentError
        nil
      end
    end
  end

  # a_numero_de_documento
  # Devuelve la misma cadena pasada como parámetro, pero eliminando espacios y caracteres de separación utilizados
  # comunmente al escribir los números de documento.
  def a_numero_de_documento(cadena)
    cadena.to_s.gsub(/[ ,\.-]/, "")
  end

  # sin_espacios
  # Devuelve la misma cadena pasada como parámetro, pero eliminando todo tipo de espacios en blanco.
  def sin_espacios(cadena)
    texto = cadena.to_s.gsub(/[[:space:]]/, "")
    return (texto.blank? ? nil : texto)
  end

  def a_entero(cadena)
    texto = cadena.to_s.gsub(/[^0-9]/, "")
    return (texto.blank? ? nil : texto.to_i)
  end

  def a_valor_de_dato_reportable(dato_reportable, cadena)
    case dato_reportable.tipo_ruby
      when "string"
        cadena
      when "date"
        self.a_fecha(cadena)
      when "big_decimal"
        cadena.to_f
      when "integer"
        if dato_reportable.enumerable
          self.clase_a_id(dato_reportable.clase_para_enumeracion, cadena)
        else
          self.a_entero(cadena)
        end
    end
  end

  def clase_a_id(nombre_de_clase, cadena = nil)
    raise ArgumentError if nombre_de_clase.blank?

    return nil if (texto = cadena.to_s).blank?
    instancia = eval(nombre_de_clase).find_by_codigo(texto)
    return instancia.present? ? instancia.id : nil
  end

end
