class Afiliado < ActiveRecord::Base
  # TODO: seguridad, probablemente ninguna ya que no está asociado a ningún formulario aún
  set_primary_key "afiliado_id"

  belongs_to :categoria_de_afiliado
  has_many :periodos_de_actividad

# La carga del padrón se hace en un proceso batch y las verificaciones ya son realizadas
# por el sistema de gestión
#  validates_presence_of :clave_de_beneficiario, :apellido, :nombre, :tipo_de_documento
#  validates_presence_of :clase_de_documento, :numero_de_documento, :categoria_de_afiliado_id
#  validates_numericality_of :numero_de_documento, :integer => true
#  validates_uniqueness_of :clave_de_beneficiario

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
      normalizado.gsub!("Ç", "C")
      normalizado.gsub!(/  /, " ")
    end
    return normalizado
  end

  def self.busqueda_por_documento(doc = nil)

    # Verificar el parámetro
    documento = doc.to_s.strip
    if !documento || documento.blank?
      return nil
    end

    # Buscar el número de documento en cualquiera de los campos de documentos
    afiliados = Afiliado.where("(numero_de_documento = ? OR
                                numero_de_documento_de_la_madre = ? OR
                                numero_de_documento_del_padre = ? OR
                                numero_de_documento_del_tutor = ?) AND
                                (mensaje_de_la_baja IS NULL OR
                                mensaje_de_la_baja NOT ILIKE '%dupl%')",
                                documento, documento, documento,
                                documento)

    # Devolver 'nil' si no se encontró el número de documento
    return nil if afiliados.size < 1

    return afiliados
  end

  # Busca un afiliado por su número de documento y nombre, devolviendo todos los posibles candidatos.
  def self.busqueda_por_aproximacion(documento, nombre_y_apellido)
    return nil if !(documento && nombre_y_apellido)

    encontrados = []

    # Primero intentamos encontrarlo por número de documento
    afiliados = Afiliado.where("numero_de_documento = ? OR
                                numero_de_documento_de_la_madre = ? OR
                                numero_de_documento_del_padre = ? OR
                                numero_de_documento_del_tutor = ?", documento,
                                documento, documento, documento,
                                :order => "afiliado_id ASC")

    # Procesar los nombres de todos los afiliados encontrados relacionados con el número de documento,
    # y mantener la/s mejor/es coincidencia/s, descartando el resto.
    nivel_maximo = 1
    afiliados.each do |afiliado|
      nivel_actual = 0
      apellido_afiliado = self.transformar_nombre(afiliado.apellido)
      nombre_afiliado = self.transformar_nombre(afiliado.nombre)
      nombre_y_apellido = self.transformar_nombre(nombre_y_apellido)

      # Verificar apellidos
      case
