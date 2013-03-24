# -*- encoding : utf-8 -*-
class Afiliado < ActiveRecord::Base

  # Cambiar la clave primaria. La clave no es creada por este sistema, sino por el
  # sistema de gestión del padrón. Aunque podría haberse utilizado "id" como
  # identificador, se hizo así para no olvidarse de este hecho.
  self.primary_key = "afiliado_id"

  # El modelo no está asignado a ningún formulario editable por el usuario.
  # Los datos se actualizan por un proceso batch.
  attr_accessible :afiliado_id, :clave_de_beneficiario, :apellido, :nombre, :clase_de_documento_id, :tipo_de_documento_id
  attr_accessible :numero_de_documento, :numero_de_celular, :e_mail, :categoria_de_afiliado_id, :sexo_id, :fecha_de_nacimiento
  attr_accessible :pais_de_nacimiento_id, :se_declara_indigena, :lengua_originaria_id, :tribu_originaria_id
  attr_accessible :alfabetizacion_del_beneficiario_id, :alfab_beneficiario_anios_ultimo_nivel, :domicilio_calle, :domicilio_numero
  attr_accessible :domicilio_piso, :domicilio_depto, :domicilio_manzana, :domicilio_entre_calle_1, :domicilio_entre_calle_2
  attr_accessible :telefono, :otro_telefono, :domicilio_departamento_id, :domicilio_distrito_id, :domicilio_barrio_o_paraje
  attr_accessible :domicilio_codigo_postal, :lugar_de_atencion_habitual_id, :apellido_de_la_madre, :nombre_de_la_madre
  attr_accessible :tipo_de_documento_de_la_madre_id, :numero_de_documento_de_la_madre, :alfabetizacion_de_la_madre_id
  attr_accessible :alfab_madre_anios_ultimo_nivel, :apellido_del_padre, :nombre_del_padre, :tipo_de_documento_del_padre_id
  attr_accessible :numero_de_documento_del_padre, :alfabetizacion_del_padre_id, :alfab_padre_anios_ultimo_nivel
  attr_accessible :apellido_del_tutor, :nombre_del_tutor, :tipo_de_documento_del_tutor_id, :numero_de_documento_del_tutor
  attr_accessible :alfabetizacion_del_tutor_id, :alfab_tutor_anios_ultimo_nivel, :embarazo_actual, :fecha_de_la_ultima_menstruacion
  attr_accessible :fecha_de_diagnostico_del_embarazo, :semanas_de_embarazo, :fecha_probable_de_parto, :fecha_efectiva_de_parto
  attr_accessible :score_de_riesgo, :discapacidad_id, :fecha_de_inscripcion, :fecha_de_la_ultima_novedad
  attr_accessible :unidad_de_alta_de_datos_id, :centro_de_inscripcion_id, :observaciones_generales, :activo
  attr_accessible :motivo_de_la_baja_id, :mensaje_de_la_baja, :fecha_de_carga, :usuario_que_carga
  attr_accessible :cobertura_efectiva_basica, :efector_ceb_id, :fecha_de_la_ultima_prestacion, :prestacion_ceb_id, :grupo_poblacional_id
  attr_accessible :devenga_capita, :devenga_cantidad_de_capitas

  # Las verificaciones ya son realizadas por el sistema de gestión.
  # validate_...

  # Asociaciones con otros modelos
  belongs_to :clase_de_documento
  belongs_to :tipo_de_documento
  #belongs_to :categoria_de_afiliado    # --OBSOLETO--
  belongs_to :sexo
  has_many :periodos_de_actividad
  belongs_to :pais_de_nacimiento, :class_name => "Pais"
  belongs_to :lengua_originaria
  belongs_to :tribu_originaria
  belongs_to :alfabetizacion_del_beneficiario, :class_name => "NivelDeInstruccion"
  belongs_to :domicilio_departamento, :class_name => "Departamento"
  belongs_to :domicilio_distrito, :class_name => "Distrito"
  belongs_to :lugar_de_atencion_habitual, :class_name => "Efector"
  belongs_to :tipo_de_documento_de_la_madre, :class_name => "TipoDeDocumento"
  belongs_to :tipo_de_documento_de_la_madre, :class_name => "TipoDeDocumento"
  belongs_to :alfabetizacion_de_la_madre, :class_name => "NivelDeInstruccion"
  belongs_to :tipo_de_documento_del_padre, :class_name => "TipoDeDocumento"
  belongs_to :alfabetizacion_del_padre, :class_name => "NivelDeInstruccion"
  belongs_to :tipo_de_documento_del_tutor, :class_name => "TipoDeDocumento"
  belongs_to :alfabetizacion_del_tutor, :class_name => "NivelDeInstruccion"
  belongs_to :discapacidad
  belongs_to :centro_de_inscripcion
  belongs_to :unidad_de_alta_de_datos
  belongs_to :efector_ceb, :class_name => "Efector"
  belongs_to :prestacion_ceb, :class_name => "Prestacion"
  belongs_to :grupo_poblacional

  #
  # Métodos disponibles en las instancias
  #
  
  # edad_en_años
  # Devuelve la edad en años cumplidos para la fecha de cálculo indicada, o para el día de hoy, si no se
  # indica una fecha.
  def edad_en_anios(fecha_de_calculo = Date.today)

    # Calculamos la diferencia entre los años de ambas fechas
    if fecha_de_nacimiento
      diferencia_en_anios = (fecha_de_calculo.year - fecha_de_nacimiento.year)
    else
      return nil
    end

    # Calculamos la diferencia entre los meses de ambas fechas
    diferencia_en_meses = (fecha_de_calculo.month - fecha_de_nacimiento.month)

    # Calculamos la diferencia en días y ajustamos la diferencia en meses en forma acorde
    diferencia_en_dias = (fecha_de_calculo.day) - (fecha_de_nacimiento.day)
    if diferencia_en_dias < 0 then diferencia_en_meses -= 1 end

    # Ajustamos la diferencia en años en forma acorde
    if diferencia_en_meses < 0 then diferencia_en_anios -= 1 end

    # Devolver la cantidad de años
    return diferencia_en_anios

  end

  # inscripto?
  # Indica si el afiliado estaba inscripto para la fecha del parámetro, o al día de hoy si
  # no se indica una fecha
  #
  def inscripto?(fecha = Date.today)
    fecha_de_inscripcion <= fecha
  end

  # activo?
  # Indica si el afiliado estaba activo en el padrón correspondiente al mes y año de la fecha indicada, o
  # en alguno de los padrones de los cuatro meses siguientes (lapso ventana para la carga de la ficha de inscripción).
  # Si no se pasa una fecha, indica si figura actualmente como beneficiario activo
  #
  def activo?(fecha = nil)

    # Devuelve 'true' si no se especifica una fecha y el campo 'activo' es 'S'
    return (activo.upcase == "S") unless fecha

    # Obtener los periodos de actividad de este afiliado
    periodos = PeriodoDeActividad.where("afiliado_id = #{afiliado_id}")
    periodos.each do |p|
      # Tomamos como fecha de inicio del periodo la que sea mayor entre la inscripción y la fecha de inicio del periodo
      # desplazada dos meses antes (lapso ventana para la carga de la ficha de inscripción).
      inicio = [p.fecha_de_inicio - 4.months, fecha_de_inscripcion].max
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
  #
  def padron_activo(fecha = Date.today)

    # Devolver nil si el beneficiario no estaba activo para esa fecha.
    return nil unless activo?(fecha)

    # Buscar el periodo en que estuvo activo el beneficiario para esa fecha, y devolver el año y mes
    # inicial de dicho periodo
    periodos = PeriodoDeActividad.where("afiliado_id = #{afiliado_id}")
    periodos.each do |p|
      if (fecha >= [p.fecha_de_inicio - 2.months, fecha_de_inscripcion].max) &&
         (!p.fecha_de_finalizacion || fecha < p.fecha_de_finalizacion)
        return p.fecha_de_inicio.strftime("%Y-%m")
      end
    end

  end

  # menor?
  # Indica si el beneficiario tenía para la fecha indicada (o al día de hoy si no se indica una fecha)
  # una edad donde es exigible que se registren los datos del adulto responsable.
  #
  def menor?(fecha_de_calculo = Date.today)
    (edad_en_anios || 0) < Parametro.valor_del_parametro(:edad_limite_para_exigir_adulto_responsable)
  end

  # embarazada?
  # Indica si la beneficiaria cursaba para la fecha indicada (o al día de hoy si no se indica una fecha)
  # un embarazo.
  #
  def embarazada?(fecha = Date.today)

    # Verificar que la beneficiaria sea de sexo femenino y su edad mayor que el mínimo establecido
    if (sexo_id == 1 &&
      (edad_en_anios || 0) >= Parametro.valor_del_parametro(:edad_minima_para_registrar_embarazada) &&
      fecha_probable_de_parto)
      if ((fecha_probable_de_parto - 40.weeks)..(fecha_probable_de_parto + 45.days)) === fecha
        return true
      end
    end

    return false

  end

  # semanas_de_gestacion_segun_fum
  # Indica las semanas de gestación cumplidas según la fecha de la última menstruación, para la fecha
  # indicada como parámetro (o para el día de hoy si no se indica la fecha)
  #
  def semanas_de_gestacion_segun_fum(fecha = Date.today)

    # Devolver nil si no existe FUM o la fecha está fuera del periodo de embarazo, parto o puerperio
    if (!fecha_de_la_ultima_menstruacion ||
      fecha < fecha_de_la_ultima_menstruacion ||
      fecha > (fecha_de_la_ultima_menstruacion + 40.weeks + 45.days))
      return nil
    end

    # Calcular la cantidad de semanas
    return ((fecha - fecha_de_la_ultima_menstruacion) / 7).to_i

  end

  # semanas_de_gestacion_segun_fpp
  # Indica las semanas de gestación cumplidas según la fecha probable de parto, para la fecha
  # indicada como parámetro (o para el día de hoy si no se indica la fecha)
  #
  def semanas_de_gestacion_segun_fpp(fecha = Date.today)

    # Devolver nil si no existe FPP o la fecha está fuera del periodo de embarazo, parto o puerperio
    if (!fecha_probable_de_parto ||
      fecha < (fecha_probable_de_parto - 40.weeks) ||
      fecha > (fecha_probable_de_parto + 45.days))
      return nil
    end

    # Calcular la cantidad de semanas
    fum = (fecha_probable_de_parto - 40.weeks)
    return ((fecha - fum) / 7).to_i

  end

  # novedad_pendiente?
  # Indica si el afiliado cuenta con alguna novedad ingresada que aún esté pendiente.
  def novedad_pendiente?
    novedad_pendiente = NovedadDelAfiliado.where(
      :clave_de_beneficiario => clave_de_beneficiario,
      :estado_de_la_novedad_id => [1,2,3]
    )

    return (novedad_pendiente.size > 0)
  end

  # novedad_pendiente
  # Devuelve la novedad pendiente que tiene este afiliado
  def novedad_pendiente
    novedad_pendiente = NovedadDelAfiliado.where(
      :clave_de_beneficiario => clave_de_beneficiario,
      :estado_de_la_novedad_id => [1,2,3]
    )

    return novedad_pendiente.first if novedad_pendiente.size == 1

    return nil
  end

  def nombre_completo

    nombre_completo = nombre + " " + apellido

    if nombre_completo.size > 35
      nombre_completo = nombre_completo[0..31] + "..."
    end

    return nombre_completo

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

  #
  # Métodos de clase para búsquedas
  #

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
                                numero_de_documento_del_tutor = ?))",
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
    afiliados = Afiliado.where("(numero_de_documento = ? OR
                                numero_de_documento_de_la_madre = ? OR
                                numero_de_documento_del_padre = ? OR
                                numero_de_documento_del_tutor = ?) AND
                                (motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83) OR
                                motivo_de_la_baja_id IS NULL)", documento,
                                documento, documento, documento).order("afiliado_id ASC")

    # Procesar los nombres de todos los afiliados encontrados relacionados con el número de documento,
    # y mantener la/s mejor/es coincidencia/s, descartando el resto.
    nivel_maximo = 1
    afiliados.each do |afiliado|
      nivel_actual = 0
      apellido_afiliado = (self.transformar_nombre(afiliado.apellido) || "")
      nombre_afiliado = (self.transformar_nombre(afiliado.nombre) || "")
      nombre_y_apellido = (self.transformar_nombre(nombre_y_apellido) || "")

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

  # Función para convertir un registro de afiliado exportado a texto desde la tabla SMIAfiliados del SQL Server
  # en un Hash etiquetado con los símbolos apropiados para facilitar su utilización.
  def self.attr_hash_desde_texto(texto, separador = "\t")
    campos = texto.split(separador)

    # Contrastar la cantidad de campos con la versión del sistema registrada en los parámetros, para evitar errores
    # de importación
    if (campos.size != 100)
      raise ArgumentError, "El texto no contiene la cantidad correcta de campos, ¿quizás equivocó el separador?"
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
      :pais_de_nacimiento_id => Pais.id_del_nombre(self.valor(campos[92], :texto)),
      :se_declara_indigena => SiNo.valor_bool_del_codigo(self.valor(campos[12], :texto)),
      :lengua_originaria_id => (self.valor(campos[13], :entero) == 0 ? nil : self.valor(campos[13], :entero)),
      :tribu_originaria_id => (self.valor(campos[14], :entero) == 0 ? nil : self.valor(campos[14], :entero)),
      :alfabetizacion_del_beneficiario_id => NivelDeInstruccion.id_del_codigo(self.valor(campos[75], :texto)),
      :alfab_beneficiario_anios_ultimo_nivel => self.valor(campos[76], :entero),

      # Datos de domicilio
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

      # Datos del adulto responsable del menor
      :apellido_de_la_madre => self.valor(campos[17], :texto),
      :nombre_de_la_madre => self.valor(campos[18], :texto),
      :tipo_de_documento_de_la_madre_id => TipoDeDocumento.id_del_codigo(self.valor(campos[15], :texto)),
      :numero_de_documento_de_la_madre => self.valor(campos[16], :texto),
      :alfabetizacion_de_la_madre_id => NivelDeInstruccion.id_del_codigo(self.valor(campos[77], :texto)),
      :alfab_madre_anios_ultimo_nivel => self.valor(campos[78], :entero),
      :apellido_del_padre => self.valor(campos[21], :texto),
      :nombre_del_padre => self.valor(campos[22], :texto),
      :tipo_de_documento_del_padre_id => TipoDeDocumento.id_del_codigo(self.valor(campos[19], :texto)),
      :numero_de_documento_del_padre => self.valor(campos[20], :texto),
      :alfabetizacion_del_padre_id => NivelDeInstruccion.id_del_codigo(self.valor(campos[79], :texto)),
      :alfab_padre_anios_ultimo_nivel => self.valor(campos[80], :entero),
      :apellido_del_tutor => self.valor(campos[25], :texto),
      :nombre_del_tutor => self.valor(campos[26], :texto),
      :tipo_de_documento_del_tutor_id => TipoDeDocumento.id_del_codigo(self.valor(campos[23], :texto)),
      :numero_de_documento_del_tutor => self.valor(campos[24], :texto),
      :alfabetizacion_del_tutor_id => NivelDeInstruccion.id_del_codigo(self.valor(campos[81], :texto)),
      :alfab_tutor_anios_ultimo_nivel => self.valor(campos[82], :entero),

      # Datos del embarazo y parto (para embarazadas)
      :embarazo_actual => SiNo.valor_bool_del_codigo(self.valor(campos[91], :texto)),
      :fecha_de_la_ultima_menstruacion => self.valor(campos[88], :fecha),
      :fecha_de_diagnostico_del_embarazo => self.valor(campos[30], :fecha),
      :semanas_de_embarazo => (self.valor(campos[31], :entero) == 0 ? nil : self.valor(campos[31], :entero)),
      :fecha_probable_de_parto => self.valor(campos[32], :fecha),
      :fecha_efectiva_de_parto => self.valor(campos[33], :fecha),

      # Score de riesgo cardiovascular del programa Remediar+Redes
      :score_de_riesgo => self.valor(campos[74], :entero),

      # Discapacidad
      :discapacidad_id => Discapacidad.id_del_codigo(self.valor(campos[90], :texto)),

      # Fecha de inscripción / modificación, centro inscriptor y unidad de alta de datos
      :fecha_de_inscripcion => self.valor(campos[28], :fecha),
      # Aprovechamos el campo sin utilizar de "FechaAltaEfectiva" de la tabla SMIAfiliados para almacenar la
      # fecha de la última modificación realizada al registro del beneficiario.
      :fecha_de_la_ultima_novedad => self.valor(campos[29], :fecha),
      :unidad_de_alta_de_datos_id => UnidadDeAltaDeDatos.id_del_codigo(self.valor(campos[55], :texto)),
      :centro_de_inscripcion_id => CentroDeInscripcion.id_del_codigo(self.valor(campos[56], :texto)),

      # Observaciones generales
      :observaciones_generales => self.valor(campos[89], :texto),

      # Estado de la inscripción al programa
      :activo => SiNo.valor_bool_del_codigo(self.valor(campos[34], :texto)),
      :motivo_de_la_baja_id => self.valor(campos[57], :entero),
      :mensaje_de_la_baja => self.valor(campos[58], :texto),

      # Datos relacionados con la carga del registro
      :fecha_de_carga => self.valor(campos[61], :fecha),
      :usuario_que_carga => self.valor(campos[62], :texto),

      # Datos añadidos para la determinación de la CEB
      :cobertura_efectiva_basica => SiNo.valor_bool_del_codigo(self.valor(campos[93], :texto)),
      :efector_ceb_id => Efector.id_del_cuie(self.valor(campos[94], :texto)),
      :fecha_de_la_ultima_prestacion => self.valor(campos[95], :fecha),
      :prestacion_ceb_id => Prestacion.id_del_codigo(self.valor(campos[96], :texto)),
      :devenga_capita => SiNo.valor_bool_del_codigo(self.valor(campos[97], :texto)),
      :devenga_cantidad_de_capitas => self.valor(campos[98], :entero),
      :grupo_poblacional_id => GrupoPoblacional.id_del_codigo(self.valor(campos[99], :texto))

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
      #:provincia => self.valor(campos[8], :texto),
      #:tipo_de_relacion_id => self.valor(campos[27], :entero),
      #:accion_pendiente_de_confirmar => self.valor(campos[35], :texto),
      #:domicilio_municipio => self.valor(campos[44], :texto),
      #:domicilio_provincia => self.valor(campos[47], :texto),
      #:fecha_de_envio_de_los_datos => self.valor(campos[51], :fecha),
      #:fecha_de_alta => self.valor(campos[52], :fecha),
      #:pendiente_de_enviar => self.valor(campos[53], :entero),
      #:codigo_provincia_uad => self.valor(campos[54], :texto),
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

  #
  # menores_de_6_activos
  # Calcula la cantidad de beneficiarios menores de 6 años activos a la fecha del parámetro
  # separados en dos grupos según posean CEB o no.
  def self.menores_de_6_activos(fecha_base = Date.new(Date.today.year, Date.today.month, 1))
    ActiveRecord::Base.connection.exec_query(
      "SELECT
         SUM(
           CASE
             WHEN (pc.fecha_de_inicio IS NULL OR pc.fecha_de_inicio > '#{fecha_base}'
                   OR pc.fecha_de_finalizacion <= '#{fecha_base}') THEN
               1::int8
             ELSE
               0::int8
             END
         ) AS activos_sin_ceb,
         SUM(
           CASE
             WHEN (pc.fecha_de_inicio <= '#{fecha_base}' AND (pc.fecha_de_finalizacion IS NULL
                   OR pc.fecha_de_finalizacion > '#{fecha_base}')) THEN
               1::int8
             ELSE
               0::int8
           END
         ) AS activos_con_ceb,
         COUNT(*) AS activos_totales
         FROM afiliados af
           LEFT JOIN periodos_de_actividad pa ON (af.afiliado_id = pa.afiliado_id)
           LEFT JOIN periodos_de_cobertura pc ON (af.afiliado_id = pc.afiliado_id)
         WHERE
           pa.fecha_de_inicio <= '#{fecha_base}'
           AND (pa.fecha_de_finalizacion IS NULL OR pa.fecha_de_finalizacion > '#{fecha_base}')
           AND fecha_de_nacimiento >= '#{fecha_base - 6.years}';
      ").rows[0].collect{ |v| v.to_i }
  end

  #
  # de_6_a_9_activos
  # Calcula la cantidad de beneficiarios activos que tienen entre 6 y 9 años a la fecha del parámetro
  # separados en dos grupos según posean CEB o no.
  def self.de_6_a_9_activos(fecha_base = Date.new(Date.today.year, Date.today.month, 1))
    ActiveRecord::Base.connection.exec_query(
      "SELECT
         SUM(
           CASE
             WHEN (pc.fecha_de_inicio IS NULL OR pc.fecha_de_inicio > '#{fecha_base}'
                   OR pc.fecha_de_finalizacion <= '#{fecha_base}') THEN
               1::int8
             ELSE
               0::int8
             END
         ) AS activos_sin_ceb,
         SUM(
           CASE
             WHEN (pc.fecha_de_inicio <= '#{fecha_base}' AND (pc.fecha_de_finalizacion IS NULL
                   OR pc.fecha_de_finalizacion > '#{fecha_base}')) THEN
               1::int8
             ELSE
               0::int8
           END
         ) AS activos_con_ceb,
         COUNT(*) AS activos_totales
         FROM afiliados af
           LEFT JOIN periodos_de_actividad pa ON (af.afiliado_id = pa.afiliado_id)
           LEFT JOIN periodos_de_cobertura pc ON (af.afiliado_id = pc.afiliado_id)
         WHERE
           pa.fecha_de_inicio <= '#{fecha_base}'
           AND (pa.fecha_de_finalizacion IS NULL OR pa.fecha_de_finalizacion > '#{fecha_base}')
           AND af.fecha_de_nacimiento < '#{fecha_base - 6.years}'
           AND af.fecha_de_nacimiento >= '#{fecha_base - 10.years}';
      ").rows[0].collect{ |v| v.to_i }
  end

  #
  # adolescentes_activos
  # Calcula la cantidad de beneficiarios activos que tienen entre 10 y 19 años a la fecha del parámetro
  def self.adolescentes_activos(fecha_base = Date.new(Date.today.year, Date.today.month, 1))
    ActiveRecord::Base.connection.exec_query(
      "SELECT
         SUM(
           CASE
             WHEN (pc.fecha_de_inicio IS NULL OR pc.fecha_de_inicio > '#{fecha_base}'
                   OR pc.fecha_de_finalizacion <= '#{fecha_base}') THEN
               1::int8
             ELSE
               0::int8
             END
         ) AS activos_sin_ceb,
         SUM(
           CASE
             WHEN (pc.fecha_de_inicio <= '#{fecha_base}' AND (pc.fecha_de_finalizacion IS NULL
                   OR pc.fecha_de_finalizacion > '#{fecha_base}')) THEN
               1::int8
             ELSE
               0::int8
           END
         ) AS activos_con_ceb,
         COUNT(*) AS activos_totales
         FROM afiliados af
           LEFT JOIN periodos_de_actividad pa ON (af.afiliado_id = pa.afiliado_id)
           LEFT JOIN periodos_de_cobertura pc ON (af.afiliado_id = pc.afiliado_id)
         WHERE
           pa.fecha_de_inicio <= '#{fecha_base}'
           AND (pa.fecha_de_finalizacion IS NULL OR pa.fecha_de_finalizacion > '#{fecha_base}')
           AND af.fecha_de_nacimiento < '#{fecha_base - 10.years}'
           AND af.fecha_de_nacimiento >= '#{fecha_base - 20.years}';
      ").rows[0].collect{ |v| v.to_i }
  end

  #
  # mujeres_de_20_a_64_activas
  # Calcula la cantidad de beneficiarias mujeres activas que tienen entre 20 y 64 años a la fecha del parámetro
  def self.mujeres_de_20_a_64_activas(fecha_base = Date.new(Date.today.year, Date.today.month, 1))
    ActiveRecord::Base.connection.exec_query(
      "SELECT
         SUM(
           CASE
             WHEN (pc.fecha_de_inicio IS NULL OR pc.fecha_de_inicio > '#{fecha_base}'
                   OR pc.fecha_de_finalizacion <= '#{fecha_base}') THEN
               1::int8
             ELSE
               0::int8
             END
         ) AS activos_sin_ceb,
         SUM(
           CASE
             WHEN (pc.fecha_de_inicio <= '#{fecha_base}' AND (pc.fecha_de_finalizacion IS NULL
                   OR pc.fecha_de_finalizacion > '#{fecha_base}')) THEN
               1::int8
             ELSE
               0::int8
           END
         ) AS activos_con_ceb,
         COUNT(*) AS activos_totales
         FROM afiliados af
           LEFT JOIN periodos_de_actividad pa ON (af.afiliado_id = pa.afiliado_id)
           LEFT JOIN periodos_de_cobertura pc ON (af.afiliado_id = pc.afiliado_id)
           LEFT JOIN sexos sx ON (af.sexo_id = sx.id)
         WHERE
           pa.fecha_de_inicio <= '#{fecha_base}'
           AND (pa.fecha_de_finalizacion IS NULL OR pa.fecha_de_finalizacion > '#{fecha_base}')
           AND af.fecha_de_nacimiento < '#{fecha_base - 20.years}'
           AND af.fecha_de_nacimiento >= '#{fecha_base - 65.years}'
           AND sx.codigo = 'F';
      ").rows[0].collect{ |v| v.to_i }
  end

private
  # Normaliza un nombre (o apellido) a mayúsculas, eliminando caracteres extraños y acentos
  def self.transformar_nombre(nombre)
    return nil unless nombre
    normalizado = nombre.mb_chars.upcase.to_s

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

end
