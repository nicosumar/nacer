# -*- encoding : utf-8 -*-

class ProcesarPrestacionesRetroactivas

  attr_accessor :archivo_a_procesar
  attr_accessor :unidad_de_alta_de_datos
  attr_accessor :centro_de_inscripcion
  attr_accessor :efector
  attr_accessor :tiene_etiquetas_de_columnas
  attr_accessor :hash_clases
  attr_accessor :hash_tipos
  attr_accessor :prestaciones_por_sexo
  attr_accessor :prestaciones_por_grupo
  attr_accessor :prestaciones_por_efector

  def initialize
    @archivo_a_procesar = nil
    @tiene_etiquetas_de_columna = false
    @hash_efectores = {}
    @hash_clases = {}
    @hash_tipos = {}
    @hash_sexos = {}

    Efector.find(:all).each do |e|
      @hash_efectores.merge! e.cuie => {:id => e.id, :nombre => e.nombre}
    end
    ClaseDeDocumento.find(:all).each do |i|
      @hash_clases.merge! i.id => i.nombre
    end
    TipoDeDocumento.find(:all).each do |i|
      @hash_tipos.merge! i.id => i.nombre
    end
    Sexo.find(:all).each do |i|
      @hash_sexos.merge! i.id => i.nombre
    end
  end


  def procesar(archivo)
    raise ArgumentError if archivo.blank?

    self.archivo_a_procesar = archivo

    crear_modelo_y_tabla
    procesar_archivo
    escribir_resultados
