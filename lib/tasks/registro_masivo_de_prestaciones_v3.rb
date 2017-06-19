# -*- encoding : utf-8 -*-
#require 'logger'
class RegistroMasivoDePrestacionesV3

  attr_accessor :archivo_completo
  attr_accessor :archivo_a_procesar
  attr_accessor :nombre_de_archivo_a_procesar
  attr_accessor :unidad_de_alta_de_datos
  attr_accessor :centro_de_inscripcion
  attr_accessor :efector
  attr_accessor :tiene_etiquetas_de_columnas
  attr_accessor :hash_clases
  attr_accessor :hash_tipos
  attr_accessor :prestaciones_por_sexo
  attr_accessor :prestaciones_por_grupo
  attr_accessor :prestaciones_por_efector

# load 'lib/tasks/procesar_archivo_prestaciones.rb'
# ins = InscripcionMasiva.new(UnidadDeAltaDeDatos.where(:codigo => "006").first, CentroDeInscripcion.where("nombre ILIKE '%notti%'").first, Efector.where("nombre ILIKE '%notti%'").first)
# ins.archivo_a_procesar = "/home/sbosio/Documentos/Plan Nacer/Operaciones/Inscripciones masivas/Inscripciones masivas Notti.csv"
# ins.tiene_etiquetas_de_columnas = true

  def initialize
    @archivo_completo = nil
    @archivo_a_procesar = nil
    @directory_name = nil
    @archivo_de_log_completo = nil
    @unidad_de_alta_de_datos = nil
    @centro_de_inscripcion = nil
    @efector = nil
    @tiene_etiquetas_de_columna = false
    @hash_clases = {}
    @hash_tipos = {}
    @hash_sexos = {}

    ClaseDeDocumento.find(:all).each do |i|
      @hash_clases.merge! i.codigo => i.id
    end
    TipoDeDocumento.find(:all).each do |i|
      @hash_tipos.merge! i.codigo => i.id
    end
    Sexo.find(:all).each do |i|
      @hash_sexos.merge! i.codigo => i.id
    end

    @log_del_proceso = Logger.new("log/RegistroMasivoPrestaciones",10, 1024000)
    @log_del_proceso.formatter = proc do |severity, datetime, progname, msg|
    date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
      if severity == "INFO" or severity == "WARN"
          "[#{date_format}] #{severity}: #{msg}\n"
      else
          "[#{date_format}] #{severity}: #{msg}\n"
      end
    end



   end

  def establecer_esquema(esquema = "public")
  end

  def procesar(archivo, uad, efe)
     procesar_parte(archivo, uad, efe)
  end

      def eliminar_procesados(archivos)
        archivos_resultados = archivos.clone

        for a in archivos_resultados

          if !Dir.glob(a+'.out').empty?
              archivos.delete(a)
          end
        end
        return archivos
      end

      def procesar_parte(filename, uad, efector)

        @unidad_de_alta_de_datos = uad

        @efector = efector
        @filename = filename
        @nombre_corto_archivo = filename.to_s.split("/").last.gsub(".","_")

        @log_del_proceso.info("*****************************************************")
        @log_del_proceso.info("####***Iniciando procesamiento de archivo de prestaciones***###")
        @log_del_proceso.info("******************************************************")


        @log_del_proceso.info ("Iniciado Parte ::" + @nombre_corto_archivo + "uad: #{@unidad_de_alta_de_datos.codigo},  efector: #{@efector.id} "  )
        tiempo_proceso = Time.now
        @log_del_proceso.debug ("Iniciando Apertura de archivo")

        @archivo_a_procesar = File.open(@filename,"r")
        @log_del_proceso.debug ("Apertura de archivo completa")


        @nombre_de_archivo_a_procesar = @filename

        @log_del_proceso.debug ("Iniciando la creacion de modelo y tabla")
        crear_modelo_y_tabla
        @log_del_proceso.debug ("Fin de la creacion de modelo y tabla")


        @log_del_proceso.debug ("Iniciando procesar_archivo")
        procesar_archivo
        @log_del_proceso.debug ("Fin procesar_archivo")

        @log_del_proceso.debug ("Iniciando persistir_prestaciones")
        persistir_prestaciones
        @log_del_proceso.debug ("Fin persistir_prestaciones")

      #  @log_del_proceso.debug ("Iniciando escribir_resultados")
        escribir_resultados
      #  @log_del_proceso.debug ("Fin escribir_resultados")

        eliminar_tabla
        @log_del_proceso.info("fIN Parte " + @filename.to_s + ", tiempo: ( #{ Time.now - tiempo_proceso} segundos )")

      end








      def particionar(archivo)

        data = Array.new()
        files = Array.new()
        lineNum = 0
        file_num = -1
        bytes    = 0
        max_lines = 1000
        @archivo_a_procesar_part = archivo

        filename =  @archivo_a_procesar_part.to_s
        r = File.exist?(filename)
        puts 'File exists =' + r.to_s + ' ' +  filename
        file=File.open(filename,"r")
        line_count = file.readlines.size
        #file_size = File.size(filename).to_f / 1024000
        puts 'Total lines=' + line_count.to_s  #+ '   size=' + file_size.to_s + ' Mb'
        puts ' '


        file = File.open(filename,"r")
        #puts '1 File open read ' + filename

        file.each{|line|
              bytes += line.length
              lineNum += 1
              data << line

                #if bytes > max_bytes  then
                if lineNum > max_lines  then
                      bytes = 0
                      file_num += 1


                  #puts '_2 File open write ' + file_num.to_s + '  lines ' + lineNum.to_s

                  files[file_num] =  @directory_name + "/part_#{file_num}.csv"
                  File.open( @directory_name + "/part_#{file_num}.csv", 'w') {|f| f.write data.join}

                 data.clear
                 lineNum = 0
                end



        }

        ## write leftovers
        file_num += 1
        puts '__3 File open write FINAL ' + file_num.to_s + '  lines ' + lineNum.to_s
            files[file_num] = @directory_name + "/part_#{file_num}.csv"
            File.open( @directory_name +"/part_#{file_num}.csv", 'w') {|f| f.write data.join}

    return files

    end



  def eliminar_tabla
    ActiveRecord::Base.connection.execute "
      DROP TABLE IF EXISTS importar_prestaciones_brindadas_#{@nombre_corto_archivo};
      DROP SEQUENCE IF EXISTS uad_#{unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas_#{@nombre_corto_archivo}_id_seq;
    "
  end

  def escribir_resultados

