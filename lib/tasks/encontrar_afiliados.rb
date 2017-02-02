# -*- encoding: utf-8
#
class EncontrarAfiliados
  attr_accessor :archivo_a_procesar, :separador, :columna_documento, :columna_nombre

  def initialize(ruta = nil, sep = "\t", doc = -1, nombre = -1)
    @archivo_a_procesar = ruta
    @separador = sep
    @columna_documento = doc
    @columna_nombre = nombre
  end

  def procesar_archivo
    return true unless archivo_a_procesar

    origen = File.open(archivo_a_procesar, "r")
    destino = File.open(archivo_a_procesar + ".new", "w")

    origen.each do |linea|
      campos = linea.chomp.split(separador, -1)

      if columna_nombre.is_a? Array
        resultado = Afiliado.busqueda_por_aproximacion(campos[columna_documento], campos.slice(columna_nombre[0], columna_nombre[1]-columna_nombre[0]).join(" "))
      else
        resultado = Afiliado.busqueda_por_aproximacion(campos[columna_documento], campos[columna_nombre])
      end

      destino.puts campos.join(separador) + separador + (
        if resultado.first.present?
	  if resultado.second >= 8
            "Encontrado" + separador + resultado.first.first.clave_de_beneficiario.to_s + " - " + resultado.first.first.apellido.to_s + ", " + resultado.first.first.nombre.to_s
          else
            "Los nombres no coinciden" + separador + resultado.first.first.clave_de_beneficiario.to_s + " - " + resultado.first.first.apellido.to_s + ", " + resultado.first.first.nombre.to_s
          end
        else
          "NO ENCONTRADO"
        end
      )

    end

    origen.close
    destino.close
  end

end