#    eliminar_tabla
  end

  def eliminar_tabla
    ActiveRecord::Base.connection.execute "
      DROP TABLE IF EXISTS procesar_prestaciones;
      DROP SEQUENCE IF EXISTS procesar_prestaciones_id_seq;
    "
  end

  def escribir_resultados

  end

  def crear_modelo_y_tabla
    ActiveRecord::Base.connection.schema_search_path = "uad_007, public"
    ActiveRecord::Base.connection.execute "
      DROP TABLE IF EXISTS uad_007.procesar_prestaciones;
      CREATE TABLE uad_007.procesar_prestaciones (
        id integer,
        cuie_administrador_informado varchar(255),
        cuie_efector_informado varchar(255),
        alias_efector varchar(255),
        fecha_de_la_prestacion_informado varchar(255),
        nombre_informado varchar(255),
        numero_de_documento_informado varchar(255),
        fecha_de_nacimiento_informado varchar(255),
        historia_clinica varchar(255),
        tipo_de_prestacion_informado varchar(255),
        objeto_de_prestacion_informado varchar(255),
        diagnostico_informado varchar(255),
        grupo_informado varchar(255),
        codigo_prestacion_informado varchar(255),
        administrador_id integer,
        efector_id integer,
        fecha_de_la_prestacion date,
        clave_de_beneficiario varchar(255),
        apellido varchar(255),
        nombre varchar(255),
        clase_de_documento_id integer,
        tipo_de_documento_id integer,
        numero_de_documento integer,
        sexo_id integer,
        fecha_de_nacimiento date,
        grupo_poblacional_informado_id integer,
        grupo_poblacional_calculado_id integer,
        prestacion_id integer,
        diagnostico_id integer,
        monto numeric(15,4),
        aceptada boolean,
        errores text
      );
    "

    if !Class::constants.member?("ProcesarPrestacion")
      Object.const_set("ProcesarPrestacion", Class.new(ActiveRecord::Base) {
        set_table_name "procesar_prestaciones"
        attr_accessible :cuie_administrador_informado, :cuie_efector_informado, :alias_efector, :fecha_de_la_prestacion_informado
        attr_accessible :nombre_informado, :numero_de_documento_informado, :fecha_de_nacimiento_informado, :historia_clinica
        attr_accessible :tipo_de_prestacion_informado, :objeto_de_prestacion_informado, :diagnostico_informado, :grupo_informado
        attr_accessible :codigo_prestacion_informado, :administrador_id, :efector_id, :fecha_de_la_prestacion, :clave_de_beneficiario
        attr_accessible :apellido, :nombre, :clase_de_documento_id, :tipo_de_documento_id, :numero_de_documento, :fecha_de_nacimiento
        attr_accessible :grupo_poblacional_informado_id, :grupo_poblacional_calculado_id, :prestacion_id, :diagnostico_id, :monto
        attr_accessible :aceptada, :errores, :sexo_id, :id

        def agregar_error(texto)
          if self.errores.blank?
            self.errores = texto
          else
            self.errores = self.errores + " - " + texto
          end
        end
      })
    end
  end

  def procesar_archivo
    raise ArgumentError unless @archivo_a_procesar.present?

    ActiveRecord::Base.logger.silence do
      archivo = File.open(@archivo_a_procesar, "r")

      archivo.each_with_index do |linea, i|
        if !tiene_etiquetas_de_columnas || i != 0
          prestacion_brindada = ProcesarPrestacion.new(parsear_linea(linea).merge :id => i)

          # Intentar encontrar el beneficiario al que se le brindó la prestación
          if prestacion_brindada.clave_de_beneficiario.present?
            # Si se pasa una clave de beneficiario, solo intentamos encontrarlo por ese criterio
            beneficiario = Afiliado.find_by_clave_de_beneficiario(prestacion_brindada.clave_de_beneficiario)
            if !beneficiario.present?
              prestacion_brindada.agregar_error(
                "La clave de beneficiario '#{prestacion_brindada.clave_de_beneficiario}' no se encontró en el padrón"
              )
            end
          else
            # Intentar encontrar beneficiarios relacionados con el número de documento, apellido y nombre.
            beneficiarios, nivel =
              Afiliado.busqueda_por_aproximacion(
                prestacion_brindada.numero_de_documento_informado,
                prestacion_brindada.nombre_informado.to_s
              )

            if beneficiarios.present? && nivel > 4
              # Beneficiario encontrado -- o por lo menos con alta probabilidad --
              beneficiario = beneficiarios.first
            else
              beneficiario = nil
              prestacion_brindada.agregar_error(
                "No se encontró al beneficiario " + \
                "'#{prestacion_brindada.nombre_informado} con documento número '#{prestacion_brindada.numero_de_documento_informado}' en el padrón"
              )
            end
          end

          # Registrar el error y continuar con la próxima línea si no se encontró al beneficiario
          if !beneficiario.present?
            prestacion_brindada.aceptada = false
            prestacion_brindada.save
            next
          end

          prestacion_brindada.attributes = {
            :clave_de_beneficiario => beneficiario.clave_de_beneficiario,
            :apellido => beneficiario.apellido,
            :nombre => beneficiario.nombre,
            :clase_de_documento_id => beneficiario.clase_de_documento_id,
            :tipo_de_documento_id => beneficiario.tipo_de_documento_id,
            :numero_de_documento => beneficiario.numero_de_documento,
            :sexo_id => beneficiario.sexo_id,
            :fecha_de_nacimiento => beneficiario.fecha_de_nacimiento
          }

          # TODO: cambiar esto por verificaciones del motivo de baja
          # Registrar el error y continuar con la próxima línea si el beneficiario tiene datos imprescindibles incompletos
          if !(beneficiario.sexo.present? && beneficiario.fecha_de_nacimiento.present?)
            prestacion_brindada.agregar_error(
              "No se puede evaluar la prestación porque al registro del beneficiario le faltan datos imprescindibles (sexo o fecha de nacimiento)"
            )
          end

          # Registrar el error si la fecha de la prestación no tiene un formato reconocible
          if !prestacion_brindada.fecha_de_la_prestacion.present?
            prestacion_brindada.agregar_error(
              "La fecha de la prestación no se pudo reconocer (cadena evaluada: '#{prestacion_brindada.fecha_de_la_prestacion_informado}')"
            )
          end

          # Registrar un error si la fecha de la prestación no está en el intervalo esperado
          if !prestacion_brindada.fecha_de_la_prestacion.present?
            prestacion_brindada.agregar_error(
              "La fecha de la prestación no se pudo reconocer (cadena evaluada: '#{prestacion_brindada.fecha_de_la_prestacion_informado}')"
            )
          elsif prestacion_brindada.fecha_de_la_prestacion < Date.new(2012, 8, 1) || prestacion_brindada.fecha_de_la_prestacion > Date.new(2013, 8, 31)
            prestacion_brindada.agregar_error(
              "La fecha de la prestación no está dentro del periodo de facturación de prestaciones retroactivas (cadena evaluada: '#{prestacion_brindada.fecha_de_la_prestacion_informado}')"
            )
          end

          # Obtener la prestación y el diagnóstico asociados con el código informado, o indicar el error si no se informó el código
          if !prestacion_brindada.codigo_prestacion_informado.present?
            prestacion_brindada.agregar_error(
              "No se informó el código de prestación"
            )
          end

          codigo_prestacion = prestacion_brindada.codigo_prestacion_informado[0..5]
          if !Prestacion.find_by_codigo(codigo_prestacion).present?
            prestacion_brindada.agregar_error(
              "El código de prestación no existe (cadena evaluada: '#{codigo_prestacion}')"
            )
          end

          codigo_diagnostico = prestacion_brindada.codigo_prestacion_informado[6..-1]
          diagnostico = Diagnostico.find_by_codigo(codigo_diagnostico)
          if !diagnostico.present?
            prestacion_brindada.agregar_error(
              "El código de diagnóstico no existe (cadena evaluada: '#{codigo_diagnostico}')"
            )
          end

          # Continuar con la próxima línea si se produjo algún error hasta este punto del proceso
          if !prestacion_brindada.errores.blank?
            prestacion_brindada.aceptada = false
            prestacion_brindada.save
            next
          end

          # Verificación del grupo poblacional
          grupo_poblacional = beneficiario.grupo_poblacional_al_dia(prestacion_brindada.fecha_de_la_prestacion)
          if !grupo_poblacional.present?
            prestacion_brindada.agregar_error(
              "El beneficiario no integra la población objetivo del Programa Sumar (sexo: " + \
              "'#{beneficiario.sexo.nombre}', edad: '#{beneficiario.edad_en_anios(prestacion_brindada.fecha_de_la_prestacion)} años')"
            )
            prestacion_brindada.aceptada = false
            prestacion_brindada.save
            next
          end

          if prestacion_brindada.grupo_poblacional_informado_id.present? && grupo_poblacional.id != prestacion_brindada.grupo_poblacional_informado_id
            prestacion_brindada.agregar_error(
              "El beneficiario no pertenece al grupo poblacional informado (informado: " + \
              "'#{prestacion_brindada.grupo_informado}', calculado: '#{grupo_poblacional.nombre}')"
            )
            prestacion_brindada.aceptada = false
            prestacion_brindada.save
            next
          end

          # Intentar individualizar una prestación que tenga el código informado, admita el diagnóstico informado,
          prestaciones = Prestacion.where(
            "codigo = ?
              AND EXISTS (
                SELECT *
                  FROM diagnosticos_prestaciones
                  WHERE
                    diagnosticos_prestaciones.prestacion_id = prestaciones.id
                    AND diagnosticos_prestaciones.diagnostico_id = ?
              )
              AND EXISTS (
                SELECT *
                  FROM grupos_poblacionales_prestaciones
                  WHERE
                    grupos_poblacionales_prestaciones.prestacion_id = prestaciones.id
                    AND grupos_poblacionales_prestaciones.grupo_poblacional_id = ?
              )",
              codigo_prestacion, diagnostico.id, grupo_poblacional.id
            )

          # Registrar el error y continuar con la próxima línea si no se encuentra una prestación para esa combinación de
          # código, grupo poblacional y diagnóstico
          if prestaciones.size == 0
            prestacion_brindada.agregar_error(
              "No se encontró una prestación con código '#{codigo_prestacion}'" + \
              " y diagnóstico '#{diagnostico.nombre} (#{codigo_diagnostico})' en el grupo poblacional '#{grupo_poblacional.nombre}'"
            )
            prestacion_brindada.aceptada = false
            prestacion_brindada.save
            next
          end

          # Verificar que esté autorizada para el sexo del beneficiario
          autorizadas_por_sexo = beneficiario.sexo.prestaciones_autorizadas

          # Descartamos las prestaciones que no están autorizadas para el sexo del beneficiario
          prestaciones.keep_if{|p| autorizadas_por_sexo.member?(p)}

          # Registrar el error y continuar con la próxima línea si ninguna de las prestaciones estaba habilitada para el sexo del beneficiario
          if prestaciones.size == 0
            prestacion_brindada.agregar_error(
              "La prestación no está habilitada para el sexo del beneficiario (#{Sexo.find(prestacion_brindada.sexo_id).nombre.downcase})"
            )
            prestacion_brindada.aceptada = false
            prestacion_brindada.save
            next
          end

          # Verificar si el código de prestación coincide con alguno de los requeridos para retroactivas
          prestaciones.keep_if do |p|
            [493, 494, 521, 538, 546, 548, 551, 553, 541, 554, 556,
             549, 547, 539, 552, 542, 555, 557, 523, 522, 524, 525,
             528, 529, 527, 526, 530, 531, 587, 560, 562, 561, 583,
             582, 267, 534, 533, 532].member? p.id
          end

          # Registrar el error y continuar con la próxima línea si ninguna de las prestaciones estaba habilitada para el sexo del beneficiario
          if prestaciones.size == 0
            prestacion_brindada.agregar_error("La prestación no está habilitada para facturarse como retroactiva")
            prestacion_brindada.aceptada = false
            prestacion_brindada.save
            next
          end

          # Para cada una de las prestaciones que aún quedan seleccionadas, creamos una nueva prestacion_brindada y seleccionamos la que
          # sea válida y genere menos advertencias
          mejor_prestacion = nil
          cantidad_de_metodos_fallados = 100
          prestaciones.each do |p|
            pb = PrestacionBrindada.new({
              :estado_de_la_prestacion_id => 3,
              :clave_de_beneficiario => prestacion_brindada.clave_de_beneficiario,
              :historia_clinica => prestacion_brindada.historia_clinica,
              :fecha_de_la_prestacion => prestacion_brindada.fecha_de_la_prestacion,
              :efector_id => prestacion_brindada.efector_id,
              :prestacion_id => p.id,
              :es_catastrofica => p.es_catastrofica,
              :diagnostico_id => diagnostico.id
            })

            if pb.valid?
              pb.actualizar_metodos_de_validacion_fallados
              if pb.metodos_de_validacion.size < cantidad_de_metodos_fallados
                mejor_prestacion = pb
                cantidad_de_metodos_fallados = pb.metodos_de_validacion.size
              end
            end
          end

          # Si encontramos la mejor posibilidad para individualizar la prestación, usamos esa, sino usamos la primera para generar los
          # mensajes de error, ya que quiere decir que ninguna era válida.
          if mejor_prestacion.present?
            pb = mejor_prestacion
          else
            pb = PrestacionBrindada.new({
              :estado_de_la_prestacion_id => 3,
              :clave_de_beneficiario => prestacion_brindada.clave_de_beneficiario,
              :historia_clinica => prestacion_brindada.historia_clinica,
              :fecha_de_la_prestacion => prestacion_brindada.fecha_de_la_prestacion,
              :efector_id => prestacion_brindada.efector_id,
              :prestacion_id => prestaciones.first.id,
              :es_catastrofica => prestaciones.first.es_catastrofica,
              :diagnostico_id => diagnostico.id
            })
          end

          if pb.valid?
            prestacion_brindada.attributes = {
              :prestacion_id => pb.prestacion_id,
              :diagnostico_id => pb.diagnostico_id,
              :monto => Prestacion.find(pb.prestacion_id).asignaciones_de_precios.where(:nomenclador_id => 5, :area_de_prestacion_id => 1).first.precio_por_unidad
            }
            if pb.metodos_de_validacion.size > 0
              pb.metodos_de_validacion.each do |mv|
                prestacion_brindada.agregar_error(mv.mensaje)
              end
            end
          else
            prestacion_brindada.agregar_error(pb.errors.full_messages.join(" - "))
          end

          # Verificar el estado de actividad del beneficiario
          if !beneficiario.activo?(prestacion_brindada.fecha_de_la_prestacion)
            prestacion_brindada.agregar_error(
              "El beneficiario no estaba activo a la fecha de la prestación"
            )
          end

          # Rechazar la prestación si se produjo algún error
          if !prestacion_brindada.errores.blank?
            prestacion_brindada.aceptada = false
          else
            prestacion_brindada.aceptada = true
          end

          # Guardar la prestación y continuar con la próxima línea
          prestacion_brindada.save
        end
      end

      archivo.close
    end
  end

  def parsear_linea(linea)
    return nil unless linea

    campos = linea.gsub(/[\r\n]/, "").split("\t")

    return {
      cuie_administrador_informado: a_texto(campos[0]),
      cuie_efector_informado: a_texto(campos[1]),
      alias_efector: a_texto(campos[2]),
      fecha_de_la_prestacion_informado: a_texto(campos[3]),
      nombre_informado: a_texto(campos[4]),
      numero_de_documento_informado: a_numero_de_documento(campos[5]),
      fecha_de_nacimiento_informado: a_texto(campos[6]),
      historia_clinica: a_texto(campos[7]),
      tipo_de_prestacion_informado: a_texto(campos[8]),
      objeto_de_prestacion_informado: a_texto(campos[9]),
      diagnostico_informado: a_texto(campos[10]),
      grupo_informado: a_texto(campos[11]),
      codigo_prestacion_informado: a_texto(campos[12]),
      administrador_id: hash_a_id(@hash_efectores, a_texto(campos[0])),
      efector_id: @hash_efectores[a_texto(campos[1])][:id],
      fecha_de_la_prestacion: a_fecha(campos[3]),
      grupo_poblacional_informado_id: a_grupo_poblacional_id(a_texto(campos[11]))
    }
  end

  def a_texto(cadena)
    texto = cadena.to_s.strip.gsub(/  /, " ").gsub("NULL", "").mb_chars.upcase.to_s
    return (texto.blank? ? nil : texto)
  end

  def a_codigo_de_prestacion(cadena)
    texto = cadena.to_s.strip.gsub(/[ -\.,]/, "").gsub("NULL", "").upcase
    return (texto.blank? ? nil : texto)
  end

  def a_numero_de_documento(cadena)
    texto = cadena.to_s.strip.gsub(/[ ,\.-]/, "").upcase
    return (texto.blank? ? nil : texto)
  end

  def a_entero(cadena)
    texto = cadena.to_s.strip.gsub(/[ ,\.-]/, "")
    return (texto.blank? ? nil : texto.to_i)
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
        begin
          dia, mes, anio = texto.split(".")
          fecha = Date.new(anio.to_i, mes.to_i, dia.to_i)
        rescue
          fecha = nil
        end
      end
    end
    return (fecha && fecha < Date.new(1900, 1, 1) ? nil : fecha)
  end

  def a_grupo_poblacional_id(cadena)
    return 1 if cadena == "0-5"
    return 2 if cadena == "6-9"
    return 3 if cadena == "10-19"
    return 4 if cadena == "20-64"
  end

  def hash_a_id(hash, cadena)
    texto = cadena.to_s.strip.gsub("NULL", "").upcase
    return nil if texto.blank?
    return texto.to_i if (texto.to_i > 0 && hash.values.member?(texto.to_i))
    return hash[texto] if hash[texto].present?
    raise ActiveRecord::RecordNotFound
  end

  def clase_a_id(nombre_de_clase, cadena)
    texto = cadena.to_s.strip.gsub("NULL", "").upcase
    return nil if texto.blank?
    return texto.to_i if (texto.to_i > 0 && eval(nombre_de_clase).exists?(texto.to_i))
    instancia = eval(nombre_de_clase).find_by_codigo(texto)
    return instancia.present? ? instancia.id : nil
  end

  def a_distrito_id(departamento_id, cadena)
    return nil unless departamento_id.present?
#    texto = cadena.to_s.strip.gsub("NULL", "").mb_chars.upcase.to_s
#    mejor_p = 0.0
#    mejor_solucion = nil
#    @hash_distritos[departamento_id].each do |nombre,id|
#      p = 1.0
#      solucion = id
#      texto.split(" ").each do |token|
#        p *= nombre.mb_chars.upcase.to_s.split(" ").collect{ |t| (1.0-(token.length > t.length ? (token.length - Text::Levenshtein.distance(token, t)).to_f/token.length.to_f : (t.length - Text::Levenshtein.distance(token, t)).to_f/t.length.to_f)) }.min
#      end
#      if p > mejor_p
#        mejor_solucion = solucion
#      end
#    end
    if cadena.blank?
      cadena = "IGNORADO"
    end

    return hash_distritos[departamento_id].values[hash_distritos[departamento_id].keys.collect{|n| n.mb_chars.upcase.to_s}.index(cadena) || 1000]

  end

end