#GRABO EN EL PARCIAL LOS RESULTADOS

    archivo = File.open(@nombre_de_archivo_a_procesar + '.out', "w")
    archivo.puts ImportarPrestacionBrindada.column_names.join("\t")
    ImportarPrestacionBrindada.find(:all).each do |n|
      archivo.puts n.attributes.values.join("\t")
    end
    archivo.close

#GRABO EN EL GLOBAL LOS RESULTADOS
  #  @archivo_de_log_completo.puts ImportarPrestacionBrindada.column_names.join("\t")
  #  ImportarPrestacionBrindada.find(:all).each do |n|
    #  @archivo_de_log_completo.puts n.attributes.values.join("\t")

  # end
end

  def crear_modelo_y_tabla
    ActiveRecord::Base.connection.schema_search_path = "uad_" + @unidad_de_alta_de_datos.codigo + ", public"
    ActiveRecord::Base.connection.execute "
      DROP TABLE IF EXISTS uad_#{@unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas_#{@nombre_corto_archivo};
      CREATE TABLE uad_#{@unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas_#{@nombre_corto_archivo} (
        id integer,
        fecha_de_la_prestacion date,
        clave_de_beneficiario_informado varchar(255),
        apellido_informado varchar(255),
        nombre_informado varchar(255),
        clase_de_documento_informado varchar(255),
        tipo_de_documento_informado varchar(255),
        numero_de_documento_informado varchar(255),
        historia_clinica varchar(255),
        codigo_de_prestacion_informado varchar(255),
        id_dato_reportable_1 integer,
        dato_reportable_1 varchar(255),
        id_dato_reportable_2 integer,
        dato_reportable_2 varchar(255),
        id_dato_reportable_3 integer,
        dato_reportable_3 varchar(255),
        id_dato_reportable_4 integer,
        dato_reportable_4 varchar(255),
        clave_de_beneficiario varchar(255),
        apellido varchar(255),
        nombre varchar(255),
        clase_de_documento varchar(255),
        tipo_de_documento varchar(255),
        numero_de_documento varchar(255),
        sexo varchar(255),
        fecha_de_nacimiento date,
        efector_id integer,
        prestacion_id integer,
        diagnostico_id integer,
        dato_reportable_1_id integer,
        dato_reportable_1_valor varchar(255),
        dato_reportable_2_id integer,
        dato_reportable_2_valor varchar(255),
        dato_reportable_3_id integer,
        dato_reportable_3_valor varchar(255),
        dato_reportable_4_id integer,
        dato_reportable_4_valor varchar(255),
        persistido boolean,
        errores text
      );
      CREATE SEQUENCE uad_#{@unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas_#{@nombre_corto_archivo}_id_seq;
      ALTER SEQUENCE uad_#{@unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas_#{@nombre_corto_archivo}_id_seq
        OWNED BY uad_#{@unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas_#{@nombre_corto_archivo}.id;
      ALTER TABLE uad_#{@unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas_#{@nombre_corto_archivo}
        ALTER COLUMN id
        SET DEFAULT nextval('uad_#{@unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas_#{@nombre_corto_archivo}_id_seq'::regclass);
    "
