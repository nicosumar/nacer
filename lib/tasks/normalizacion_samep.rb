def cargar_datos(ruta)
  resultado = {}

  begin
    origen = File.open(ruta, "r")
    origen.each do |linea|
      texto, cantidad = linea.chomp.split("\t", -1)
      if texto.match(/ /)
        texto.gsub(/ +/, " ").split(" ", -1).each do |t|
          if t.length > 1
            if resultado.has_key?(t)
              resultado[t] = resultado[t] + cantidad.to_i
            else
              resultado.merge! t => cantidad.to_i
            end
          end
        end
      else
        if texto.length > 1
          if resultado.has_key?(texto)
            resultado[texto] = resultado[texto] + cantidad.to_i
          else
            resultado.merge! texto => cantidad.to_i
          end
        end
      end
    end
    origen.close
  rescue
  end

  return resultado
end

def decidir(nombre)
  separar_nombres(nombre).merge! determinar_sexo(nombre)
end

def determinar_sexo(nombre)
  nombres = separar_nombres(nombre)[:nombres]
  return {:sexo => :indeterminado, :prob_sexo => 0.0} unless nombres

  p_masculino = p_femenino = 1.0
  nombres.gsub(".", "").split(" ", -1).each do |n|
    if n.length > 1
      total = @masculinos[n].to_f + @femeninos[n].to_f
      if total > 0.0
        p_femenino *= (@femeninos[n].to_f/total)
        p_masculino *= (@masculinos[n].to_f/total)
      end
    end
  end

  return {:sexo => :indeterminado, :prob_sexo => p_femenino} if p_femenino == p_masculino
  return (p_masculino > p_femenino ? {:sexo => :masculino, :prob_sexo => p_masculino} : {:sexo => :femenino, :prob_sexo => p_femenino})
end

def separar_nombres(nombre)
  tokens = nombre.chomp.strip.gsub(",", "").gsub(/  /, " ").mb_chars.upcase.to_s.split(" ", -1)

  mejor_p = 0.0
  mejor_solucion = {}
  (0..(tokens.size)).each do |i|
    solucion = {:apellidos => tokens[0,tokens.size-i].join(" "), :nombres => tokens[tokens.size-i,i].join(" ")}
    p = p_nombre(solucion[:nombres]) * p_apellido(solucion[:apellidos])
    if (p > mejor_p) && !(solucion[:nombres].blank? || solucion[:apellidos].blank?)
      mejor_p = p
      mejor_solucion = solucion
    end
    solucion = {:nombres => tokens[0,tokens.size-i].join(" "), :apellidos => tokens[tokens.size-i,i].join(" ")}
    p = p_nombre(solucion[:nombres]) * p_apellido(solucion[:apellidos])
    if (p > mejor_p) && !(solucion[:nombres].blank? || solucion[:apellidos].blank?)
      mejor_p = p
      mejor_solucion = solucion
    end
  end

  return mejor_solucion.merge! :prob_nombre => mejor_p
end

def p_nombre(texto)
  return 1.0 if texto.blank?

  p_masc = p_fem = 1.0
  texto.gsub(".", "").split(" ", -1).each do |n|
    if n.length > 1
      n_total = @apellidos[n].to_f + @masculinos[n].to_f + @femeninos[n].to_f
      if n_total == 0.0
        p_masc *= 0.5
        p_fem *= 0.5
      elsif n_total > 0.0
        p_masc *= (@masculinos[n].to_f/n_total)
        p_fem *= (@femeninos[n].to_f/n_total)
      end
    end
  end
  return (p_masc > p_fem ? p_masc : p_fem)
end

def p_apellido(texto)
  return 1.0 if texto.blank?

  p = 1.0
  texto.gsub(".", "").split(" ", -1).each do |n|
    if n.length > 1
      n_total = @apellidos[n].to_f + @masculinos[n].to_f + @femeninos[n].to_f
      if n_total > 0.0
        p *= (@apellidos[n].to_f/n_total)
      end
    end
  end
  return p
end

def parsear_linea(linea)
  return nil unless linea

  campos = linea.gsub(/[\r\n]/, "").split("\t")

  return {
    tipo_de_documento: a_texto(campos[0]),
    numero_de_documento: a_numero_de_documento(campos[1]),
    fecha_de_nacimiento: a_fecha(campos[2]),
    apellido_y_nombre: a_texto(campos[3]),
    domicilio_calle: a_texto(campos[4]),
    domicilio_numero: a_entero(campos[5]),
    telefono: a_texto(campos[6]),
    celular: a_texto(campos[7]),
    sexo: a_texto(campos[8]),
    fecha_proceso: a_fecha(campos[9]),
    hora_proceso: a_texto(campos[10]),
    provincia: a_texto(campos[11]),
    departamento: a_texto(campos[12]),
    distrito: a_texto(campos[13]),
    codigo_postal: a_texto(campos[14]),
    nombre: a_texto(campos[15]),
    apellido_materno: a_texto(campos[16]),
    apellido_paterno: a_texto(campos[17]),
  }
