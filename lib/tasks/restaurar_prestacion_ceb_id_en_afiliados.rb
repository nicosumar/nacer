# -*- encoding : utf-8 -*-

def valor(texto, tipo)

  return nil unless texto

  texto.strip!
  return nil if texto == "NULL" || texto == ""

  begin
    case
      when tipo == :texto
        return texto
      when tipo == :entero
        return texto.to_i
      when tipo == :fecha
        año, mes, dia = texto.split(" ")[0].split("-")
        return nil if (año == "1899" || año == "1900")
        return Date.new(año.to_i, mes.to_i, dia.to_i)
      when tipo == :fecha_hora
        año, mes, dia = texto.split(" ")[0].split("-")
        horas, minutos, segundos = texto.split(" ")[1].split(":")
        return nil if (año == "1899" || año == "1900")
        return DateTime.new(año.to_i, mes.to_i, dia.to_i, horas.to_i, minutos.to_i, segundos.to_i)
      else
        return nil
    end
  rescue
    return nil
  end

end

archivo = File.open('lib/tasks/PrestacionesCebId_2014-04.txt', 'r')

archivo.each do |linea|

  a, c, f, p = linea.split("\t")

  afiliado = Afiliado.find(a.to_i)

  if afiliado.present? && afiliado.prestacion_ceb_id.nil?
    prestacion_id = Prestacion.id_del_codigo(p, afiliado, valor(f, :fecha))

    if prestacion_id.present?
      afiliado.update_attributes({:prestacion_ceb_id => prestacion_id})
    end
  end
end