#        when (apellido_afiliado.split(" ").all? { |apellido| nombre_y_apellido.index(apellido) })
#          # Coinciden todos los apellidos
#          nivel_actual = 8
        when (apellido_afiliado.split(" ").any? { |apellido| (nombre_y_apellido.split(" ").any? { |nomape| nomape == apellido }) })
          # Coincide algún apellido
          nivel_actual = 4
        else
          # No coincide ningún apellido, procedemos a verificar si algún apellido registrado tiene una distancia
          # de Levenshtein menor o igual que 2 con alguno de los informados
          if (nombre_y_apellido.split(" ").any? { |nom_ape| (
              apellido_afiliado.split(" ").any? { |apellido| Text::Levenshtein.distance(nom_ape, apellido) <= 2 }) })
            nivel_actual = 2
          else
            nivel_actual = 1
          end
      end

      # Verificar nombres
      case
        when (nombre_afiliado.split(" ").all? { |nombre| (nombre_y_apellido.split(" ").any? { |nomape| nomape == nombre }) })
          # Coinciden todos los nombres
          nivel_actual *= 16
        when (nombre_afiliado.split(" ").any? { |nombre| (nombre_y_apellido.split(" ").any? { |nomape| nomape == nombre }) })
          # Coincide algún nombre
          nivel_actual *= 8
        else
          # No coincide ningún nombre, procedemos a verificar si algún nombre registrado tiene una distancia de Levenshtein
          # menor o igual que 2 con alguno de los informados
          if (nombre_y_apellido.split(" ").any? { |nom_ape| (
              nombre_afiliado.split(" ").any? { |nombre| Text::Levenshtein.distance(nom_ape, nombre) <= 2 }) })
            nivel_actual *= 4
          else
            nivel_actual *= 1
          end
      end

      if nivel_actual > nivel_maximo
        nivel_maximo = nivel_actual
        encontrados = [afiliado]
      elsif nivel_actual == nivel_maximo
        encontrados << afiliado
      end
    end

    # Eliminar los registros marcados como duplicados (que están dados de baja)
    sin_duplicados = []
    encontrados.each do |afiliado|
      if !afiliado.mensaje_de_la_baja || !afiliado.mensaje_de_la_baja.downcase.match(/dupl/)
        sin_duplicados << afiliado
      end
    end

    return [sin_duplicados, nivel_maximo] if sin_duplicados.size > 0

    ### TODO: ¿probar otros métodos para tratar de encontrar el afiliado?  (por ejemplo: buscar por nombre,
    ###       y luego verificar si el documento está mal ingresado)

    # Devolver 'nil' si no se encontró ningún afiliado que corresponda aproximadamente con los parámetros
    return [nil, 0]
  end

  # Indica si el afiliado estaba inscripto para la fecha del parámetro, o al día de hoy si
  # no se indica una fecha
  def inscripto?(fecha = Date.today)
    return true if (fecha_de_inscripcion <= fecha)
  end

  # Indica si el afiliado estaba activo en el padrón correspondiente al mes y año de la fecha indicada, o
  # en alguno de los padrones de los dos meses siguientes (lapso ventana para la carga de la ficha de inscripción).
  # Si no se pasa una fecha, indica si figura como activo
  def activo?(fecha = nil)
    # Devuelve 'true' si no se especifica una fecha y el campo 'activo' es 'S'
    return (activo.upcase == "S") unless fecha

    # Obtener los periodos de actividad de este afiliado
    periodos = PeriodoDeActividad.where("afiliado_id = #{afiliado_id}")
    periodos.each do |p|
      # Tomamos como fecha de inicio del periodo la que sea mayor entre la inscripción y la fecha de inicio del periodo
      # desplazada dos meses antes (lapso ventana para la carga de la ficha de inscripción).
      inicio = self.max(p.fecha_de_inicio - 2.months, fecha_de_inscripcion)
      if ( fecha >= inicio && (!p.fecha_de_finalizacion || fecha < p.fecha_de_finalizacion))
        return true
      end
    end
    return false
  end

  # Devuelve el mes y año del padrón donde aparece activo si el afiliado estaba activo en esa fecha
  # Esto puede ser el año y mes correspondiente al inicio del periodo de actividad, si estaba activo
  # en ese momento, o bien alguno de los dos meses siguientes (lapso ventana para la carga de la
  # ficha de inscripción).

  def padron_activo(fecha = Date.today)
    return nil unless activo?(fecha)

    # Obtener los periodos de actividad de este afiliado
    periodos = PeriodoDeActividad.where("afiliado_id = #{afiliado_id}")
    periodos.each do |p|
      if (fecha >= self.max(p.fecha_de_inicio - 2.months, fecha_de_inscripcion)) &&
         (!p.fecha_de_finalizacion || fecha < p.fecha_de_finalizacion)
        return p.fecha_de_inicio.strftime("%Y-%m")
      end
    end
  end

  # Devuelve un Array con los códigos de categoría válidos para el afiliado en la fecha especificada.
  # -- OBSOLETO --
  #def categorias(fecha = Date.today)
  #  case
  #    when categoria_de_afiliado_id == 1 # Embarazadas
  #      # Si no hay FPP o FEP se devuelve la misma categoría
  #      return [1] unless (fecha_probable_de_parto || fecha_efectiva_de_parto)
  #      case
  #        when (fpp = fecha_probable_de_parto) # Afiliada con FPP especificada
  #          case
  #            when (fecha - fpp).to_i < -45
  #              # Si la fecha es anterior a la FPP en más de 45 días, sólo se habilita la categoría 1
  #              return [1]
  #            when (fecha - fpp).to_i >= -45 && (fecha - fpp) <= 45
  #              # Si la fecha se encuentra entre 45 días antes y 45 días después de la FPP se habilitan las categorías 1 y 2
  #              return [1, 2]
  #            else
  #              # Si la fecha excede en más de 45 días la FPP, sólo se habilita la categoría 2
  #              return [2]
  #          end
  #        when (fep = fecha_efectiva_de_parto)
  #          case
  #            when (fecha - fep).to_i < -7
  #              # Si la fecha es anterior a la FEP en más de 7 días, sólo se habilita la categoría 1
  #              return [1]
  #            when (fecha - fep).to_i >= -7 && (fecha - fep) <= 7
  #              # Si la fecha se encuentra eentre 7 días antes y 7 días después de la FEP se habilitan las categorías 1 y 2
  #              return [1, 2]
  #            else
  #              # Si la fecha excede en más de 7 días la FEP, sólo se habilita la categoría 2
  #              return [2]
  #          end
  #      end
  #
  #    when categoria_de_afiliado_id == 2 # Puérperas
  #      # Si no hay FEP se devuelve la misma categoría
  #      return [2] unless fecha_efectiva_de_parto
  #      case
  #        when (fecha - fecha_efectiva_de_parto).to_i < -7
  #          # Si la fecha es anterior a la FEP en más de 7 días, sólo se habilita la categoría 1
  #          return [1]
  #        when (fecha - fecha_efectiva_de_parto).to_i >= -7 && (fecha - fecha_efectiva_de_parto) <= 7
  #          # Si la fecha se encuentra eentre 7 días antes y 7 días después de la FEP se habilitan las categorías 1 y 2
  #          return [1, 2]
  #        else
  #          # Si la fecha excede en más de 7 días la FEP, sólo se habilita la categoría 2
  #          return [2]
  #      end
  #
  #    when (categoria_de_afiliado_id == 3 || categoria_de_afiliado_id == 4) # Niños
  #      # Si no hay fecha de nacimiento se devuelve la misma categoría
  #      return [categoria_de_afiliado_id] unless fecha_de_nacimiento
  #      case
  #        when (fecha - fecha_de_nacimiento).to_i < 335
  #          # Si la fecha es anterior a la fecha en que el niño cumple 11 meses (335 días), sólo se habilita la categoría 3
  #          return [3]
  #        when (fecha - fecha_de_nacimiento).to_i >= 335 && (fecha - fecha_de_nacimiento) <= 395
  #          # Si la fecha se encuentra eentre los 11 y 13 meses de edad, se habilitan las categorías 3 y 4
  #          return [3, 4]
  #        else
  #          # Si a la fecha el niño excede los 13 meses de edad, sólo se habilita la categoría 4
  #          return [4]
  #      end
  #    else # Categoria mal definida
  #      return nil
  #  end
  #end

  # Función para convertir un registro de afiliado exportado a texto desde la tabla SMIAfiliados del SQL Server
  # en un Hash etiquetado con los símbolos apropiados para facilitar su utilización.
  def self.attr_hash_desde_texto(texto, separador = "\t")
    campos = texto.split(separador)

    # La tabla ahora tiene 91 campos -- Versión del sistema de Gestión 4.6
    if campos.size != 91
      raise ArgumentError, "El texto no contiene la cantidad correcta de campos (91), ¿quizás equivocó el separador?"
      return nil
    end

    # Crear el Hash asociado al registro
    attr_hash = {

      # Identificadores
      :afiliado_id => self.valor(campos[0], :entero),
      :clave_de_beneficiario => self.valor(campos[1], :texto),

      # Datos personales
      :apellido => self.valor(campos[2], :texto),
      :nombre => self.valor(campos[3], :texto),
      :clase_de_documento_id => ClaseDeDocumento.id_del_codigo(self.valor(campos[5], :texto)),
      :tipo_de_documento_id => TipoDeDocumento.id_del_codigo(self.valor(campos[4], :texto)),
      :numero_de_documento => self.valor(campos[6], :texto),
      :numero_de_celular => self.valor(campos[87], :texto),
      :e_mail => self.valor(campos[86], :texto),

      # Mantenemos la categoría del afiliado por razones de compatibilidad con sistemas anteriores
      :categoria_de_afiliado_id => self.valor(campos[10], :entero),

      # Datos de nacimiento, sexo, origen y estudios
      :sexo_id => Sexo.id_del_codigo(self.valor(campos[7], :texto)),
      :fecha_de_nacimiento => self.valor(campos[11], :fecha),
      :pais_de_nacimiento_id => self.valor(campos[8], :entero),
      :se_declara_indigena => SiNo.valor_bool_del_codigo(self.valor(campos[12], :texto)),
      :lengua_originaria_id => (self.valor(campos[13], :entero) == 0 ? nil : self.valor(campos[13], :entero)),
      :tribu_originaria_id => (self.valor(campos[14], :entero) == 0 ? nil : self.valor(campos[14], :entero)),
      :alfabetizacion_del_beneficiario_id => NivelDeInstruccion.id_del_codigo(self.valor(campos[75], :texto)),
      :alfab_beneficiario_años_ultimo_nivel => self.valor(campos[76], :entero),

      # Datos de residencia, vías de comunicación y lugar habitual de atención
      :domicilio_calle => self.valor(campos[36], :texto),
      :domicilio_numero => self.valor(campos[37], :texto),
      :domicilio_manzana => self.valor(campos[38], :texto),
      :domicilio_piso => self.valor(campos[39], :texto),
      :domicilio_depto => self.valor(campos[40], :texto),
      :domicilio_entre_calle_1 => self.valor(campos[41], :texto),
      :domicilio_entre_calle_2 => self.valor(campos[42], :texto),
      :telefono => self.valor(campos[49], :texto),
      :otro_telefono => self.valor(campos[50], :texto),
      :domicilio_departamento_id => Departamento.id_del_nombre(self.valor(campos[45], :texto)),
      :domicilio_distrito_id => Distrito.id_del_nombre(self.valor(campos[45], :texto), self.valor(campos[46], :texto)),
      :domicilio_barrio_o_paraje => self.valor(campos[43], :texto),
      :domicilio_codigo_postal => self.valor(campos[48], :texto),

      # Lugar de atención habitual
      :lugar_de_atencion_habitual_id => Efector.id_del_cuie(self.valor(campos[68], :texto)),

      # Datos del adulto responsable del menor (para menores de 15 años)
      :apellido_de_la_madre => self.valor(campos[17], :texto),
      :nombre_de_la_madre => self.valor(campos[18], :texto),
      :tipo_de_documento_de_la_madre_id => TipoDeDocumento.id_del_codigo(self.valor(campos[15], :texto)),
      :numero_de_documento_de_la_madre => self.valor(campos[16], :texto),
      :alfabetizacion_de_la_madre_id => NivelDeInstruccion.id_del_codigo(self.valor(campos[77], :texto)),
      :alfab_madre_años_ultimo_nivel => self.valor(campos[78], :entero),
      :apellido_del_padre => self.valor(campos[21], :texto),
      :nombre_del_padre => self.valor(campos[22], :texto),
      :tipo_de_documento_del_padre_id => TipoDeDocumento.id_del_codigo(self.valor(campos[19], :texto)),
      :numero_de_documento_del_padre => self.valor(campos[20], :texto),
      :alfabetizacion_del_padre_id => NivelDeInstruccion.id_del_codigo(self.valor(campos[79], :texto)),
      :alfab_padre_años_ultimo_nivel => self.valor(campos[80], :entero),
      :apellido_del_tutor => self.valor(campos[25], :texto),
      :nombre_del_tutor => self.valor(campos[26], :texto),
      :tipo_de_documento_del_tutor_id => TipoDeDocumento.id_del_codigo(self.valor(campos[23], :texto)),
      :numero_de_documento_del_tutor => self.valor(campos[24], :texto),
      :alfabetizacion_del_tutor_id => NivelDeInstruccion.id_del_codigo(self.valor(campos[81], :texto)),
      :alfab_tutor_años_ultimo_nivel => self.valor(campos[82], :entero),

      # Datos del embarazo y parto (para embarazadas)
      :fecha_de_ultima_menstruacion => self.valor(campos[88], :fecha),
      :fecha_de_diagnostico_del_embarazo => self.valor(campos[30], :fecha),
      :semanas_de_embarazo => (self.valor(campos[31], :entero) == 0 ? nil : self.valor(campos[31], :entero)),
      :fecha_probable_de_parto => self.valor(campos[32], :fecha),
      :fecha_efectiva_de_parto => self.valor(campos[33], :fecha),

      # Score de riesgo cardiovascular del programa Remediar+Redes
      :score_de_riesgo => self.valor(campos[74], :entero),

      # Discapacidad
      :discapacidad => Discapacidad.id_del_codigo(self.valor(campos[90], :texto)),

      # Fecha y centro inscriptor
      :fecha_de_inscripcion => self.valor(campos[28], :fecha),
      # El código de centro de inscripción que se almacena en el campo 'CodigoCIAltaDatos' fue corrompido por
      # un error en el sistema de inscripción que implementó el Ing. Luis Esteves, por lo que no puede utilizarse
      # ese dato para determinar el CI correcto, sino que se extrae de la clave del beneficiario.
      :centro_de_inscripcion_id => CentroDeInscripcion.id_del_codigo(self.valor(campos[1][5..9], :texto)),

      # Observaciones generales
      :observaciones_generales => self.valor(campos[89], :texto),

      # Estado de la inscripción al programa
      :activo => SiNo.valor_bool_del_codigo(self.valor(campos[34], :texto)),
      :motivo_de_la_baja => self.valor(campos[57], :entero),
      :mensaje_de_la_baja => self.valor(campos[58], :texto),

      # Datos relacionados con la carga del registro
      :fecha_y_hora_de_carga => self.valor(campos[61], :fecha_hora),
      :usuario_que_carga => self.valor(campos[62], :texto)

      # A continuación se ubican los campos cuyos datos no se convierten ya que no tienen un uso definido,
      # o bien su utilidad es nula para los procesos modelados en el sistema.
      # Los campos 'provincia' y 'localidad' de la tabla SMIAfiliados del sistema de gestión
      # registrarían la provincia y localidad de nacimiento del beneficiario, pero no se han utilizado nunca.
      # Como en la nueva ficha esos datos ya no se registran, pero sí hay un lugar para registrar
      # el país de nacimiento, dato que no tiene un campo asociado en la tabla SMIAfiliados de la versión 4.6
      # del sistema de gestión, aquí hemos usado el campo 'provincia' para guardar el código asociado al país
      # (sabiendo que es un parche horrible, pero si en una versión futura del sistema de gestión se incorpora
      # el campo a la tabla SMIAfiliados, se moverá al lugar que corresponde.
      # En la provincia de Mendoza, existe un único municipio por departamento, por lo que no tiene sentido
      # registrar # aparte el municipio.
      # El campo que originalmente se utilizaba para indicar en forma textual el lugar de atención
      # habitual nunca se utilizó (siempre tuvo nulos), y lo reutilizamos para guardar el valor
      # de 'Otro teléfono' que figura en la ficha nueva de inscripción, hasta tanto se incorpore el
      # nuevo campo a la tabla SMIAfiliados.
      #
      # CAMPOS NO UTILIZADOS
      #:localidad => self.valor(campos[9], :texto),
      #:tipo_de_relacion_id => self.valor(campos[27], :entero),
      #:fecha_de_alta_efectiva => self.valor(campos[29], :fecha),
      #:accion_pendiente_de_confirmar => self.valor(campos[35], :texto),
      #:domicilio_municipio => self.valor(campos[44], :texto),
      #:domicilio_provincia => self.valor(campos[47], :texto),
      #:fecha_de_envio_de_los_datos => self.valor(campos[51], :fecha),
      #:fecha_de_alta => self.valor(campos[52], :fecha),
      #:pendiente_de_enviar => self.valor(campos[53], :entero),
      #:codigo_provincia_uad => self.valor(campos[54], :texto),
      #:codigo_uad => self.valor(campos[55], :texto),
      #:centro_de_inscripcion_id => CentroDeInscripcion.id_del_codigo(self.valor(campos[56], :texto)),
      #:proceso_de_baja_automatica_id => self.valor(campos[59], :entero),
      #:pendiente_de_enviar_a_nacion => self.valor(campos[60], :entero),
      #:menor_convive_con_tutor => self.valor(campos[63], :texto),
      #:fecha_de_baja_efectiva => self.valor(campos[64], :fecha),
      #:fecha_de_alta_uec => self.valor(campos[65], :fecha),
      #:auditoria => self.valor(campos[66], :texto),
      #:cuie_del_efector_asignado => self.valor(campos[67], :texto),
      #:clave_del_benef_que_provoca_baja => self.valor(campos[69], :texto),
      #:usuario_de_creacion => self.valor(campos[70], :texto),
      #:fecha_de_creacion => self.valor(campos[71], :fecha),
      #:persona_id => self.valor(campos[72], :entero),
      #:confirmacion_del_numero_de_documento => self.valor(campos[73], :texto),
      #:activo_r => self.valor(campos[83], :texto),
      #:motivo_baja_r => self.valor(campos[84], :entero),
      #:mensaje_baja_r => self.valor(campos[85], :texto),
    }
  end

private
  def self.max(a, b)
    a > b ? a : b
  end

  def self.valor(texto, tipo)

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
