# -*- encoding : utf-8 -*-

class RegistroMasivoDePrestaciones

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

# load 'lib/tasks/procesar_archivo_prestaciones.rb'
# ins = InscripcionMasiva.new(UnidadDeAltaDeDatos.where(:codigo => "006").first, CentroDeInscripcion.where("nombre ILIKE '%notti%'").first, Efector.where("nombre ILIKE '%notti%'").first)
# ins.archivo_a_procesar = "/home/sbosio/Documentos/Plan Nacer/Operaciones/Inscripciones masivas/Inscripciones masivas Notti.csv"
# ins.tiene_etiquetas_de_columnas = true

  def initialize
    @archivo_a_procesar = nil
    @unidad_de_alta_de_datos = nil
    @centro_de_inscripcion = nil
    @efector = nil
    @tiene_etiquetas_de_columna = false
    @hash_clases = {}
    @hash_tipos = {}
    @hash_sexos = {}

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

  def establecer_esquema(esquema = "public")
  end

  def procesar(archivo, uad, efe)
    raise ArgumentError if archivo.blank?
    raise ArgumentError unless uad.is_a? UnidadDeAltaDeDatos
    raise ArgumentError unless efe.is_a? Efector

    self.archivo_a_procesar = archivo
    self.unidad_de_alta_de_datos = uad
    self.efector = efe

    crear_modelo_y_tabla
    procesar_archivo
    persistir_prestaciones
    escribir_resultados
    eliminar_tabla
  end

  def eliminar_tabla
    ActiveRecord::Base.connection.execute "
      DROP TABLE IF EXISTS importar_prestaciones_brindadas;
      DROP SEQUENCE IF EXISTS uad_#{unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas_id_seq;
    "
  end

  def escribir_resultados

    archivo = File.open(@archivo_a_procesar + ".out", "w")

    archivo.puts ImportarPrestacionBrindada.column_names.join("\t")

    ImportarPrestacionBrindada.find(:all).each do |n|
      archivo.puts n.attributes.values.join("\t")
    end
    archivo.close

  end

  def crear_modelo_y_tabla
    ActiveRecord::Base.connection.schema_search_path = "uad_" + @unidad_de_alta_de_datos.codigo + ", public"
    ActiveRecord::Base.connection.execute "
      DROP TABLE IF EXISTS importar_prestaciones_brindadas;
      CREATE TABLE importar_prestaciones_brindadas (
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
        estado_de_la_prestacion_id integer,
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
      CREATE SEQUENCE uad_#{@unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas_id_seq;
      ALTER SEQUENCE uad_#{@unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas_id_seq
        OWNED BY uad_#{@unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas.id;
      ALTER TABLE uad_#{@unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas
        ALTER COLUMN id
        SET DEFAULT nextval('uad_#{@unidad_de_alta_de_datos.codigo}.importar_prestaciones_brindadas_id_seq'::regclass);
    "

    if !Class::constants.member?("ImportarPrestacionBrindada")
      Object.const_set("ImportarPrestacionBrindada", Class.new(ActiveRecord::Base) {
        set_table_name "importar_prestaciones_brindadas"
        attr_accessible :fecha_de_la_prestacion, :clave_de_beneficiario_informado, :apellido_informado, :nombre_informado
        attr_accessible :clase_de_documento_informado, :tipo_de_documento_informado, :numero_de_documento_informado
        attr_accessible :historia_clinica, :codigo_de_prestacion_informado, :id_dato_reportable_1, :dato_reportable_1
        attr_accessible :id_dato_reportable_2, :dato_reportable_2, :id_dato_reportable_3, :dato_reportable_3
        attr_accessible :id_dato_reportable_4, :dato_reportable_4, :estado_de_la_prestacion_id, :clave_de_beneficiario
        attr_accessible :efector_id, :prestacion_id, :diagnostico_id, :apellido, :nombre, :clase_de_documento, :tipo_de_documento
        attr_accessible :numero_de_documento, :sexo, :fecha_de_nacimiento, :dato_reportable_1_id, :dato_reportable_1_valor
        attr_accessible :dato_reportable_2_id, :dato_reportable_2_valor, :dato_reportable_3_id, :dato_reportable_3_valor
        attr_accessible :dato_reportable_4_id, :dato_reportable_4_valor, :persistido, :errores

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
          prestacion_brindada = ImportarPrestacionBrindada.new(parsear_linea(linea).merge!({
            :efector_id => @efector.id
          }))

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
                prestacion_brindada.apellido_informado.to_s + " " + prestacion_brindada.nombre_informado.to_s
              )

            if beneficiarios.present? && nivel > 4
              # Beneficiario encontrado -- o por lo menos con alta probabilidad --
              beneficiario = beneficiarios.first
            else
              beneficiario = nil
              prestacion_brindada.agregar_error(
                "No se encontró al beneficiario " + \
                "'#{prestacion_brindada.apellido_informado}, #{prestacion_brindada.nombre_informado}'" + \
                ", con documento número '#{prestacion_brindada.numero_de_documento_informado}' en el padrón"
              )
            end
          end

          # Registrar el error y continuar con la próxima línea si no se encontró al beneficiario
          if !beneficiario.present?
            prestacion_brindada.persistido = false
            prestacion_brindada.save
            next
          end

          prestacion_brindada.attributes = {
            :clave_de_beneficiario => beneficiario.clave_de_beneficiario,
            :apellido => beneficiario.apellido,
            :nombre => beneficiario.nombre,
            :clase_de_documento => @hash_clases[beneficiario.clase_de_documento_id],
            :tipo_de_documento => @hash_tipos[beneficiario.tipo_de_documento_id],
            :numero_de_documento => beneficiario.numero_de_documento,
            :sexo => @hash_sexos[beneficiario.sexo_id],
            :fecha_de_nacimiento => beneficiario.fecha_de_nacimiento
          }

          # TODO: cambiar esto por verificaciones del motivo de baja
          # Registrar el error y continuar con la próxima línea si el beneficiario tiene datos imprescindibles incompletos
          if !(beneficiario.sexo.present? && beneficiario.fecha_de_nacimiento.present?)
            prestacion_brindada.agregar_error(
              "No se puede evaluar la prestación porque al registro del beneficiario le faltan datos imprescindibles (sexo o fecha de nacimiento)"
            )
            prestacion_brindada.persistido = false
            prestacion_brindada.save
            next
          end

          # Registrar el error y continuar con la próxima línea si la fecha de la prestación no tiene un formato reconocible
          if !prestacion_brindada.fecha_de_la_prestacion.present?
            prestacion_brindada.agregar_error(
              "La fecha de la prestación no se pudo reconocer (cadena evaluada: '#{prestacion_brindada.fecha_de_la_prestacion}')"
            )
            prestacion_brindada.persistido = false
            prestacion_brindada.save
            next
          end

          # Obtener la prestación y el diagnóstico asociados con el código informado, o indicar el error si no se informó el código
          if !prestacion_brindada.codigo_de_prestacion_informado.present?
            prestacion_brindada.agregar_error(
              "No se informó el código de prestación"
            )
            prestacion_brindada.persistido = false
            prestacion_brindada.save
            next
          end

          codigo_prestacion = prestacion_brindada.codigo_de_prestacion_informado[0..5]
          if !Prestacion.find_by_codigo(codigo_prestacion).present?
            prestacion_brindada.agregar_error(
              "El código de prestación no existe (cadena evaluada: '#{codigo_prestacion}')"
            )
          end

          codigo_diagnostico = prestacion_brindada.codigo_de_prestacion_informado[6..-1]
          diagnostico = Diagnostico.find_by_codigo(codigo_diagnostico)
          if !diagnostico.present?
            prestacion_brindada.agregar_error(
              "El código de diagnóstico no existe (cadena evaluada: '#{codigo_diagnostico}')"
            )
          end

          # Continuar con la próxima línea si se produjo algún error hasta este punto del proceso
          if !prestacion_brindada.errores.blank?
            prestacion_brindada.persistido = false
            prestacion_brindada.save
            next
          end

          # Intentar individualizar una prestación que tenga el código informado, admita el diagnóstico informado,
          grupo_poblacional = beneficiario.grupo_poblacional_al_dia(prestacion_brindada.fecha_de_la_prestacion)
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
            prestacion_brindada.persistido = false
            prestacion_brindada.save
            next
          end

          # Verificar que la prestación informada esté habilitada para este efector, y descartamos las que no lo estén
          autorizadas_por_efector =
            Prestacion.find(
              @efector.prestaciones_autorizadas_al_dia(prestacion_brindada.fecha_de_la_prestacion).collect{
                |p| p.prestacion_id
              }
            )

          # Descartamos las prestaciones que no están autorizadas para el efector
          prestaciones.keep_if{|p| autorizadas_por_efector.member?(p)}

          # Registrar el error y continuar con la próxima línea si ninguna de las prestaciones estaba habilitada para el efector
          if prestaciones.size == 0
            prestacion_brindada.agregar_error(
              "La prestación no fue habilitada para el efector a la fecha de la prestación"
            )
            prestacion_brindada.persistido = false
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
              "La prestación no está habilitada para el sexo del beneficiario (#{prestacion_brindada.sexo.downcase})"
            )
            prestacion_brindada.persistido = false
            prestacion_brindada.save
            next
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
              :efector_id => @efector.id,
              :prestacion_id => p.id,
              :es_catastrofica => p.es_catastrofica,
              :diagnostico_id => diagnostico.id
            })
            dras = []
            pb.prestacion.datos_reportables_requeridos.each do |drr|
              if drr.dato_reportable_id == prestacion_brindada.dato_reportable_1_id
                dra_valor = prestacion_brindada.dato_reportable_1_valor
              elsif drr.dato_reportable_id == prestacion_brindada.dato_reportable_2_id
                dra_valor = prestacion_brindada.dato_reportable_2_valor
              elsif drr.dato_reportable_id == prestacion_brindada.dato_reportable_3_id
                dra_valor = prestacion_brindada.dato_reportable_3_valor
              elsif drr.dato_reportable_id == prestacion_brindada.dato_reportable_4_id
                dra_valor = prestacion_brindada.dato_reportable_4_valor
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
              :efector_id => @efector.id,
              :prestacion_id => prestaciones.first.id,
              :es_catastrofica => prestaciones.first.es_catastrofica,
              :diagnostico_id => diagnostico.id
            })
            dras = []
            pb.prestacion.datos_reportables_requeridos.each do |drr|
              if drr.dato_reportable_id == prestacion_brindada.dato_reportable_1_id
                dra_valor = prestacion_brindada.dato_reportable_1_valor
              elsif drr.dato_reportable_id == prestacion_brindada.dato_reportable_2_id
                dra_valor = prestacion_brindada.dato_reportable_2_valor
              elsif drr.dato_reportable_id == prestacion_brindada.dato_reportable_3_id
                dra_valor = prestacion_brindada.dato_reportable_3_valor
              elsif drr.dato_reportable_id == prestacion_brindada.dato_reportable_4_id
                dra_valor = prestacion_brindada.dato_reportable_4_valor
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
          end

          if pb.valid?
            prestacion_brindada.attributes = {
              :prestacion_id => pb.prestacion_id,
              :diagnostico_id => pb.diagnostico_id,
              :persistido => true
            }
            if pb.metodos_de_validacion.size > 0
              pb.metodos_de_validacion.each do |mv|
                prestacion_brindada.agregar_error("Advertencia: " + mv.mensaje)
              end
              prestacion_brindada.estado_de_la_prestacion_id = 2
            else
              prestacion_brindada.estado_de_la_prestacion_id = 3
            end
          else
            prestacion_brindada.agregar_error(pb.errors.full_messages.join(" - "))
            prestacion_brindada.persistido = false
          end

          # Guardar la prestación y continuar con la próxima línea
          prestacion_brindada.save
        end
      end

      archivo.close
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

  def parsear_linea(linea)
    return nil unless linea

    campos = linea.gsub(/[\r\n]/, "").split("\t")

    return {
      :fecha_de_la_prestacion => a_fecha(campos[0]),
      :clave_de_beneficiario_informado => a_texto(campos[1]),
      :apellido_informado => a_texto(campos[2]),
      :nombre_informado => a_texto(campos[3]),
      :clase_de_documento_informado => a_texto(campos[4]),
      :tipo_de_documento_informado => a_texto(campos[5]),
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