$table = "importar_prestaciones_brindadas_#{@nombre_corto_archivo}"
    if !Class::constants.member?("ImportarPrestacionBrindada")

      Object.const_set("ImportarPrestacionBrindada", Class.new(ActiveRecord::Base) {
        self.set_table_name $table
        attr_accessible :fecha_de_la_prestacion, :clave_de_beneficiario_informado, :apellido_informado, :nombre_informado
        attr_accessible :clase_de_documento_informado, :tipo_de_documento_informado, :numero_de_documento_informado
        attr_accessible :historia_clinica, :codigo_de_prestacion_informado, :id_dato_reportable_1, :dato_reportable_1
        attr_accessible :id_dato_reportable_2, :dato_reportable_2, :id_dato_reportable_3, :dato_reportable_3
        attr_accessible :id_dato_reportable_4, :dato_reportable_4, :clave_de_beneficiario
        attr_accessible :efector_id, :prestacion_id, :diagnostico_id, :apellido, :nombre, :clase_de_documento, :tipo_de_documento
        attr_accessible :numero_de_documento, :sexo, :fecha_de_nacimiento, :dato_reportable_1_id, :dato_reportable_1_valor
        attr_accessible :dato_reportable_2_id, :dato_reportable_2_valor, :dato_reportable_3_id, :dato_reportable_3_valor
        attr_accessible :dato_reportable_4_id, :dato_reportable_4_valor, :persistido, :errores, :id

        def agregar_error(texto)
          if self.errores.blank?
            self.errores = texto
          else
            self.errores = self.errores + " - " + texto
          end
        end
      } )
    end

  end

  def procesar_archivo

    raise ArgumentError unless @archivo_a_procesar.present?

    ActiveRecord::Base.logger.silence do
      archivo = File.open(@archivo_a_procesar, "r")
      #Variables basura para medir el rendimiento
      tiempo_maximo_linea = 0
      tiempo_maximo_linea_sin_save = 0
      #fin de variables basura

      archivo.each_with_index do |linea, i|
        tiempo = Time.now
        clase_de_documento_valido = true
        tipo_de_documento_valido = true
        fecha_de_la_prestacion_valida =true


        if !tiene_etiquetas_de_columnas || i != 0

          prestacion_brindada = ImportarPrestacionBrindada.new(parsear_linea(linea).merge!({
            :id => i + 1,
            :efector_id => @efector.id
          }))

          #Elimino los espacios que puedan contener los datos
          prestacion_brindada.clase_de_documento_informado = prestacion_brindada.clase_de_documento_informado.to_s.strip
          prestacion_brindada.tipo_de_documento_informado = prestacion_brindada.tipo_de_documento_informado.to_s.strip
          prestacion_brindada.codigo_de_prestacion_informado = prestacion_brindada.codigo_de_prestacion_informado.to_s.strip




          # Registrar el error si la fecha de la prestación no tiene un formato reconocible
          if !prestacion_brindada.fecha_de_la_prestacion.present?
            prestacion_brindada.agregar_error("La fecha de la prestación no se pudo reconocer (cadena evaluada: '#{prestacion_brindada.fecha_de_la_prestacion}')")
            fecha_de_la_prestacion_valida = false
          end

          # Evaluar si faltan datos
          if prestacion_brindada.clase_de_documento_informado.nil?
            prestacion_brindada.agregar_error("Se informó una clase de documento nulo")
            clase_de_documento_valido = false
          elsif (hash_a_id(@hash_clases, prestacion_brindada.clase_de_documento_informado).nil?)
            prestacion_brindada.agregar_error("Se informó una clase de documento invalido")
            tipo_de_documento_valido = false
          end

          if prestacion_brindada.tipo_de_documento_informado.nil?
            prestacion_brindada.agregar_error("Se informó un tipo de documento nulo")
            tipo_de_documento_invalido = false
          elsif (hash_a_id(@hash_tipos, prestacion_brindada.tipo_de_documento_informado).nil?)
            prestacion_brindada.agregar_error("Se informó un tipo de documento invalido")
            tipo_de_documento_valido = false
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



          beneficiarios = []
          prestaciones = []

          #Verifico que los datos ingresados sean correctos para podes hacer la busqueda
          if (clase_de_documento_valido && tipo_de_documento_valido)
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
                  TipoDeDocumento.find(hash_a_id(@hash_tipos, prestacion_brindada.tipo_de_documento_informado))
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
        end

          # Obtener la prestación y el diagnóstico asociados con el código informado, o indicar el error si no se informó el código

          if !(prestacion_brindada.codigo_de_prestacion_informado.present?)
            prestacion_brindada.agregar_error(
              "No se informó el código de prestación"
            )
          else
            codigo_de_prestacion = prestacion_brindada.codigo_de_prestacion_informado[0..5]
            prestacion = Prestacion.find_by_codigo(codigo_de_prestacion)
            if !prestacion.present?
              prestacion_brindada.agregar_error(
                "El código de prestación no existe (cadena evaluada: '#{codigo_de_prestacion}')"
              )
            end

            codigo_de_diagnostico = prestacion_brindada.codigo_de_prestacion_informado[6..-1]
            diagnostico = Diagnostico.find_by_codigo(codigo_de_diagnostico)
            if !diagnostico.present?
              prestacion_brindada.agregar_error(
                "El código de diagnóstico no existe (cadena evaluada: '#{codigo_de_diagnostico}')"
              )
            else
              prestacion_brindada.diagnostico_id = diagnostico.id
            end

            if (prestacion.present? && diagnostico.present?)
              # Obtener todas las prestaciones que tengan el código informado y admitan el diagnóstico informado
              prestaciones = Prestacion.where(
                " codigo = ?
                  AND EXISTS (
                    SELECT *
                      FROM diagnosticos_prestaciones
                      WHERE
                        diagnosticos_prestaciones.prestacion_id = prestaciones.id
                        AND diagnosticos_prestaciones.diagnostico_id = ?
                  )
                  AND activa",
                  codigo_de_prestacion, diagnostico.id
                )

              # Registrar el error si no se encuentra una prestación para esa combinación de código y diagnóstico
              if prestaciones.size == 0
                prestacion_brindada.agregar_error(
                  "No se encontró una prestación activa con código '#{codigo_de_prestacion}' y diagnóstico '#{diagnostico.nombre} (#{codigo_de_diagnostico})'"
                )
              end
            end
          end

            # Inicializamos la variable que va a contener las distintas soluciones posibles, junto con su puntuación en forma ordenada
            soluciones = []
            # Construimos todas las soluciones combinando los beneficiarios y prestaciones posibles, y asignamos una puntuación
            # a cada solución

                #Si se detecto algun beneficiario iniciamos la busqueda

              if beneficiarios.size > 0 && prestaciones.size > 0

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

                if(fecha_de_la_prestacion_valida)
                  if !(beneficiario.sexo.present? )
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
                end

                  if (prestaciones.size > 0 && fecha_de_la_prestacion_valida)
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
                        pb.prestacion.datos_reportables_requeridos.where(
                          "fecha_de_inicio <= ? AND (
                             fecha_de_finalizacion IS NULL
                             OR fecha_de_finalizacion > ?
                          )", pb.fecha_de_la_prestacion, pb.fecha_de_la_prestacion).
                          each do |drr|
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
                if hash_a_id(@hash_clases, prestacion_brindada.clase_de_documento_informado.strip) == ClaseDeDocumento.id_del_codigo!("A")
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

                  if soluciones.size >= 1

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

                  else
                      prestacion_brindada.agregar_error("No se pudo determinar la prestación correspondiente para la fecha: '#{prestacion_brindada.fecha_de_la_prestacion}'' , clase_de_documento: '#{prestacion_brindada.clase_de_documento_informado}', tipo_de_documento: '#{prestacion_brindada.tipo_de_documento_informado}'")
                  end
                end

              end

              elsif beneficiarios.size == 0
                prestacion_brindada.agregar_error("No se pudo encontrar un beneficiario con tipo de documento (informado:'#{prestacion_brindada.tipo_de_documento_informado}' , clase de documento (informado: #{prestacion_brindada.clase_de_documento_informado})' y numero de documento (informado '#{prestacion_brindada.numero_de_documento_informado}')")

              elsif prestaciones.size == 0
                prestacion_brindada.agregar_error("No se pudo evaluar detectar una prestación con codigo (informado:'#{prestacion_brindada.codigo_de_prestacion_informado}')")
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
          tiempo_sin_save = Time.now - tiempo
          tiempo_maximo_linea_sin_save = (tiempo_maximo_linea_sin_save > tiempo_sin_save) ? tiempo_maximo_linea_sin_save : tiempo_sin_save

            # Guardar la prestación y continuar con la próxima línea
          prestacion_brindada.save

          tiempo_con_save = Time.now - tiempo
          tiempo_maximo_linea = (tiempo_maximo_linea > tiempo_con_save) ? tiempo_maximo_linea : tiempo_con_save

        end

      end


      # Cerrar el archivo de importación de prestaciones
      @log_del_proceso.debug ("Iniciando procesar_archivo(cerrado de archivo)")
      archivo.close
      @log_del_proceso.debug("fin procesar_archivo(cerrado de archivo)")
      @log_del_proceso.debug("Tiempo Mayor Antes de guardar= #{tiempo_maximo_linea_sin_save} segundos" )
      @log_del_proceso.debug("Tiempo Mayor Antes de guardar= #{tiempo_maximo_linea} segundos")
    end
  end

  def persistir_prestaciones
    ImportarPrestacionBrindada.where(:persistido => true).each do |pb|
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
      prestacion_brindada.prestacion.datos_reportables_requeridos.where(
        "fecha_de_inicio <= ? AND (
           fecha_de_finalizacion IS NULL
           OR fecha_de_finalizacion > ?
        )", prestacion_brindada.fecha_de_la_prestacion, prestacion_brindada.fecha_de_la_prestacion).
        each do |drr|
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

      prestacion_brindada.creator_id = 897
      prestacion_brindada.updater_id = 897

      prestacion_brindada.save

    end
  end

  def parsear_linea(linea)
    return nil unless linea

    campos = linea.gsub(/[\r\n]/, "").split("\t")

    return {
      :fecha_de_la_prestacion => a_fecha(campos[0]),
      :clave_de_beneficiario_informado => a_texto(campos[1]),
      :apellido_informado => a_texto(campos[2]),
      :nombre_informado => a_texto(campos[3]),
      :clase_de_documento_informado => a_texto(campos[4]),
      :clase_de_documento => hash_a_id(@hash_clases, a_texto(campos[4])),
      :tipo_de_documento_informado => a_texto(campos[5]),
      :tipo_de_documento => hash_a_id(@hash_tipos, a_texto(campos[5])),
      :numero_de_documento_informado => a_numero_de_documento(campos[6]),
      :historia_clinica => a_texto(campos[7]),
      :codigo_de_prestacion_informado => a_codigo_de_prestacion(campos[8]),
      :id_dato_reportable_1 => a_entero(campos[9]),
      :dato_reportable_1 => a_texto(campos[10]),
      :id_dato_reportable_2 => a_entero(campos[11]),
      :dato_reportable_2 => a_texto(campos[12]),
      :id_dato_reportable_3 => a_entero(campos[13]),
      :dato_reportable_3 => a_texto(campos[14]),
      :id_dato_reportable_4 => a_entero(campos[15]),
      :dato_reportable_4 => a_texto(campos[16])
    }
  end

  def a_texto(cadena)
    texto = cadena.to_s.strip.gsub(/  /, " ").gsub("NULL", "").mb_chars.upcase.to_s
    return (texto.blank? ? nil : texto)
  end

  def a_codigo_de_prestacion(cadena)
    texto = cadena.to_s.strip.gsub(/[ -,]/, "").gsub("NULL", "").upcase
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
        begin
          dia, mes, anio = texto.split(".")
          fecha = Date.new(anio.to_i, mes.to_i, dia.to_i)
        rescue
          fecha = nil
        end
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

  def a_distrito_id(departamento_id, cadena)
    return nil unless departamento_id.present?

    if cadena.blank?
      cadena = "IGNORADO"
    end

    return hash_distritos[departamento_id].values[hash_distritos[departamento_id].keys.collect{|n| n.mb_chars.upcase.to_s}.index(cadena) || 1000]

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


  def encolar_registro_masivo_prestaciones(archivo, uad, efe)

      raise ArgumentError if archivo.blank?
      raise ArgumentError if uad.nil?
      raise ArgumentError if efe.nil?

      self.archivo_completo = archivo
      @directory_name = "#{archivo}".split(".")[0]

      #PREPARO LOS ARCHIVOS PARA PROCESAR-ELIMINANDO LOS YA PROCESADOS
      if !File.directory?(@directory_name)
        FileUtils.mkdir_p(@directory_name)

      archivos_a_particionar_part_names = particionar(archivo)
      else

      @archivos_a_particionar_part_names = Dir.glob(@directory_name.to_s + "/part_*"+".csv")
      @archivos_a_particionar_part_names = eliminar_procesados(archivos_a_particionar_part_names)

      end


      #PROCESO LAS PARTES
      @log_del_proceso.info ("Iniciando procesamiento de archivo Masivo")

      if !archivos_a_particionar_part_names.empty?

            archivos_a_particionar_part_names.each{ |filename|
            proceso_de_sistema = ProcesoDeSistema.new
            params = Hash.new
            params['archivo'] = filename
            params['uad'] = uad
            params['efe'] = efe
            proceso_de_sistema.parametros_dinamicos = params.to_json
            if proceso_de_sistema.save
               Delayed::Job.enqueue NacerJob::RegistroMasivoPrestacionesJob.new(proceso_de_sistema.id) , priority: -10
            end
          }

      else @log_del_proceso.info "\n \n"+'No hay más partes para procesar'

      end
      @log_del_proceso.info ("Fin del encolado de archivo Masivo")

  end





end