end

def a_texto(cadena)
  texto = cadena.to_s.strip.gsub(/  /, " ").gsub("NULL", "").mb_chars.upcase.to_s
  return (texto.blank? ? nil : texto)
end

def a_entero(cadena)
  texto = cadena.to_s.strip.gsub(/[ ,\.-]/, "")
  return (texto.to_i > 0 ? texto.to_i : nil)
end

def a_numero_de_documento(cadena)
  texto = cadena.to_s.strip.gsub(/[ ,\.-]/, "").upcase
  return (texto.blank? ? nil : texto)
end

def a_fecha(cadena)
  texto = cadena.to_s.strip.gsub("NULL", "")
  return nil if texto.blank?
  begin
    anio, mes, dia = texto.split("-")
    fecha = Date.new(anio.to_i, mes.to_i, dia.to_i)
  rescue
    begin
      dia, mes, anio = texto.split("/")
      fecha = Date.new(anio.to_i, mes.to_i, dia.to_i)
    rescue
      fecha = nil
    end
  end
  return fecha
end

tipos_de_documento_samep = {
	'0' => 'CI Policía Federal', '1' => 'CI Buenos Aires', '2' => 'CI Catamarca', '3' => 'CI Córdoba', '4' => 'CI Corrientes', '5' => 'CI Entre Ríos', '6' => 'CI Jujuy', '7' => 'CI Mendoza', '8' => 'CI La Rioja', '9' => 'CI Salta', '10' => 'CI San Juan', '11' => 'CI San Luis', '12' => 'CI Santa Fe', '13' => 'CI Santiago del Estero', '14' => 'CI Tucumán', '16' => 'CI Chaco', '17' => 'CI Formosa', '19' => 'CI Misiones', '20' => 'CI Neuquén', '21' => 'CI La Pampa', '22' => 'CI Río Negro', '23' => 'CI Santa Cruz', '24' => 'CI Tierra del Fuego', '50' => 'Indocumentado', '51' => 'Otros/Determinar', '80' => 'C.U.I.T.', '83' => 'Identificación tributaria exterior', '84' => 'Documento del exterior', '86' => 'C.U.I.L.', '87' => 'Cédula de identidad', '89' => 'Libreta de enrolamiento', '90' => 'Libreta cívica', '94' => 'Pasaporte', '96' => 'Documento nacional de identidad'
}
equivalencias_tipos_de_documentos = {
	'0' => 8, '1' => 8, '2' => 8, '3' => 8, '4' => 8, '5' => 8, '6' => 8, '7' => 8, '8' => 8, '9' => 8, '10' => 8, '11' => 8, '12' => 8, '13' => 8, '14' => 8, '16' => 8, '17' => 8, '19' => 8, '20' => 8, '21' => 8, '22' => 8, '23' => 8, '24' => 8, '50' => nil, '51' => nil, '80' => 8, '83' => nil, '84' => 7, '86' => 8, '87' => 4, '89' => 2, '90' => 3, '94' => 5, '96' => 1
}
departamentos_samep = {}
equivalencias_de_departamentos = {}
distritos_samep = {}
equivalencias_de_distritos = {}
Departamento.where(provincia_id: 9).each do |d|
	departamentos_samep.merge! d.departamento_bio_id.to_s => d.nombre
	equivalencias_de_departamentos.merge! d.departamento_bio_id.to_s => d.id
	distritos_samep_del_depto = {}
	equivalencias_de_distritos_del_depto = {}
	Distrito.where("departamento_id = #{d.id} AND alias_id = id").each do |dd|
		distritos_samep_del_depto.merge! dd.distrito_bio_id.to_s => dd.nombre
		equivalencias_de_distritos_del_depto.merge! dd.distrito_bio_id.to_s => dd.id
	end
	distritos_samep.merge! d.departamento_bio_id.to_s => distritos_samep_del_depto
	equivalencias_de_distritos.merge! d.departamento_bio_id.to_s => equivalencias_de_distritos_del_depto
end

