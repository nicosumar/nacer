# -*- encoding : utf-8 -*-
class RegistroMasivoDePrestaciones
  attr_accessor :uad_origen
  attr_accessor :nombre_de_archivo
  attr_accessor :hash_de_proceso
  attr_accessor :hash_clases
  attr_accessor :hash_tipos
  attr_accessor :hash_sexos
  attr_accessor :hash_efectores
  attr_accessor :prestaciones_por_sexo
  attr_accessor :prestaciones_por_grupo
  attr_accessor :prestaciones_por_efector
  attr_accessor :lineas_totales
  attr_accessor :errores_de_formato

  PATRONES_DE_VALIDACION = [
    /[[:alpha:]][0-9]{5}/,
    /20[0-9][0-9]-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])|(0?[1-9]|[1-2][0-9]|3[0-1])\/(0?[1-9]|1[0-2])\/(20)?[0-9][0-9]/, # Admite fechas hasta el año 2099
    /09[0-9]{14}|^$/,
    /[[:word:]]+/,
    /[[:word:]]+/,
    Regexp.new(ClaseDeDocumento.all.collect{|c| c.id.to_s + "|" + c.codigo.to_s}.join("|"), :ignore_case),
    Regexp.new(TipoDeDocumento.all.collect{|c| c.id.to_s + "|" + c.codigo.to_s}.join("|"), :ignore_case),
    /[[:word:]]+/,
    /[[:word:]]+/,
    /[[:alpha:]]{2}[[:blank:]]*[[:alpha:]][0-9]{3}[[:blank:]]*([0-9]{3}|[[:alpha:]][0-9]{2}(\.[0-9])?)/,
    /[1-9][0-9]*|^$/,
    /[[:word:]]*/,
    /[1-9][0-9]*|^$/,
    /[[:word:]]*/,
    /[1-9][0-9]*|^$/,
    /[[:word:]]*/,
    /[1-9][0-9]*|^$/,
    /[[:word:]]*/
  ]

  ATRIBUTOS = [
    "Efector",
    "Fecha de la prestación",
    "Clave de beneficiario",
    "Apellido",
    "Nombre",
    "Clase de documento",
    "Tipo de documento",
    "Número de documento",
    "Historia clínica",
    "Código de prestación",
    "Dato reportable 1 (ID)",
    "Dato reportable 1 (valor)",
    "Dato reportable 2 (ID)",
    "Dato reportable 2 (valor)",
    "Dato reportable 3 (ID)",
    "Dato reportable 3 (valor)",
    "Dato reportable 4 (ID)",
    "Dato reportable 4 (valor)"
  ]

  # Inicialización
  def initialize(uad, nombre)
    raise ArgumentError unless uad.present? && uad.is_a?(UnidadDeAltaDeDatos)
    raise ArgumentError unless nombre.present? && File.exist?(nombre)

    @uad_origen = uad
    @nombre_de_archivo = nombre
    @hash_clases = {}
    @hash_tipos = {}
    @hash_sexos = {}
    @hash_efectores = {}
    @lineas_totales = 0
    @errores_de_formato = nil

    ClaseDeDocumento.all.each do |i|
      hash_clases.merge! i.codigo => i.id
    end
    TipoDeDocumento.all.each do |i|
      hash_tipos.merge! i.codigo => i.id
    endFormulario de modificación de autorizaciones del usuario
    Sexo.all.each do |i|
      hash_sexos.merge! i.codigo => i.id
    end
    Efector.where(:integrante => true).includes(:unidad_de_alta_de_datos).each do |e|
      uad = e.unidad_de_alta_de_datos
      hash_efectores.merge!(
        e.cuie => {
          :id => e.id,
          :nombre => e.nombre,
          :uad => (uad.present? ? {:id => uad.id, :codigo => uad.codigo, :facturacion => uad.facturacion} : nil)
        }
      )
    end
  end

  # Realiza una validación rápida para verificar cuáles líneas del archivo tienen un formato válido
  # y cuáles no. Guarda los mensajes de error, si hubiera, en 'errores_de_formato'
  def validar_formato_de_archivo
    archivo = File.open(nombre_de_archivo, "r")
    self.errores_de_formato = {}
    self.lineas_totales = 0

    archivo.each_with_index do |l, i|
      self.lineas_totales += 1
      if !linea_valida?(l)
        self.errores_de_formato[i+1] = mensajes_de_error_linea(l)
      end
    end
    archivo.close
  end

  # Indica si todas las líneas del archivo tenían un formato válido
  def archivo_valido?
    validar_formato_de_archivo if errores_de_formato.nil?
    return errores_de_formato.size == 0
  end

  # Devuelve un Array con los números de línea que tienen errores de formato
  def lineas_con_errores
    validar_formato_de_archivo if errores_de_formato.nil?
    return errores_de_formato.keys
  end

  # Cambia el esquema actual de la base de datos por el asociado a la UAD con el codigo pasado
  def establecer_esquema_a_codigo_de_uad(codigo)
    ActiveRecord::Base.connection.schema_search_path = "uad_" + codigo + ", public"
  end

  # Procesa el archivo indicado como argumento
  def procesar
    nombre_de_archivo = archivo
    archivo = File.open(self.nombre_de_archivo, "r")
    hash_de_proceso = self.archivo.hash.to_s
    archivo.close

    crear_modelo_y_tabla(hash_de_proceso)
    procesar_archivo
    archivo.close

    persistir_prestaciones
    escribir_resultados
    eliminar_tabla
  end

  # Elimina la tabla temporal
  def eliminar_tabla
    ActiveRecord::Base.connection.execute "
      DROP TABLE IF EXISTS importar_prestaciones_brindadas_#{hash_de_proceso.to_s} CASCADE;
    "
  end

  # Escribe los resultados de un proceso de importación de datos
  def escribir_resultados
    archivo = File.open(@nombre_de_archivo.match(/(.*)(\..*)/)[1] + " procesado (#{DateTime.now.strftime("%Y%M%d%H%M%S")}).csv", "w")
    archivo.puts eval("ImportarPrestacionBrindada" + hash_de_proceso).column_names.join("\t")
    eval("ImportarPrestacionBrindada" + hash_de_proceso).find(:all).each do |n|
      archivo.puts n.attributes.values.join("\t")
    end
    archivo.close
  end

  # Crea el modelo y la tabla asociados a un proceso de importación masivo de datos de prestaciones
  def crear_modelo_y_tabla(hash_de_proceso)
    ActiveRecord::Base.connection.execute "
      CREATE TABLE importar_prestaciones_brindadas_#{hash_de_proceso.to_s} (
        linea integer PRIMARY KEY,
        efector_informado varchar(255),
        fecha_de_la_prestacion_informada varchar(255),
        clave_de_beneficiario_informado varchar(255),
        apellido_informado varchar(255),
        nombre_informado varchar(255),
        clase_de_documento_informado varchar(255),
        tipo_de_documento_informado varchar(255),
        numero_de_documento_informado varchar(255),
        historia_clinica_informada varchar(255),
        codigo_de_prestacion_informado varchar(255),
        id_dato_reportable_1_informado integer,
        valor_dato_reportable_1_informado varchar(255),
        id_dato_reportable_2_informado integer,
        valor_dato_reportable_2_informado varchar(255),
        id_dato_reportable_3_informado integer,
        valor_dato_reportable_3_informado varchar(255),
        id_dato_reportable_4_informado integer,
        valor_dato_reportable_4_informado varchar(255),
        formato_valido boolean,
        efector_id integer,
        efector varchar(255),
        fecha_de_la_prestacion date,
        clave_de_beneficiario varchar(255),
        apellido varchar(255),
        nombre varchar(255),
        clase_de_documento_id integer,
        clase_de_documento varchar(255),
        tipo_de_documento_id integer,
        tipo_de_documento varchar(255),
        numero_de_documento varchar(255),
        sexo varchar(255),
        fecha_de_nacimiento date,
        prestacion_id integer,
        prestacion varchar(255),
        diagnostico_id integer,
        diagnostico varchar(255),
        dato_reportable_1_id integer,
        dato_reportable_1 varchar(255),
        dato_reportable_1_valor varchar(255),
        dato_reportable_2_id integer,
        dato_reportable_2 varchar(255),
        dato_reportable_2_valor varchar(255),
        dato_reportable_3_id integer,
        dato_reportable_3 varchar(255),
        dato_reportable_3_valor varchar(255),
        dato_reportable_4_id integer,
        dato_reportable_4 varchar(255),
        dato_reportable_4_valor varchar(255),
        persistido boolean,
        errores text
      );
    "

    if !Class::constants.member?("ImportarPrestacionBrindada#{self.hash_de_proceso}")
      Object.const_set("ImportarPrestacionBrindada#{self.hash_de_proceso}", Class.new(ActiveRecord::Base) {
        set_table_name "importar_prestaciones_brindadas_#{self.hash_de_proceso}"
        set_primary_key :id

        attr_accessible :linea, :efector_informado, :fecha_de_la_prestacion_informada, :clave_de_beneficiario_informado
        attr_accessible :apellido_informado, :nombre_informado, :clase_de_documento_informado, :tipo_de_documento_informado
        attr_accessible :numero_de_documento_informado, :historia_clinica_informada, :codigo_de_prestacion_informado
        attr_accessible :id_dato_reportable_1_informado, :valor_dato_reportable_1_informado
        attr_accessible :id_dato_reportable_2_informado, :valor_dato_reportable_2_informado
        attr_accessible :id_dato_reportable_3_informado, :valor_dato_reportable_3_informado
        attr_accessible :id_dato_reportable_4_informado, :valor_dato_reportable_4_informado
        attr_accessible :formato_valido, :esquema, :efector_id, :efector, :fecha_de_la_prestacion, :clave_de_beneficiario
        attr_accessible :apellido, :nombre, :clase_de_documento_id, :clase_de_documento, :tipo_de_documento_id
        attr_accessible :tipo_de_documento, :numero_de_documento, :sexo_id, :sexo, :fecha_de_nacimiento, :prestacion_id
        attr_accessible :prestacion, :diagnostico_id, :diagnostico
        attr_accessible :dato_reportable_1_id, :dato_reportable_1, :dato_reportable_1_valor
        attr_accessible :dato_reportable_2_id, :dato_reportable_2, :dato_reportable_2_valor
        attr_accessible :dato_reportable_3_id, :dato_reportable_3, :dato_reportable_3_valor
        attr_accessible :dato_reportable_4_id, :dato_reportable_4, :dato_reportable_4_valor
        attr_accessible :persistido, :errores

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
    raise ArgumentError unless nombre_de_archivo.present?

    establecer_esquema_a_codigo_de_uad(uad_origen.codigo)

#    ActiveRecord::Base.logger.silence do
#      archivo.first if tiene_etiquetas_de_columnas
      archivo.each_with_index do |linea, i|
        prestacion_brindada = eval("ImportarPrestacionBrindada" + self.hash_de_proceso).new(parsear_linea(linea).merge!(:id => i + 1))

        # Registrar el error si la fecha de la prestación no tiene un formato reconocible
        if !prestacion_brindada.fecha_de_la_prestacion.present?
          prestacion_brindada.agregar_error(
            "La fecha de la prestación no se pudo reconocer (cadena evaluada: '#{prestacion_brindada.fecha_de_la_prestacion}')"
          )
        end

        # Evaluamos los datos reportables informados
        if prestacion_brindada.id_dato_reportable_1.present?
          dato_reportable = DatoReportable.find(prestacion_brindada.id_dato_reportable_1)
          if !dato_reportable.present?
            prestacion_brindada.agregar_error(
              "Advertencia: el identificador del primer dato reportable no existe " + \
              "('#{prestacion_brindada.id_dato_reportable_1}'), se ignorará el valor asociado"
            )
          else
            if prestacion_brindada.dato_reportable_1.blank?
              prestacion_brindada.agregar_error(
                "Advertencia: no se asignó el valor del primer dato reportable"
              )
            else
              prestacion_brindada.dato_reportable_1_id = prestacion_brindada.id_dato_reportable_1
              prestacion_brindada.dato_reportable_1_valor = prestacion_brindada.dato_reportable_1
            end
          end
        end

        if prestacion_brindada.id_dato_reportable_2.present?
          dato_reportable = DatoReportable.find(prestacion_brindada.id_dato_reportable_2)
          if !dato_reportable.present?
            prestacion_brindada.agregar_error(
              "Advertencia: el identificador del segundo dato reportable no existe " + \
              "('#{prestacion_brindada.id_dato_reportable_2}'), se ignorará el valor asociado"
            )
          else
            if prestacion_brindada.dato_reportable_2.blank?
              prestacion_brindada.agregar_error(
                "Advertencia: no se asignó el valor del segundo dato reportable"
              )
            else
              prestacion_brindada.dato_reportable_2_id = prestacion_brindada.id_dato_reportable_2
              prestacion_brindada.dato_reportable_2_valor = prestacion_brindada.dato_reportable_2
            end
          end
        end

        if prestacion_brindada.id_dato_reportable_3.present?
          dato_reportable = DatoReportable.find(prestacion_brindada.id_dato_reportable_3)
          if !dato_reportable.present?
            prestacion_brindada.agregar_error(
              "Advertencia: el identificador del tercer dato reportable no existe " + \
              "('#{prestacion_brindada.id_dato_reportable_3}'), se ignorará el valor asociado"
            )
          else
            if prestacion_brindada.dato_reportable_3.blank?
              prestacion_brindada.agregar_error(
                "Advertencia: no se asignó el valor del tercer dato reportable"
              )
            else
              prestacion_brindada.dato_reportable_3_id = prestacion_brindada.id_dato_reportable_3
              prestacion_brindada.dato_reportable_3_valor = prestacion_brindada.dato_reportable_3
            end
          end
        end

        if prestacion_brindada.id_dato_reportable_4.present?
          dato_reportable = DatoReportable.find(prestacion_brindada.id_dato_reportable_4)
          if !dato_reportable.present?
            prestacion_brindada.agregar_error(
              "Advertencia: el identificador del cuarto dato reportable no existe " + \
              "('#{prestacion_brindada.id_dato_reportable_4}'), se ignorará el valor asociado"
            )
          else
            if prestacion_brindada.dato_reportable_4.blank?
              prestacion_brindada.agregar_error(
                "Advertencia: no se asignó el valor del cuarto dato reportable"
              )
            else
              prestacion_brindada.dato_reportable_4_id = prestacion_brindada.id_dato_reportable_4
              prestacion_brindada.dato_reportable_4_valor = prestacion_brindada.dato_reportable_4
            end
          end
        end

        # Intentar encontrar el beneficiario al que se le brindó la prestación
        if prestacion_brindada.clave_de_beneficiario.present?
          # Si se pasa una clave de beneficiario, solo intentamos encontrarlo por ese criterio
          beneficiarios = Afiliado.where(clave_de_beneficiario: clave_de_beneficiario(prestacion_brindada.clave_de_beneficiario))
          if beneficiarios.size == 0
            prestacion_brindada.agregar_error(
              "La clave de beneficiario '#{prestacion_brindada.clave_de_beneficiario}' no se encontró en el padrón"
            )
          end
        else
          # Si no se pasó una clave, buscamos por clase, tipo y número de documento
          beneficiarios =
            Afiliado.busqueda_por_documento(
              prestacion_brindada.numero_de_documento_informado,
              ClaseDeDocumento.find(hash_a_id(@hash_clases, prestacion_brindada.clase_de_documento_informado)),
              #prestacion_brindada.tipo_de_documento ? TipoDeDocumento.find(prestacion_brindada.tipo_de_documento) : nil
              nil
            )
          if beneficiarios.size == 0
            prestacion_brindada.agregar_error(
              "No se encontró al beneficiario " + \
              "'#{prestacion_brindada.apellido_informado}, #{prestacion_brindada.nombre_informado}'" + \
              ", con la clase, tipo y número de documento indicados (clase: #{prestacion_brindada.clase_de_documento_informado}, " + \
              "tipo: #{prestacion_brindada.tipo_de_documento_informado}, " + \
              "número: #{prestacion_brindada.numero_de_documento_informado}) en el padrón"
            )
          end
        end

        # Obtener la prestación y el diagnóstico asociados con el código informado, o indicar el error si no se informó el código
        prestaciones = []
        if !prestacion_brindada.codigo_de_prestacion_informado.present?
          prestacion_brindada.agregar_error(
            "No se informó el código de prestación"
          )
        else
          codigo_de_prestacion = prestacion_brindada.codigo_de_prestacion_informado[0..5]
          prestacion = Prestacion.find_by_codigo(codigo_de_prestacion)
          if !prestacion.present?
            prestacion_brindada.agregar_error(
              "El código de prestación no existe (cadena evaluada: '#{codigo_prestacion}')"
            )
          end
          codigo_de_diagnostico = prestacion_brindada.codigo_de_prestacion_informado[6..-1]
          diagnostico = Diagnostico.find_by_codigo(codigo_de_diagnostico)
          if !diagnostico.present?
            prestacion_brindada.agregar_error(
              "El código de diagnóstico no existe (cadena evaluada: '#{codigo_diagnostico}')"
            )
          else
            prestacion_brindada.diagnostico_id = diagnostico.id
          end
          if prestacion.present? && diagnostico.present?
            # Obtener todas las prestaciones que tengan el código informado y admitan el diagnóstico informado
            prestaciones = Prestacion.where(
              "codigo = ?
                AND EXISTS (
                  SELECT *
                    FROM diagnosticos_prestaciones
                    WHERE
                      diagnosticos_prestaciones.prestacion_id = prestaciones.id
                      AND diagnosticos_prestaciones.diagnostico_id = ?
                )",
                codigo_de_prestacion, diagnostico.id
              )

            # Registrar el error si no se encuentra una prestación para esa combinación de código y diagnóstico
            if prestaciones.size == 0
              prestacion_brindada.agregar_error(
                "No se encontró una prestación con código '#{codigo_de_prestacion}' y diagnóstico '#{diagnostico.nombre} (#{codigo_de_diagnostico})'"
              )
            end
          end
        end

        # Inicializamos la variable que va a contener las distintas soluciones posibles, junto con su puntuación en forma ordenada
        soluciones = []

        # Construimos todas las soluciones combinando los beneficiarios y prestaciones posibles, y asignamos una puntuación
        # a cada solución
        if beneficiarios.size > 0 && prestaciones.size > 0 && prestacion_brindada.fecha_de_la_prestacion.present?

          # Iteramos todos los posibles registros de beneficiarios
          beneficiarios.each do |beneficiario|

            # Inicializamos la variable que nos da la puntuación para este beneficiario
            punt_benef = 0

            # Creamos otro objeto para guardar la info de la prestación brindada con los datos del beneficiario
            pb_benef = prestacion_brindada.dup
            pb_benef.attributes = {
              :clave_de_beneficiario => beneficiario.clave_de_beneficiario,
              :apellido => beneficiario.apellido,
              :nombre => beneficiario.nombre,
              :clase_de_documento => beneficiario.clase_de_documento.present? ? beneficiario.clase_de_documento.nombre : nil,
              :tipo_de_documento => beneficiario.clase_de_documento.present? ? beneficiario.tipo_de_documento.nombre : nil,
              :numero_de_documento => beneficiario.numero_de_documento,
              :sexo => beneficiario.sexo.present? ? beneficiario.sexo.nombre : nil,
              :fecha_de_nacimiento => beneficiario.fecha_de_nacimiento
            }

            # Registrar el error si tiene datos imprescindibles incompletos
            # TODO: cambiar esto por verificaciones del motivo de baja
            if !(beneficiario.sexo.present? && beneficiario.fecha_de_nacimiento.present?)
              pb_benef.agregar_error(
                "No se puede evaluar la prestación porque al registro del beneficiario le faltan datos imprescindibles (sexo o fecha de nacimiento)"
              )
            else
              # Obtener el grupo poblacional al que pertenecía el beneficiario para la fecha de la prestación
              grupo_poblacional = beneficiario.grupo_poblacional_al_dia(pb_benef.fecha_de_la_prestacion)
              if !grupo_poblacional.present?
                pb_benef.agregar_error(
                  "El beneficiario no integra la población objetivo del Programa Sumar (sexo: " + \
                  "'#{beneficiario.sexo.nombre}', edad: '#{beneficiario.edad_en_anios(prestacion_brindada.fecha_de_la_prestacion)} años')"
                )
              else
                # Añadimos un punto al beneficiario si tiene datos completos y pertenece a los grupos poblacionales del Programa
                punt_benef += 1
              end

              # Añadimos tres puntos si se registró la prestación con documento ajeno y este beneficiario tenía menos de un año
              # a la fecha de la prestación.
              if (
                hash_a_id(@hash_clases, prestacion_brindada.clase_de_documento_informado) == ClaseDeDocumento.id_del_codigo!("A") &&
                (beneficiario.fecha_de_nacimiento + 1.year) >= pb_benef.fecha_de_la_prestacion
              )
                punt_benef += 3
              end

            end

            # Añadir un punto si el beneficiario está activo
            punt_benef += 1 if beneficiario.activo?(pb_benef.fecha_de_la_prestacion)


            # Iteramos todos los posibles registros de prestaciones
            prestaciones.each do |prestacion|

              # Inicializamos la variable que nos da la puntuación para esta combinación de beneficiario y prestación
              punt_benef_prest = punt_benef

              # Volvemos a duplicar el objeto para evaluar la combinación de este beneficiario con esta prestación
              pb_benef_prest = pb_benef.dup
              pb_benef_prest.attributes = {
                :prestacion_id => prestacion.id,
                :diagnostico_id => diagnostico.id,
              }

              # Verificar si la prestación está habilitada para el sexo del beneficiario
              if beneficiario.sexo_id.present? && !(beneficiario.sexo.prestaciones_autorizadas.collect{|p| p.id}.member?(prestacion.id))
                pb_benef_prest.agregar_error(
                  "La prestación no está habilitada para el sexo del beneficiario (#{beneficiario.sexo.nombre.downcase})"
                )
              else
                punt_benef_prest += 1
              end

              # Verificar si la prestación está habilitada para el grupo poblacional del beneficiario
              if grupo_poblacional.present? && !(grupo_poblacional.prestaciones_autorizadas.collect{|p| p.id}.member?(prestacion.id))
                pb_benef_prest.agregar_error(
                  "La prestación no está habilitada para el grupo poblacional del beneficiario (#{grupo_poblacional.nombre.downcase})"
                )
              else
                punt_benef_prest += 1
              end

              # Verificar si la prestación está habilitada para este efector
              if !(@efector.prestaciones_autorizadas_al_dia(pb_benef_prest.fecha_de_la_prestacion).collect{|p| p.prestacion_id}.member?(prestacion.id))
                pb_benef_prest.agregar_error(
                  "La prestación no está habilitada para el efector a la fecha de la prestación"
                )
              else
                punt_benef_prest += 1
              end

              # Si la prestación está habilitada, creamos un objeto PrestacionBrindada asignando la combinación actual de
              # beneficiario y prestación para poder evaluar esta solución
              if (
                beneficiario.sexo_id.present? &&
                grupo_poblacional.present? &&
                (@efector.prestaciones_autorizadas_al_dia(pb_benef_prest.fecha_de_la_prestacion).collect{|p| p.prestacion_id}.member?(prestacion.id)) &&
                (beneficiario.sexo.prestaciones_autorizadas.collect{|p| p.id}.member?(prestacion.id)) &&
                (grupo_poblacional.prestaciones_autorizadas.collect{|p| p.id}.member?(prestacion.id))
              )
                pb = PrestacionBrindada.new({
                  :estado_de_la_prestacion_id => 3,
                  :clave_de_beneficiario => pb_benef_prest.clave_de_beneficiario,
                  :historia_clinica => pb_benef_prest.historia_clinica,
                  :fecha_de_la_prestacion => pb_benef_prest.fecha_de_la_prestacion,
                  :efector_id => @efector.id,
                  :prestacion_id => prestacion.id,
                  :es_catastrofica => prestacion.es_catastrofica,
                  :diagnostico_id => diagnostico.id
                })
                dras = []
                pb.prestacion.datos_reportables_requeridos.each do |drr|
                  if drr.dato_reportable_id == pb_benef_prest.dato_reportable_1_id
                    dra_valor = pb_benef_prest.dato_reportable_1_valor
                  elsif drr.dato_reportable_id == pb_benef_prest.dato_reportable_2_id
                    dra_valor = pb_benef_prest.dato_reportable_2_valor
                  elsif drr.dato_reportable_id == pb_benef_prest.dato_reportable_3_id
                    dra_valor = pb_benef_prest.dato_reportable_3_valor
                  elsif drr.dato_reportable_id == pb_benef_prest.dato_reportable_4_id
                    dra_valor = pb_benef_prest.dato_reportable_4_valor
                  else
                    dra_valor = nil
                  end
                  if dra_valor.present?
                    dra = DatoReportableAsociado.new({:dato_reportable_requerido_id => drr.id})
                    case drr.dato_reportable.tipo_ruby
                      when "string"
                        dra.valor_string = dra_valor
                      when "date"
                        dra.valor_date = a_fecha(dra_valor)
                      when "big_decimal"
                        dra.valor_big_decimal = dra_valor.to_f
                      when "integer"
                        if drr.dato_reportable.enumerable
                          dra.valor_integer = clase_a_id(drr.dato_reportable.clase_para_enumeracion, dra_valor)
                        else
                          dra.valor_integer = dra_valor.to_i
                        end
                    end
                    dras << dra
                  end
                end
                pb.datos_reportables_asociados = dras

                # Verificamos si la prestación brindada sería válida y añadimos puntos en forma acorde
                if pb.valid?
                  punt_benef_prest += 1
                  pb.actualizar_metodos_de_validacion_fallados
                  if pb.metodos_de_validacion.size == 0
                    punt_benef_prest += 1
                  end
                else
                  pb_benef_prest.agregar_error(pb.errors.full_messages.join(" - "))
                end
              end

              # Guardar esta solución entre las posibles, ubicándola en forma ordenada de acuerdo con el puntaje
              esta_solucion = [pb_benef_prest, punt_benef_prest]

              posicion = 0
              soluciones.each_with_index do |solucion, i|
                if solucion[1] < punt_benef_prest
                  posicion = i
                  break
                else
                  posicion = i+1
                end
              end

              soluciones.insert(posicion, esta_solucion)
            end
          end

          # Ahora diferenciamos dos casos, según la prestación se haya registrado con documento ajeno o con documento propio
          if hash_a_id(@hash_clases, prestacion_brindada.clase_de_documento_informado) == ClaseDeDocumento.id_del_codigo!("A")
            # Cuando se ha registrado con documento ajeno, solo mantenemos las soluciones que tienen la mayor puntuación
            mayor_puntuacion = soluciones[0][1]
            soluciones.keep_if{|s| s[1] == mayor_puntuacion}

            if soluciones.size > 1
              # Si quedó más de una solución con la puntuación más alta, intentar seleccionar la que tenga el nombre más
              # parecido
              mejor_solucion = nil
              mejor_nivel = 0
              soluciones.each do |solucion|
                pb = solucion[0]
                nivel = nivel_de_similitud(pb.apellido_informado, pb.nombre_informado, pb.apellido, pb.nombre)
                if nivel > mejor_nivel
                  mejor_solucion = pb
                  mejor_nivel = nivel
                end
              end
              prestacion_brindada = mejor_solucion
            else
              # Si quedó una única solución posible, esa es la nuestra
              prestacion_brindada = soluciones.first[0]
            end
          else
            # Cuando se ha registrado la prestación con un número de documento propio, seleccionamos la solución de mejor
            # puntuación cuyo nivel de similitud en los nombres supere cierto valor umbral, para no asignar la prestación
            # a un beneficiario incorrecto cuando se la ha registrado con un DNI incorrecto.
            prestacion_seleccionada = nil
            soluciones.each do |solucion|
              pb = solucion[0]
              nivel = self.nivel_de_similitud(pb.apellido_informado, pb.nombre_informado, pb.apellido, pb.nombre)
              if nivel >= 6 # valor de umbral
                # Consideramos que encontramos un buen candidato
                prestacion_seleccionada = pb
                break
              end
            end

            # Seleccionar la mejor solución, o registrar el error si no coincidieron los nombres en ninguna de las soluciones
            if prestacion_seleccionada.present?
              prestacion_brindada = prestacion_seleccionada
            else
              prestacion_brindada = soluciones.first[0]
              prestacion_brindada.agregar_error(
                "El nombre del beneficiario no coincide (informado: '#{prestacion_brindada.apellido_informado}, " + \
                "#{prestacion_brindada.nombre_informado}', registrado en el padrón: '" + \
                "#{prestacion_brindada.apellido}, #{prestacion_brindada.nombre}')."
              )
            end
          end
        end

        # En este punto tenemos individualizada la prestación que se quiere registrar. Puede persistirse si no tiene errores
        # registrados.
        if prestacion_brindada.errores.blank?
          # Todo bien, la prestación se guarda y podrá persistirse como PrestacionBrindada
          prestacion_brindada.persistido = true
        else
          # La prestación que quedó seleccionada tiene errores por los que no se puede persistir
          prestacion_brindada.persistido = false
        end

        # Guardar la prestación y continuar con la próxima línea
        prestacion_brindada.save
      end
#    end # ActiveRecord::Base.logger.silence
  end

  def persistir_prestaciones
    eval("ImportarPrestacionBrindada" + self.hash_de_proceso).where(:persistido => true).each do |pb|
      prestacion_brindada = PrestacionBrindada.new({
        :clave_de_beneficiario => pb.clave_de_beneficiario,
        :historia_clinica => pb.historia_clinica,
        :fecha_de_la_prestacion => pb.fecha_de_la_prestacion,
        :efector_id => pb.efector_id,
        :prestacion_id => pb.prestacion_id,
        :diagnostico_id => pb.diagnostico_id
      })
      prestacion_brindada.es_catastrofica = prestacion_brindada.prestacion.es_catastrofica
      dras = []
      prestacion_brindada.prestacion.datos_reportables_requeridos.each do |drr|
        if drr.dato_reportable_id == pb.dato_reportable_1_id
          dra_valor = pb.dato_reportable_1_valor
        elsif drr.dato_reportable_id == pb.dato_reportable_2_id
          dra_valor = pb.dato_reportable_2_valor
        elsif drr.dato_reportable_id == pb.dato_reportable_3_id
          dra_valor = pb.dato_reportable_3_valor
        elsif drr.dato_reportable_id == pb.dato_reportable_4_id
          dra_valor = pb.dato_reportable_4_valor
        else
          dra_valor = nil
        end
        if dra_valor.present?
          dra = DatoReportableAsociado.new({:dato_reportable_requerido_id => drr.id})
          case drr.dato_reportable.tipo_ruby
            when "string"
              dra.valor_string = dra_valor
            when "date"
              dra.valor_date = a_fecha(dra_valor)
            when "big_decimal"
              dra.valor_big_decimal = dra_valor.to_f
            when "integer"
              if drr.dato_reportable.enumerable
                dra.valor_integer = clase_a_id(drr.dato_reportable.clase_para_enumeracion, dra_valor)
              else
                dra.valor_integer = dra_valor.to_i
              end
          end
          dras << dra
        end
      end
      prestacion_brindada.datos_reportables_asociados = dras
      prestacion_brindada.actualizar_metodos_de_validacion_fallados

      if prestacion_brindada.metodos_de_validacion.size > 0
        prestacion_brindada.estado_de_la_prestacion_id = 2
      else
        prestacion_brindada.estado_de_la_prestacion_id = 3
      end

      prestacion_brindada.creator_id = 1
      prestacion_brindada.updater_id = 1
      prestacion_brindada.save
    end
  end

  def linea_valida?(linea)
    campos = linea.gsub(/[\r\n]/, "").split("\t").collect{|c| c.to_s.strip.gsub(/  /, " ").gsub("NULL", "").mb_chars.upcase.to_s}
    ATRIBUTOS.each_with_index do |a, i|
      return false unless campos[i].to_s.match(PATRONES_DE_VALIDACION[i])
    end
    return true
  end

  def mensajes_de_error_linea(linea)
    campos = linea.gsub(/[\r\n]/, "").split("\t").collect{|c| c.to_s.strip.gsub(/  /, " ").gsub("NULL", "").mb_chars.upcase.to_s}

    errores = []
    ATRIBUTOS.each_with_index do |a, i|
      if !campos[i].to_s.match(PATRONES_DE_VALIDACION[i])
        errores << "El formato del valor informado para el campo '#{a}' no es válido ('#{campos[i].to_s}')"
      end
    end
    return errores
  end

  def parsear_linea(linea)
    return nil unless linea.present?

    campos = linea.gsub(/[\r\n]/, "").split("\t")

    return {
      :efector_informado => a_texto(campos[0]),
      :fecha_de_la_prestacion_informada => a_fecha(campos[1]),
      :clave_de_beneficiario_informado => a_texto(campos[2]),
      :apellido_informado => a_texto(campos[3]),
      :nombre_informado => a_texto(campos[4]),
      :clase_de_documento_informado => a_texto(campos[5]),
      :clase_de_documento => hash_a_id(@hash_clases, a_texto(campos[5])),
      :tipo_de_documento_informado => a_texto(campos[6]),
      :tipo_de_documento => hash_a_id(@hash_tipos, a_texto(campos[6])),
      :numero_de_documento_informado => a_numero_de_documento(campos[7]),
      :historia_clinica => a_texto(campos[8]),
      :codigo_de_prestacion_informado => a_codigo_de_prestacion(campos[9]),
      :id_dato_reportable_1 => a_entero(campos[10]),
      :dato_reportable_1 => a_texto(campos[11]),
      :id_dato_reportable_2 => a_entero(campos[12]),
      :dato_reportable_2 => a_texto(campos[13]),
      :id_dato_reportable_3 => a_entero(campos[14]),
      :dato_reportable_3 => a_texto(campos[15]),
      :id_dato_reportable_4 => a_entero(campos[16]),
      :dato_reportable_4 => a_texto(campos[17]),
      :esquema => a_esquema(campos[0]),
      :efector_id => a_efector(campos[0]),
    }
  end

  def a_esquema(cadena)
    texto = cadena.to_s.strip.gsub(/[ -\.,]/, "").gsub("NULL", "").upcase
    efectores = Efector.find_by_cuie(texto)
    if efectores.size == 1 && efectores.first.unidad_de_alta_de_datos.present?
      return "uad_" + efectores.first.unidad_de_alta_de_datos.codigo
    end
    return nil
  end

  def a_efector_id(cadena)
    texto = cadena.to_s.strip.gsub(/[ -\.,]/, "").gsub("NULL", "").upcase
    efectores = Efector.find_by_cuie(texto)
    return (efectores.size == 1 ? efectores.first.id : nil)
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
    return cadena.to_s.strip.gsub(/[ ,\.-]/, "").upcase
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
        fecha = nil
      end
    end
    return fecha
  end

  def hash_a_id(hash, cadena)
    texto = cadena.to_s.strip.gsub("NULL", "").upcase
    return nil if texto.blank?
    return texto.to_i if (texto.to_i > 0 && hash.values.member?(texto.to_i))
    return hash[texto]
  end

  def clase_a_id(nombre_de_clase, cadena)
    texto = cadena.to_s.strip.gsub("NULL", "").upcase
    return nil if texto.blank?
    return texto.to_i if (texto.to_i > 0 && eval(nombre_de_clase).exists?(texto.to_i))
    instancia = eval(nombre_de_clase).find_by_codigo(texto)
    return instancia.present? ? instancia.id : nil
  end

  # Normaliza un nombre (o apellido) a mayúsculas, eliminando caracteres extraños y acentos
  def normalizar_nombre(nombre)
    return nil unless nombre
    normalizado = nombre.mb_chars.upcase.to_s
    normalizado.gsub!(/[\,\.\'\`\^\~\-\"\/\\\!\$\%\&\(\)\=\+\*\-\_\;\:\<\>\|\@\#\[\]\{\}]/, "")
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

  # Devuelve el nivel de similitud entre el nombre y apellido 1 y el 2
  def nivel_de_similitud(apellido1, nombre1, apellido2, nombre2)

    # Normalizamos todas las cadenas antes de la comparación
    apellido_1 = (self.normalizar_nombre(apellido1) || "")
    nombre_1 = (self.normalizar_nombre(nombre1) || "")
    apellido_2 = (self.normalizar_nombre(apellido2) || "")
    nombre_2 = (self.normalizar_nombre(nombre2) || "")

    # Verificar apellidos
    case
      when apellido_1.split(" ").any?{|a1| apellido_2.split(" ").any?{|a2| a1 == a2 }}
        # Coincide algún apellido
        nivel = 4
      else
        # No coincide ningún apellido, procedemos a verificar si algún apellido registrado tiene una distancia
        # de Levenshtein menor o igual que 3 con alguno de los informados
        if apellido_1.split(" ").any?{|a1| apellido_2.split(" ").any?{|a2| Text::Levenshtein.distance(a1, a2) <= 3 }}
          nivel = 2
        else
          nivel = 1
        end
    end

    # Verificar nombres
    case
      when nombre_1.split(" ").all?{|n1| nombre_2.split(" ").any?{|n2| n1 == n2 }}
        # Coinciden todos los nombres (sin importar el orden)
        nivel *= 7
      when nombre_1.split(" ").any?{|n1| nombre_2.split(" ").any?{|n2| n1 == n2 }}
        # Coinciden uno o más nombres, pero no todos
        nivel *= 5
      else
        # No coincide ningún nombre, procedemos a verificar si algún nombre registrado tiene una distancia de Levenshtein
        # menor o igual que 3 con el otro
        if nombre_1.split(" ").any?{|n1| nombre_2.split(" ").any?{|n2| Text::Levenshtein.distance(n1, n2) <= 3 }}
          nivel *= 3
        else
          nivel *= 1
        end
    end

    return nivel
  end
end
