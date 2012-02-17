class Afiliado < ActiveRecord::Base
  set_primary_key "afiliado_id"

  belongs_to :categoria_de_afiliado
  has_many :periodos_de_actividad

  validates_presence_of :clave_de_beneficiario, :apellido, :nombre, :tipo_de_documento
  validates_presence_of :clase_de_documento, :numero_de_documento, :categoria_de_afiliado_id
  validates_numericality_of :numero_de_documento, :integer => true
  validates_uniqueness_of :clave_de_beneficiario

  # Normaliza un nombre (o apellido) a mayúsculas, eliminando caracteres extraños y acentos
  def self.transformar_nombre(nombre)
    return nil unless nombre
    normalizado = nombre.upcase

    normalizado.gsub!(/[\,\.\'\`\^\~\-\"\/\\\º\ª\!\·\$\%\&\(\)\=\+\*\-\_\;\:\<\>\|\@\#\[\]\{\}]/, "")
    if normalizado.match(/[ÁÉÍÓÚÄËÏÖÜÀÈÌÒÂÊÎÔÛ014]/)
      normalizado.gsub!(/[ÁÄÀÂ4]/, "A")
      normalizado.gsub!(/[ÉËÈÊ]/, "E")
      normalizado.gsub!(/[ÍÏÌÎ1]/, "I")
      normalizado.gsub!(/[ÓÖÒÔ0]/, "O")
      normalizado.gsub!(/[ÚÜÙÛ]/, "U")
    end
    return normalizado
  end

  # Busca un afiliado por su número de documento y nombre, devolviendo todos los posibles candidatos.
  def self.busqueda_por_aproximacion(documento, nombre_y_apellido, clase = "P")
    return nil if !(documento && nombre_y_apellido)

    encontrados = []

    # Primero intentamos encontrarlo por número de documento
    afiliados = Afiliado.where("numero_de_documento = '#{documento}' OR
                                numero_de_documento_de_la_madre = '#{documento}' OR
                                numero_de_documento_del_padre = '#{documento}' OR
                                numero_de_documento_del_tutor = '#{documento}'")
    nivel_coincidencia = 0
    afiliados.each do |afiliado|
      apellido_afiliado = self.transformar_nombre(afiliado.apellido)
      nombre_afiliado = self.transformar_nombre(afiliado.nombre)
      nombre_y_apellido = self.transformar_nombre(nombre_y_apellido)
      case
        when (apellido_afiliado.split(" ").all? { |apellido| nombre_y_apellido.index(apellido) })
          # Coinciden todos los apellidos
          case
            when (nombre_afiliado.split(" ").all? { |nombre| nombre_y_apellido.index(nombre) })
              # Coinciden todos los nombres
              if afiliado.clase_de_documento == clase
                if nivel_coincidencia < 8
                  nivel_coincidencia = 8
                  encontrados = [afiliado]
                else
                  encontrados << afiliado
                end
              else
                if nivel_coincidencia < 7
                  nivel_coincidencia = 7
                  encontrados = [afiliado]
                elsif nivel_coincidencia == 7
                  encontrados << afiliado
                end
              end
            when nivel_coincidencia < 7 && (nombre_afiliado.split(" ").any? { |nombre| nombre_y_apellido.index(nombre) })
              # Coincide algún nombre
              if afiliado.clase_de_documento == clase
                if nivel_coincidencia < 6
                  nivel_coincidencia = 6
                  encontrados = [afiliado]
                elsif nivel_coincidencia == 6
                  encontrados << afiliado
                end
              else
                if nivel_coincidencia < 5
                  nivel_coincidencia = 5
                  encontrados = [afiliado]
                elsif nivel_coincidencia == 5
                  encontrados << afiliado
                end
              end
          end
        when nivel_coincidencia < 5 && (apellido_afiliado.split(" ").any? { |apellido| nombre_y_apellido.index(apellido) })
          # Coincide algún apellido
          case
            when (nombre_afiliado.split(" ").all? { |nombre| nombre_y_apellido.index(nombre) })
              # Coinciden todos los nombres
              if afiliado.clase_de_documento == clase
                if nivel_coincidencia < 4
                  nivel_coincidencia = 4
                  encontrados = [afiliado]
                elsif nivel_coincidencia == 4
                  encontrados << afiliado
                end
              else
                if nivel_coincidencia < 3
                  nivel_coincidencia = 3
                  encontrados = [afiliado]
                elsif nivel_coincidencia == 3
                  encontrados << afiliado
                end
              end
            when nivel_coincidencia < 3 && (nombre_afiliado.split(" ").any? { |nombre| nombre_y_apellido.index(nombre) })
              # Coincide algún nombre
              if afiliado.clase_de_documento == clase
                if nivel_coincidencia < 2
                  nivel_coincidencia = 2
                  encontrados = [afiliado]
                elsif nivel_coincidencia == 2
                  encontrados << afiliado
                end
              else
                if nivel_coincidencia < 1
                  nivel_coincidencia = 1
                  encontrados = [afiliado]
                elsif nivel_coincidencia == 1
                  encontrados << afiliado
                end
              end
          end
      end
    end

    
    # Intentar individualizar a un único afiliado eliminando los duplicados
    encontrados.each_with_index do |afiliado, i|
      if afiliado.mensaje_de_la_baja && (clave = afiliado.mensaje_de_la_baja.downcase.match(/.*dupl.*([0-9]{16})/))
        encontrados.delete_at i
        encontrados << Afiliado.where("clave_de_beneficiario = '#{clave[1]}'").first
      end
    end
    if encontrados.size > 0
      sin_duplicados = [encontrados[0]]
      encontrados.each_with_index do |afiliado, i|
        if i > 0 && !((encontrados.collect {|e| e.afiliado_id})[0..(i-1)].member? afiliado.afiliado_id)
          sin_duplicados << afiliado
        end
      end
    else
      sin_duplicados = []
    end

    # Devolver el o los afiliados si se encontró alguno
    return sin_duplicados if sin_duplicados.size > 0

    ### TODO: ¿probar otros métodos para tratar de encontrar el afiliado?  (por ejemplo: buscar por nombre,
    ###       y luego verificar si el documento está mal ingresado)

    # Devolver 'nil' si no se encontró ningún afiliado que corresponda aproximadamente con los parámetros
    return nil unless sin_duplicados.size > 0
  end

  # Indica si el afiliado estaba inscripto para la fecha del parámetro, o al día de hoy si
  # no se indica una fecha
  def inscripto?(fecha = Date.today)
    return true if (fecha_de_inscripcion <= fecha)
  end

  # Indica si el afiliado estaba activo en el padrón correspondiente al mes y año de la fecha indicada, o
  # en el padrón del mes siguiente.
  # Si no se pasa una fecha, indica si figura como activo
  def activo?(fecha = nil)
    # Devuelve 'true' si no se especifica una fecha y el campo 'activo' es 'S'
    return (activo.upcase == "S") unless fecha

    # Obtener los periodos de actividad de este afiliado
    periodos = PeriodoDeActividad.where("afiliado_id = #{afiliado_id}")
    periodos.each do |p|
      # Desplazamos el inicio del periodo de actividad un mes antes para hacer la verificacion
      inicio = Date.new((p.fecha_de_inicio - 1).year, (p.fecha_de_inicio - 1).month, 1)
      if ( fecha >= inicio && (!p.fecha_de_finalizacion || fecha < p.fecha_de_finalizacion))
        return true
      end
    end
    return false
  end

  # Devuelve el mes y año del padrón donde aparece activo si el afiliado estaba activo en esa fecha
  # Esto puede ser el año y mes correspondiente a la fecha, si estaba activo en ese momento, o bien
  # el mes siguiente, si el afiliado se activó ese mes.
  def padron_activo(fecha = Date.today)
    return nil unless activo?(fecha)

    # Obtener los periodos de actividad de este afiliado
    periodos = PeriodoDeActividad.where("afiliado_id = #{afiliado_id}")
    periodos.each do |p|
      if ( fecha >= p.fecha_de_inicio && (!p.fecha_de_finalizacion || fecha < p.fecha_de_finalizacion))
        return fecha.strftime("%Y-%m")
      end
    end
    return (fecha.month == 12 ? (fecha.year + 1).to_s + "-01" : fecha.year.to_s + "-" + fecha.month.to_s)
  end

  # Devuelve un Array con los códigos de categoría válidos para el afiliado en la fecha especificada.
  def categorias(fecha = Date.today)
    case
      when categoria_de_afiliado_id == 1 # Embarazadas
        # Si no hay FPP o FEP se devuelve la misma categoría
        return [1] unless (fecha_probable_de_parto || fecha_efectiva_de_parto)
        case
          when (fpp = fecha_probable_de_parto) # Afiliada con FPP especificada
            case
              when (fecha - fpp).to_i < -45
                # Si la fecha es anterior a la FPP en más de 45 días, sólo se habilita la categoría 1
                return [1]
              when (fecha - fpp).to_i >= -45 && (fecha - fpp) <= 45
                # Si la fecha se encuentra entre 45 días antes y 45 días después de la FPP se habilitan las categorías 1 y 2
                return [1, 2]
              else
                # Si la fecha excede en más de 45 días la FPP, sólo se habilita la categoría 2
                return [2]
            end
          when (fep = fecha_efectiva_de_parto)
            case
              when (fecha - fep).to_i < -7
                # Si la fecha es anterior a la FEP en más de 7 días, sólo se habilita la categoría 1
                return [1]
              when (fecha - fep).to_i >= -7 && (fecha - fep) <= 7
                # Si la fecha se encuentra eentre 7 días antes y 7 días después de la FEP se habilitan las categorías 1 y 2
                return [1, 2]
              else
                # Si la fecha excede en más de 7 días la FEP, sólo se habilita la categoría 2
                return [2]
            end
        end

      when categoria_de_afiliado_id == 2 # Puérperas
        # Si no hay FEP se devuelve la misma categoría
        return [2] unless fecha_efectiva_de_parto
        case
          when (fecha - fecha_efectiva_de_parto).to_i < -7
            # Si la fecha es anterior a la FEP en más de 7 días, sólo se habilita la categoría 1
            return [1]
          when (fecha - fecha_efectiva_de_parto).to_i >= -7 && (fecha - fecha_efectiva_de_parto) <= 7
            # Si la fecha se encuentra eentre 7 días antes y 7 días después de la FEP se habilitan las categorías 1 y 2
            return [1, 2]
          else
            # Si la fecha excede en más de 7 días la FEP, sólo se habilita la categoría 2
            return [2]
        end

      when (categoria_de_afiliado_id == 3 || categoria_de_afiliado_id == 4) # Niños
        # Si no hay fecha de nacimiento se devuelve la misma categoría
        return [categoria_de_afiliado_id] unless fecha_de_nacimiento
        case
          when (fecha - fecha_de_nacimiento).to_i < 335
            # Si la fecha es anterior a la fecha en que el niño cumple 11 meses (335 días), sólo se habilita la categoría 3
            return [3]
          when (fecha - fecha_de_nacimiento).to_i >= 335 && (fecha - fecha_de_nacimiento) <= 395
            # Si la fecha se encuentra eentre los 11 y 13 meses de edad, se habilitan las categorías 3 y 4
            return [3, 4]
          else
            # Si a la fecha el niño excede los 13 meses de edad, sólo se habilita la categoría 4
            return [4]
        end
      else # Categoria mal definida
        return nil
    end
  end

  # Función para importar datos desde el archivo de texto generado desde la tabla del SQL Server
  def self.attr_hash_desde_texto(texto, separador = "\t")
    campos = texto.split(separador)
    if campos.size != 86
      raise ArgumentError, "El texto no contiene la cantidad correcta de campos (86), ¿quizás equivocó el separador?"
      return nil
    end
    attr_hash = {
      :afiliado_id => self.valor(campos[0], :entero),
      :clave_de_beneficiario => self.valor(campos[1], :texto),
      :apellido => self.valor(campos[2], :texto),
      :nombre => self.valor(campos[3], :texto),
      :tipo_de_documento => self.valor(campos[4], :texto),
      :clase_de_documento => self.valor(campos[5], :texto),
      :numero_de_documento => self.valor(campos[6], :texto),
      :sexo => self.valor(campos[7], :texto),
      :provincia => self.valor(campos[8], :texto),
      :localidad => self.valor(campos[9], :texto),
      :categoria_de_afiliado_id => self.valor(campos[10], :entero),
      :fecha_de_nacimiento => self.valor(campos[11], :fecha),
      :se_declara_indigena => self.valor(campos[12], :texto),
      :lengua_originaria_id => self.valor(campos[13], :entero),
      :tribu_originaria_id => self.valor(campos[14], :entero),
      :tipo_de_documento_de_la_madre => self.valor(campos[15], :texto),
      :numero_de_documento_de_la_madre => self.valor(campos[16], :texto),
      :apellido_de_la_madre => self.valor(campos[17], :texto),
      :nombre_de_la_madre => self.valor(campos[18], :texto),
      :tipo_de_documento_del_padre => self.valor(campos[19], :texto),
      :numero_de_documento_del_padre => self.valor(campos[20], :texto),
      :apellido_del_padre => self.valor(campos[21], :texto),
      :nombre_del_padre => self.valor(campos[22], :texto),
      :tipo_de_documento_del_tutor => self.valor(campos[23], :texto),
      :numero_de_documento_del_tutor => self.valor(campos[24], :texto),
      :apellido_del_tutor => self.valor(campos[25], :texto),
      :nombre_del_tutor => self.valor(campos[26], :texto),
      :tipo_de_relacion_id => self.valor(campos[27], :texto),
      :fecha_de_inscripcion => self.valor(campos[28], :fecha),
      :fecha_de_alta_efectiva => self.valor(campos[29], :fecha),
      :fecha_de_diagnostico_del_embarazo => self.valor(campos[30], :fecha),
      :semanas_de_embarazo => self.valor(campos[31], :entero),
      :fecha_probable_de_parto => self.valor(campos[32], :fecha),
      :fecha_efectiva_de_parto => self.valor(campos[33], :fecha),
      :activo => self.valor(campos[34], :texto),
      :accion_pendiente_de_confirmar => self.valor(campos[35], :texto),
      :domicilio_calle => self.valor(campos[36], :texto),
      :domicilio_numero => self.valor(campos[37], :texto),
      :domicilio_manzana => self.valor(campos[38], :texto),
      :domicilio_piso => self.valor(campos[39], :texto),
      :domicilio_depto => self.valor(campos[40], :texto),
      :domicilio_entre_calle_1 => self.valor(campos[41], :texto),
      :domicilio_entre_calle_2 => self.valor(campos[42], :texto),
      :domicilio_barrio_o_paraje => self.valor(campos[43], :texto),
      :domicilio_municipio => self.valor(campos[44], :texto),
      :domicilio_departamento_o_partido => self.valor(campos[45], :texto),
      :domicilio_localidad => self.valor(campos[46], :texto),
      :domicilio_provincia => self.valor(campos[47], :texto),
      :domicilio_codigo_postal => self.valor(campos[48], :texto),
      :telefono => self.valor(campos[49], :texto),
      :lugar_de_atencion_habitual => self.valor(campos[50], :texto),
      :fecha_de_envio_de_los_datos => self.valor(campos[51], :fecha),
      :fecha_de_alta => self.valor(campos[52], :fecha),
      :pendiente_de_enviar => self.valor(campos[53], :entero),
      :codigo_provincia_uad => self.valor(campos[54], :texto),
      :codigo_uad => self.valor(campos[55], :texto),
      :codigo_ci_uad => self.valor(campos[56], :texto),
      :motivo_de_la_baja => self.valor(campos[57], :entero),
      :mensaje_de_la_baja => self.valor(campos[58], :texto),
      :proceso_de_baja_automatica_id => self.valor(campos[59], :entero),
      :pendiente_de_enviar_a_nacion => self.valor(campos[60], :entero),
      :fecha_y_hora_de_carga => self.valor(campos[61], :fecha_hora),
      :usuario_que_carga => self.valor(campos[62], :texto),
      :menor_convive_con_tutor => self.valor(campos[63], :texto),
      :fecha_de_baja_efectiva => self.valor(campos[64], :fecha),
      :fecha_de_alta_uec => self.valor(campos[65], :fecha),
      :auditoria => self.valor(campos[66], :texto),
      :cuie_del_efector_asignado => self.valor(campos[67], :texto),
      :cuie_del_lugar_de_atencion_habitual => self.valor(campos[68], :texto),
      :clave_del_benef_que_provoca_baja => self.valor(campos[69], :texto),
      :usuario_de_creacion => self.valor(campos[70], :texto),
      :fecha_de_creacion => self.valor(campos[71], :fecha),
      :persona_id => self.valor(campos[72], :entero),
      :confirmacion_del_numero_de_documento => self.valor(campos[73], :texto),
      :score_de_riesgo => self.valor(campos[74], :entero),
      :alfabetizacion => self.valor(campos[75], :texto),
      :alfabetizacion_anios_ultimo_nivel => self.valor(campos[76], :entero),
      :alfabetizacion_de_la_madre => self.valor(campos[77], :texto),
      :alfab_madre_anios_ultimo_nivel => self.valor(campos[78], :entero),
      :alfabetizacion_del_padre => self.valor(campos[79], :texto),
      :alfab_padre_anios_ultimo_nivel => self.valor(campos[80], :entero),
      :alfabetizacion_del_tutor => self.valor(campos[81], :texto),
      :alfab_tutor_anios_ultimo_nivel => self.valor(campos[82], :entero),
      :activo_r => self.valor(campos[83], :texto),
      :motivo_baja_r => self.valor(campos[84], :entero),
      :mensaje_baja_r => self.valor(campos[85], :texto)
    }
  end

  def self.valor(texto, tipo)

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
          return nil if año == "1899"
          return Date.new(año.to_i, mes.to_i, dia.to_i)
        when tipo == :fecha_hora
          año, mes, dia = texto.split(" ")[0].split("-")
          horas, minutos, segundos = texto.split(" ")[1].split(":")
          return nil if año == "1899"
          return DateTime.new(año.to_i, mes.to_i, dia.to_i, horas.to_i, minutos.to_i, segundos.to_i)
        else
          return nil
      end
    rescue
      return nil
    end

  end

end