@apellidos = cargar_datos("lib/tasks/apellidos.txt")
@masculinos = cargar_datos("lib/tasks/masculinos.txt")
@femeninos = cargar_datos("lib/tasks/femeninos.txt")
@palabras_reservadas = [
	"DERIV",
	"HC",
	"TIENE",
	"ORDEN",
	"REMEDIAR",
	"INFO",
	"POSEE",
	"OBRA",
	"SOCIAL",
	"VER",
	"DOM",
	"DOMICILIO",
	"PROFE",
	"RN",
	"HIJO",
	"PACIENTE",
	"CRONICO",
	"SANCION",
	"VDA",
	"CARNET",
	"OSEP",
	"INT",
	"INTERNADO",
	"INTERNADA",
	"HOS",
	"HOSPITAL",
	"BONO",
	"SUELDO",
	"ESCUCHA",
	"RAZON",
	"RAZONES",
]
regexp_reservadas = Regexp.new(@palabras_reservadas.collect{|p| "^#{p}[^[:alpha:]]+|[^[:alpha:]]+#{p}$|[^[:alpha:]]+#{p}[^[:alpha:]]+"}.join("|"))

archivo_de_entrada = File.open("/home/sbosio/faraon/operaciones/Padrones/SaMEP/Normalización.csv", "r")
archivo_normalizado = File.open("/home/sbosio/faraon/operaciones/Padrones/SaMEP/padron_samep_normalizado.csv", "w")
archivo_log = File.open("/home/sbosio/faraon/operaciones/Padrones/SaMEP/proceso_de_normalizacion.log", "w")
archivo_log.puts "numero_de_linea\tsapatipdoc\tsapanrodoc\tsapanacimi\tsapaapynom\tsapadomici\tsapanro\tsapatelfij\tsapacelula\tsapasexo\tsapafchprc\tsapahorprc\tsapalcpcia\tsapalcdpt\tsapalcdis\tsapalccpfu\tsapanombre\tsapaapemat\tsapaapepat\tregistro_valido\tmotivo_de_rechazo\tmensajes_de_proceso"

