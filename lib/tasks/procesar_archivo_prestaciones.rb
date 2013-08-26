origen = File.new("vendor/data/notti.csv", "r")
destino = File.new("vendor/data/notti_salida.csv", "w")

origen.each do |linea|
  documento, apellido, nombre = linea.split("\t")

  encontrados, nivel = Afiliado.busqueda_por_aproximacion(documento.to_s, apellido.to_s + " " + nombre.to_s)

  if nivel > 0
    destino.puts(linea.chomp + "\t" + nivel.to_s + "\t" + encontrados.collect{ |afiliado| afiliado.clave_de_beneficiario }.join("\t"))
  else
    destino.puts(linea.chomp + "\t" + nivel.to_s)
  end
  destino.flush
end

origen.close
destino.close