numero_de_linea = 0
archivo_de_entrada.each do |linea|
	registro = parsear_linea(linea)
	numero_de_linea = numero_de_linea + 1
	mensajes_de_error = ""

	# Primero verificamos el tipo de documento, únicamente procesaremos DNI (id: 1) y LE (id: 2).
	if registro[:tipo_de_documento].nil? || ![1, 2].member?(equivalencias_tipos_de_documentos[registro[:tipo_de_documento]])
		archivo_log.puts numero_de_linea.to_s + "\t" + linea.chomp + "\tNO\tTipo de documento no elegible\tEl tipo de documento '#{tipos_de_documento_samep[registro[:tipo_de_documento]]}' no es elegible para la importación"
		next
	end

	# Primero verificamos el tipo de documento, únicamente procesaremos DNI (id: 1) y LE (id: 2).
	if registro[:fecha_de_nacimiento] >= Date.new(1970, 1, 1) && equivalencias_tipos_de_documentos[registro[:tipo_de_documento]] == 2
		archivo_log.puts numero_de_linea.to_s + "\t" + linea.chomp + "\tNO\tNúmero de documento fuera del rango aceptable\tEl tipo de documento es '#{tipos_de_documento_samep[registro[:tipo_de_documento]]}' y la fecha de nacimiento es posterior al '01/01/1970'"
		next
	end

	# Verificar que el número de documento tenga un valor aceptable, fijamos como límites: 5.000.000 - 99.999.999
	if registro[:numero_de_documento].to_i < 5000000 || registro[:numero_de_documento].to_i > 99999999
		archivo_log.puts numero_de_linea.to_s + "\t" + linea.chomp + "\tNO\tNúmero de documento fuera del rango aceptable\tEl número de documento '#{registro[:numero_de_documento]}' se encuentra fuera del rango 5.000.000 - 99.999.999"
		next
	end

	# Verificar que la fecha de nacimiento es válida y está dentro del rango solicitado (01/04/1950 - 30/04/1995)
	if registro[:fecha_de_nacimiento].nil? || registro[:fecha_de_nacimiento] < Date.new(1950, 4, 1) || registro[:fecha_de_nacimiento] > Date.new(1995, 4, 30)
		archivo_log.puts numero_de_linea.to_s + "\t" + linea.chomp + "\tNO\tFecha de nacimiento inválida\tLa fecha de nacimiento '#{registro[:fecha_de_nacimiento]}' no es válida o no se encuentra dentro del rango solicitado"
		next
	end

	# Verificar que alguno de los campos de nombre y apellido se encuentren completos
	if registro[:apellido_y_nombre].nil? && (registro[:nombre].nil? || registro[:apellido_paterno].nil? && registro[:apellido_materno].nil)
		archivo_log.puts numero_de_linea.to_s + "\t" + linea.chomp + "\tNO\tNombre o apellido inválidos\tTodos los campos de nombre o apellido están vacíos"
		next
	end

	# Verificar que el campo de domicilio (calle, barrio, etc.) contenga algún valor
	if registro[:domicilio_calle].nil?
		archivo_log.puts numero_de_linea.to_s + "\t" + linea.chomp + "\tNO\tEl domicilio no es válido\tEl campo domicilio se encuentra vacío"
		next
	end

	# Verificar que entre los dos campos de domicilio exista algún tipo de numeración o se indique sin numeración
	if !(calle_y_numero = /([[:print:]]+)([[:space:],[:punct:]]+)([[:alpha:]]*[0-9]+)([^0-9]*)/.match(registro[:domicilio_calle].to_s + " " + registro[:domicilio_numero].to_s))
		if !(calle_sin_numero = /([[:print:]]+)([[:space:],[:punct:]]+)(S[^[:alnum:]]+N)([^[:alnum:]]*)(.*)|(.*)(FINCA|FCA)(.*)/.match(registro[:domicilio_calle].to_s + " " + registro[:domicilio_numero].to_s))
			archivo_log.puts numero_de_linea.to_s + "\t" + linea.chomp + "\tNO\tEl domicilio no es válido\tDomicilio incompleto, no se detectó numeración (altura) o requiere revisión manual"
			next
		end
	end

	# Verificar que el sexo sea 'M'
	if registro[:sexo].to_s != 'M'
		archivo_log.puts numero_de_linea.to_s + "\t" + linea.chomp + "\tNO\tEl valor del campo sexo no es válido\tEl campo sexo está vacío o es distinto de 'M'"
		next
	end

	# Verificar que el departamento tenga un valor válido
	if equivalencias_de_departamentos[registro[:departamento]].nil?
		archivo_log.puts numero_de_linea.to_s + "\t" + linea.chomp + "\tNO\tCódigo de departamento inválido\tEl código de departamento está vacío o no contiene un valor válido ('#{registro[:departamento]}')"
		next
	end

	# Los datos básicos se han encontrado, afinar el filtrado para no cargar basura en los datos de nombre y apellido

	# Si los nombres se ubican en los campos separados, utilizar éstos.
	if (nombre = registro[:nombre].to_s).blank? && (apellido = (registro[:apellido_paterno].to_s + " " + registro[:apellido_materno].to_s).strip).blank?
		# La info de apellido y nombres se ubica en un único campo
		apellido_y_nombre = registro[:apellido_y_nombre].to_s

		# Eliminar abreviaturas de nombres
		apellido_y_nombre = apellido_y_nombre.gsub(/(.*)[[:space:]]+([[:alpha:]][[:punct:]])[[:space:]]*(.*)/, "\\1 \\3").strip

		# Eliminar expresiones entre paréntesis
		apellido_y_nombre = apellido_y_nombre.gsub(/(.*)(\(.*\))(.*)/, "\\1 \\3").strip

		# No procesar nombres que contengan caracteres extraños o palabras reservadas
		if apellido_y_nombre.blank? || /[\(\)\{\}\?\¿\¡\!\"\|\/\:\\"]|[[:digit:]]/.match(apellido_y_nombre) || regexp_reservadas.match(apellido_y_nombre)
			archivo_log.puts numero_de_linea.to_s + "\t" + linea.chomp + "\tNO\tNombre y apellido no válidos\tEl campo de nombre y apellido ('#{registro[:apellido_y_nombre].to_s}') contiene valores extraños o palabras reservadas"
			next
		end

		# Separar nombre del apellido y estimar el sexo
		resultado = decidir(apellido_y_nombre)

		# No procesar registros con sexo 'Indeterminado' o 'Femenino'
		if resultado[:sexo] == :indeterminado || resultado[:sexo] == :femenino
			archivo_log.puts numero_de_linea.to_s + "\t" + linea.chomp + "\tNO\tNombre y apellido no válidos\tEl campo de nombre y apellido ('#{registro[:apellido_y_nombre].to_s}') requiere separación manual o sugiere que el sexo es femenino"
			next
		end
	else
		# Los datos ya están separados en apellido y nombres
		resultado = {apellidos: apellido, nombres: nombre}
	end

	archivo_log.puts numero_de_linea.to_s + "\t" + linea.chomp + "\tSI"
	archivo_normalizado.puts "#{resultado[:apellidos]}\t#{resultado[:nombres]}\tP\t#{equivalencias_tipos_de_documentos[registro[:tipo_de_documento]]}\t#{registro[:numero_de_documento]}\tM\t#{registro[:fecha_de_nacimiento].iso8601}\t\t#{(registro[:domicilio_calle].to_s + " " + registro[:domicilio_numero].to_s).strip}\t#{equivalencias_de_departamentos[registro[:departamento]]}\t#{equivalencias_de_distritos[registro[:departamento]][registro[:distrito]]}\t2015-04-01\tSaMEP"

end

archivo_de_entrada.close
archivo_normalizado.close
archivo_log.close