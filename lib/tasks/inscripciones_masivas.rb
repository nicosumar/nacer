# -*- encoding : utf-8 -*-

class InscripcionMasiva

  attr_accessor :archivo_a_procesar
  attr_accessor :parte
  attr_accessor :unidad_de_alta_de_datos
  attr_accessor :centro_de_inscripcion
  attr_accessor :efector_de_atencion_habitual
  attr_accessor :registros_leidos
  attr_accessor :tiene_etiquetas_de_columnas
  attr_accessor :hash_clases
  attr_accessor :hash_tipos
  attr_accessor :hash_sexos
  attr_accessor :hash_alfabetizacion
  attr_accessor :hash_departamentos
  attr_accessor :hash_distritos

# load 'lib/tasks/inscripciones_masivas.rb'
# ins = InscripcionMasiva.new(UnidadDeAltaDeDatos.where(:codigo => "006").first, CentroDeInscripcion.where("nombre ILIKE '%centro%300%'").first, Efector.where("nombre ILIKE '%centro%300%'").first)
# ins.archivo_a_procesar = "/home/sbosio/Documentos/Plan Nacer/Operaciones/Inscripciones masivas/Inscripciones masivas CS300.csv"

  def initialize
    @archivo_a_procesar = nil
#    @unidad_de_alta_de_datos = UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual])
#    if unidad_de_alta_de_datos.centros_de_inscripcion.size == 1
#      @centro_de_inscripcion = unidad_de_alta_de_datos.centros_de_inscripcion.first
#    else
#      @centro_de_inscripcion = nil
#    end
#    if unidad_de_alta_de_datos.efectores.size == 1
#      @efector_de_atencion_habitual = unidad_de_alta_de_datos.efectores.first
#    else
#      @efector_de_atencion_habitual = nil
#    end
    @archivo_a_procesar = nil
    @parte = nil
    @unidad_de_alta_de_datos = nil
    @centro_de_inscripcion = nil
    @efector_de_atencion_habitual = nil
    @tiene_etiquetas_de_columna = false
    @hash_clases = {}
    @hash_tipos = {}
    @hash_sexos = {}
    @hash_alfabetizacion = {}
    @hash_departamentos = {}
    @hash_distritos = {}

    ClaseDeDocumento.find(:all).each do |i|
      @hash_clases.merge! i.codigo => i.id
    end
    TipoDeDocumento.find(:all).each do |i|
      @hash_tipos.merge! i.codigo => i.id
    end
    Sexo.find(:all).each do |i|
      @hash_sexos.merge! i.codigo => i.id
    end
    NivelDeInstruccion.find(:all).each do |i|
      @hash_alfabetizacion.merge! i.codigo => i.id
    end
    Departamento.where(:provincia_id => 9).each do |depto|
      @hash_departamentos.merge! depto.departamento_bio_id => depto.id
      hash_dist = {}
      depto.distritos.each do |dist|
        hash_dist.merge! dist.nombre => dist.id
      end
      @hash_distritos.merge! depto.id => hash_dist
    end
  end

  def establecer_esquema(esquema = "public")
  end

  def crear_tabla_temporal
  end

  def procesar(archivo, part, uad, ci, efe)
    self.archivo_a_procesar = archivo
    self.parte = part
    self.unidad_de_alta_de_datos = uad
    self.centro_de_inscripcion = ci
    self.efector_de_atencion_habitual = efe

    crear_modelo_y_tabla
    procesar_archivo
    persistir_inscripciones
    escribir_resultados
    eliminar_tabla

  end

  def eliminar_tabla
    ActiveRecord::Base.connection.execute "
      DROP TABLE IF EXISTS novedades_de_los_afiliados_temp_#{@parte};
      DROP SEQUENCE IF EXISTS uad_#{unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_#{@parte}_id_seq;
    "
  end

  def escribir_resultados

    archivo = File.open(@archivo_a_procesar + "." + @parte + ".out", "w")

    archivo.puts eval("NovedadDelAfiliadoTemp#{@parte.titleize}").column_names.join("\t")

    eval("NovedadDelAfiliadoTemp#{@parte.titleize}").find(:all).each do |n|
      archivo.puts n.attributes.values.join("\t")
    end
    archivo.close

  end

  def crear_modelo_y_tabla
    ActiveRecord::Base.connection.schema_search_path = "uad_" + @unidad_de_alta_de_datos.codigo + ", public"

    ActiveRecord::Base.connection.execute "
      DROP TABLE IF EXISTS novedades_de_los_afiliados_temp_#{@parte};
      CREATE TABLE novedades_de_los_afiliados_temp_#{@parte} (LIKE novedades_de_los_afiliados);
      ALTER TABLE novedades_de_los_afiliados_temp_#{@parte} ADD COLUMN persistido boolean;
      ALTER TABLE novedades_de_los_afiliados_temp_#{@parte} ADD COLUMN errores_y_advertencias text;
      DROP SEQUENCE IF EXISTS uad_#{@unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_#{@parte}_id_seq;
      CREATE SEQUENCE uad_#{@unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_#{@parte}_id_seq;
      ALTER SEQUENCE uad_#{@unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_#{@parte}_id_seq
        OWNED BY uad_#{@unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_#{@parte}.id;
      ALTER TABLE uad_#{@unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_#{@parte}
        ALTER COLUMN id
        SET DEFAULT nextval('uad_#{@unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_#{@parte}_id_seq'::regclass);
      CREATE INDEX idx_novedades_de_los_afiliados_temp_#{@parte}_1 ON uad_#{@unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_#{@parte}
        (clase_de_documento_id, tipo_de_documento_id, numero_de_documento, estado_de_la_novedad_id, tipo_de_novedad_id);
      CREATE INDEX idx_novedades_de_los_afiliados_temp_#{@parte}_2 ON uad_#{@unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_#{@parte}
        (apellido, nombre, fecha_de_nacimiento, estado_de_la_novedad_id, tipo_de_novedad_id);
      CREATE INDEX idx_novedades_de_los_afiliados_temp_#{@parte}_3 ON uad_#{@unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_#{@parte}
        (nombre, fecha_de_nacimiento, numero_de_documento_de_la_madre, estado_de_la_novedad_id, tipo_de_novedad_id);
    "

    if !Class::constants.member?("NovedadDelAfiliadoTemp#{@parte.titleize}".to_sym)
      Object.const_set("PARTE", @parte)
      Object.const_set("NovedadDelAfiliadoTemp#{@parte.titleize}", Class.new(NovedadDelAfiliado) {

        set_table_name "novedades_de_los_afiliados_temp_#{PARTE}"

        def fechas_correctas
          error_de_fecha = false

          # Fecha de la novedad
          if fecha_de_la_novedad

            # Fecha de nacimiento
            if fecha_de_nacimiento && fecha_de_la_novedad < fecha_de_nacimiento
              errors.add(:fecha_de_la_novedad, 'no puede ser anterior a la fecha de nacimiento')
              errors.add(:fecha_de_nacimiento, 'no puede ser posterior a la fecha de inscripción/modificación')
              error_de_fecha = true
            end

            # Fecha de hoy
            if fecha_de_la_novedad > Date.today
              errors.add(:fecha_de_la_novedad, 'no puede ser una fecha futura')
              error_de_fecha = true
            end

          end # fecha_de_la_novedad

          # Fecha de nacimiento
          if fecha_de_nacimiento

            # Fecha de hoy
            if fecha_de_nacimiento > Date.today
              errors.add(:fecha_de_nacimiento, 'no puede ser una fecha futura')
              error_de_fecha = true
            end

          end # fecha_de_nacimiento

          return !error_de_fecha

        end

        def documentos_correctos

          error_de_documento = false

          # Verificar que el valor del campo número de documento sea válido, si el tipo es DNI, LC o LE
          if ( tipo_de_documento_id && numero_de_documento && [1,2,3].member?(tipo_de_documento_id) )
            numero_de_documento.gsub!(/[^[:digit:]]/, '')
            if !numero_de_documento.blank? && (numero_de_documento.to_i < 50000 || numero_de_documento.to_i > 99999999)
              errors.add(:numero_de_documento, 'no se encuentra en el intervalo esperado (50000-99999999).')
              error_de_documento = true
            end
          end

          # Verificar que el valor del campo número de documento de la madre sea válido, si el tipo es DNI, LC o LE
          if ( tipo_de_documento_de_la_madre_id && numero_de_documento_de_la_madre && [1,2,3].member?(tipo_de_documento_de_la_madre_id) )
            numero_de_documento_de_la_madre.gsub!(/[^[:digit:]]/, '')
            if !numero_de_documento_de_la_madre.blank? && (numero_de_documento_de_la_madre.to_i < 50000 ||
                numero_de_documento_de_la_madre.to_i > 99999999)
              errors.add(:numero_de_documento_de_la_madre, 'no se encuentra en el intervalo esperado (50000-99999999).')
              error_de_documento = true
            end
          end

          # Verificar que el valor del campo número de documento del padre sea válido, si el tipo es DNI, LC o LE
          if ( tipo_de_documento_del_padre_id && numero_de_documento_del_padre && [1,2,3].member?(tipo_de_documento_del_padre_id) )
            numero_de_documento_del_padre.gsub!(/[^[:digit:]]/, '')
            if !numero_de_documento_del_padre.blank? && (numero_de_documento_del_padre.to_i < 50000 ||
                numero_de_documento_del_padre.to_i > 99999999)
              errors.add(:numero_de_documento_del_padre, 'no se encuentra en el intervalo esperado (50000-99999999).')
              error_de_documento = true
            end
          end

          # Verificar que el valor del campo número de documento del padre sea válido, si el tipo es DNI, LC o LE
          if ( tipo_de_documento_del_tutor_id && numero_de_documento_del_tutor && [1,2,3].member?(tipo_de_documento_del_tutor_id) )
            numero_de_documento_del_tutor.gsub!(/[^[:digit:]]/, '')
            if !numero_de_documento_del_tutor.blank? && (numero_de_documento_del_tutor.to_i < 50000 ||
                numero_de_documento_del_tutor.to_i > 99999999)
              errors.add(:numero_de_documento_del_tutor, 'no se encuentra en el intervalo esperado (50000-99999999).')
              error_de_documento = true
            end
          end

          if clase_de_documento_id == 2
            if fecha_de_nacimiento && fecha_de_la_novedad && edad_en_anios(fecha_de_la_novedad) > 0
              errors.add(:base,
                "No se puede crear una solicitud con documento ajeno si el niño o niña ya ha cumplido el año de vida"
              )
              error_de_documento = true
            end
            if ((!numero_de_documento_de_la_madre.blank? || !numero_de_documento_del_padre.blank? || !numero_de_documento_del_tutor.blank?) &&
                ![numero_de_documento_de_la_madre, numero_de_documento_del_padre, numero_de_documento_del_tutor].member?(numero_de_documento))
              errors.add(:base,
                "El número de documento ajeno no coincide con el número de documento de ningún adulto responsable"
              )
              error_de_documento = true
            end
          end

          return false if error_de_documento

          return true
        end

        def es_una_baja?
          tipo_de_novedad_id == 2
        end

        def es_menor_de_edad
#          if !es_menor && fecha_de_la_novedad && fecha_de_nacimiento && (fecha_de_nacimiento + 10.years) > fecha_de_la_novedad
#            errors.add(
#              :es_menor, 'debe estar marcado si aún no ha cumplido los 10 años'
#            )
#            return false
#          end
          return true
        end

        def sin_duplicados

          # Verificaciones de números de documento propios para evitar duplicaciones por tipo y número de documento (motivo 81)
          if clase_de_documento_id == 1
            # Verificar si existe en la tabla de afiliados otro beneficiario con el mismo tipo y número de documento propio
            # que no esté marcado ya como duplicado
            afiliados =
              Afiliado.where(
                "clase_de_documento_id = ? AND tipo_de_documento_id = ? AND numero_de_documento = ?
                AND (motivo_de_la_baja_id IS NULL OR motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))",
                clase_de_documento_id, tipo_de_documento_id, numero_de_documento
              )
            if (afiliados || []).size > 0
              errors.add(:base,
                "No se puede crear la solicitud porque ya existe " +
                (afiliados.first.sexo && afiliados.first.sexo.codigo == "F" ? "una beneficiaria" : "un beneficiario") +
                " con el mismo tipo y número de documento: " + afiliados.first.apellido.to_s + ", " + afiliados.first.nombre.to_s +
                ", " + (afiliados.first.tipo_de_documento ? afiliados.first.tipo_de_documento.codigo + " " : "") +
                afiliados.first.numero_de_documento.to_s + ", clave " + afiliados.first.clave_de_beneficiario.to_s +
                (afiliados.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
                afiliados.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
              )
              return false
            end

            # Verificar si existe en las tablas de novedades otro beneficiario con el mismo tipo y número de documento propio
            # que esté pendiente
            novedades =
              NovedadDelAfiliado.where(
                "clase_de_documento_id = ? AND tipo_de_documento_id = ? AND numero_de_documento = ? AND
                estado_de_la_novedad_id IN (?) AND tipo_de_novedad_id IN (?)", clase_de_documento_id, tipo_de_documento_id,
                numero_de_documento, [1,2], (es_una_baja? ? [1,2] : [1,3])
              )
            if novedades.size > 0
              errors.add(:base,
                "No se puede crear la solicitud porque ya existe otra solicitud pendiente para el mismo tipo y número" +
                " de documento: " + novedades.first.apellido.to_s + ", " + novedades.first.nombre.to_s +
                ", " + (novedades.first.tipo_de_documento ? novedades.first.tipo_de_documento.codigo + " " : "") +
                novedades.first.numero_de_documento.to_s + ", clave " + novedades.first.clave_de_beneficiario.to_s +
                (novedades.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
                novedades.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
              )
              return false
            end
            novedades =
              eval("NovedadDelAfiliadoTemp#{PARTE.titleize}").where(
                "clase_de_documento_id = ? AND tipo_de_documento_id = ? AND numero_de_documento = ? AND
                estado_de_la_novedad_id IN (?) AND tipo_de_novedad_id IN (?)", clase_de_documento_id, tipo_de_documento_id,
                numero_de_documento, [1,2], (es_una_baja? ? [1,2] : [1,3])
              )
            if novedades.size > 0
              errors.add(:base,
                "No se puede crear la solicitud porque ya existe otra solicitud pendiente para el mismo tipo y número" +
                " de documento: " + novedades.first.apellido.to_s + ", " + novedades.first.nombre.to_s +
                ", " + (novedades.first.tipo_de_documento ? novedades.first.tipo_de_documento.codigo + " " : "") +
                novedades.first.numero_de_documento.to_s + ", clave " + novedades.first.clave_de_beneficiario.to_s +
                (novedades.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
                novedades.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
              )
              return false
            end
          end

          # Verificar si existe en la tabla de afiliados otro beneficiario con el mismo nombre, apellido y fecha de nacimiento
          # que no esté marcado ya como duplicado
          afiliados =
            Afiliado.where(
              "apellido = ? AND nombre = ? AND fecha_de_nacimiento = ?
              AND (motivo_de_la_baja_id IS NULL OR motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))",
              apellido, nombre, fecha_de_nacimiento
            )
          if (afiliados || []).size > 0
            errors.add(:base,
              "No se puede crear la solicitud porque ya existe " +
              (afiliados.first.sexo && afiliados.first.sexo.codigo == "F" ? "una beneficiaria" : "un beneficiario") +
              " con el mismo nombre, apellido y fecha de nacimiento: " + afiliados.first.apellido.to_s + ", " +
              afiliados.first.nombre.to_s + ", " +
              (afiliados.first.tipo_de_documento ? afiliados.first.tipo_de_documento.codigo + " " : "") +
              afiliados.first.numero_de_documento.to_s + ", clave " + afiliados.first.clave_de_beneficiario.to_s +
              (afiliados.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
              afiliados.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
            )
            return false
          end

          # Verificar si existe en la tabla de novedades otro beneficiario con el mismo nombre, apellido y fecha de nacimiento
          # que esté pendiente
          novedades =
            NovedadDelAfiliado.where(
              "apellido = ? AND nombre = ? AND fecha_de_nacimiento = ? AND estado_de_la_novedad_id IN (?)
               AND tipo_de_novedad_id IN (?)", apellido, nombre,
              fecha_de_nacimiento.strftime("%Y-%m-%d"), [1,2], (es_una_baja? ? [1,2] : [1,3])
            )
          if novedades.size > 0
            errors.add(:base,
              "No se puede crear la solicitud porque ya existe otra solicitud pendiente con el mismo nombre, apellido y" +
              " fecha de nacimiento: " + novedades.first.apellido.to_s + ", " + novedades.first.nombre.to_s +
              ", " + (novedades.first.tipo_de_documento ? novedades.first.tipo_de_documento.codigo + " " : "") +
              novedades.first.numero_de_documento.to_s + ", clave " + novedades.first.clave_de_beneficiario.to_s +
              (novedades.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
              novedades.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
            )
            return false
          end
          novedades =
            eval("NovedadDelAfiliadoTemp#{PARTE.titleize}").where(
              "apellido = ? AND nombre = ? AND fecha_de_nacimiento = ? AND estado_de_la_novedad_id IN (?)
               AND tipo_de_novedad_id IN (?)", apellido, nombre,
              fecha_de_nacimiento.strftime("%Y-%m-%d"), [1,2], (es_una_baja? ? [1,2] : [1,3])
            )
          if novedades.size > 0
            errors.add(:base,
              "No se puede crear la solicitud porque ya existe otra solicitud pendiente con el mismo nombre, apellido y" +
              " fecha de nacimiento: " + novedades.first.apellido.to_s + ", " + novedades.first.nombre.to_s +
              ", " + (novedades.first.tipo_de_documento ? novedades.first.tipo_de_documento.codigo + " " : "") +
              novedades.first.numero_de_documento.to_s + ", clave " + novedades.first.clave_de_beneficiario.to_s +
              (novedades.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
              novedades.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
            )
            return false
          end

          # Verificación de duplicados con el número de documento de la madre (código 83)
          if !numero_de_documento_de_la_madre.blank?
            # Verificar si existe en la tabla de afiliados otro beneficiario con el mismo nombre, fecha de nacimiento y número de
            # documento de la madre que no esté marcado ya como duplicado
            afiliados =
              Afiliado.where(
                "nombre = ? AND fecha_de_nacimiento = ? AND numero_de_documento_de_la_madre = ?
                AND (motivo_de_la_baja_id IS NULL OR motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))",
                nombre, fecha_de_nacimiento, numero_de_documento_de_la_madre
              )
            if (afiliados || []).size > 0
              errors.add(:base,
                "No se puede crear la solicitud porque ya existe " +
                (afiliados.first.sexo && afiliados.first.sexo.codigo == "F" ? "una beneficiaria" : "un beneficiario") +
                " con el mismo nombre, fecha de nacimiento y número de documento de la madre: " + afiliados.first.apellido.to_s +
                ", " + afiliados.first.nombre.to_s + ", " +
                (afiliados.first.tipo_de_documento ? afiliados.first.tipo_de_documento.codigo + " " : "") +
                afiliados.first.numero_de_documento.to_s + ", clave " + afiliados.first.clave_de_beneficiario.to_s +
                (afiliados.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
                afiliados.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
              )
              return false
            end

            # Verificar si existe en la tabla de novedades otro beneficiario con el mismo nombre, fecha de nacimiento y número de
            # documento de la madre que esté pendiente
            novedades =
              NovedadDelAfiliado.where(
                "nombre = ? AND fecha_de_nacimiento = ? AND numero_de_documento_de_la_madre = ? AND estado_de_la_novedad_id IN (?)
                 AND tipo_de_novedad_id IN (?)", nombre, fecha_de_nacimiento.strftime("%Y-%m-%d"), numero_de_documento_de_la_madre,
                [1,2], (es_una_baja? ? [1,2] : [1,3])
              )
            if novedades.size > 0
              errors.add(:base,
                "No se puede crear la solicitud porque ya existe otra solicitud pendiente con el mismo nombre, fecha de" +
                " nacimiento y número de documento de la madre: " + novedades.first.apellido.to_s + ", " + novedades.first.nombre.to_s +
                ", " + (novedades.first.tipo_de_documento ? novedades.first.tipo_de_documento.codigo + " " : "") +
                novedades.first.numero_de_documento.to_s + ", clave " + novedades.first.clave_de_beneficiario.to_s +
                (novedades.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
                novedades.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
              )
              return false
            end
            novedades =
              eval("NovedadDelAfiliadoTemp#{PARTE.titleize}").where(
                "nombre = ? AND fecha_de_nacimiento = ? AND numero_de_documento_de_la_madre = ? AND estado_de_la_novedad_id IN (?)
                 AND tipo_de_novedad_id IN (?)", nombre, fecha_de_nacimiento.strftime("%Y-%m-%d"), numero_de_documento_de_la_madre,
                [1,2], (es_una_baja? ? [1,2] : [1,3])
              )
            if novedades.size > 0
              errors.add(:base,
                "No se puede crear la solicitud porque ya existe otra solicitud pendiente con el mismo nombre, fecha de" +
                " nacimiento y número de documento de la madre: " + novedades.first.apellido.to_s + ", " + novedades.first.nombre.to_s +
                ", " + (novedades.first.tipo_de_documento ? novedades.first.tipo_de_documento.codigo + " " : "") +
                novedades.first.numero_de_documento.to_s + ", clave " + novedades.first.clave_de_beneficiario.to_s +
                (novedades.first.fecha_de_nacimiento ? ", fecha de nacimiento " +
                novedades.first.fecha_de_nacimiento.strftime("%d/%m/%Y") : "")
              )
              return false
            end
          end

          return true
        end

      })
    end
  end

  def procesar_archivo
    return unless @archivo_a_procesar.present? && @parte.present?

    ActiveRecord::Base.logger.silence do
      begin
        archivo = File.open(@archivo_a_procesar + "." + @parte, "r")
      rescue
        return
      end

      archivo.each_with_index do |linea, i|
        if !tiene_etiquetas_de_columnas || i != 0
          novedad = eval("NovedadDelAfiliadoTemp#{@parte.titleize}").new(parsear_linea(linea).merge!(
            :domicilio_numero => "-",
            :observaciones => "Inscripción registrada por importación de datos masivos",
            :lugar_de_atencion_habitual_id => efector_de_atencion_habitual.id
          ))
          novedad.generar_advertencias
          novedad.tipo_de_novedad_id = 1
          novedad.centro_de_inscripcion_id = @centro_de_inscripcion.id
          novedad.creator_id = 1
          novedad.updater_id = 1

          if !novedad.valid? || novedad.advertencias.size > 0
            novedad.persistido = false
            novedad.errores_y_advertencias = novedad.errors.full_messages.join(" - ") + (novedad.advertencias.size > 0 ? novedad.advertencias.join(" - ") : "")
  #          puts novedad.inspect
            novedad.estado_de_la_novedad_id = 1
            novedad.clave_de_beneficiario = "9999999999999999"
            novedad.save(:validate => false)
          else
            begin
              secuencia_siguiente =
                ActiveRecord::Base.connection.execute(
                  "SELECT nextval('uad_#{@unidad_de_alta_de_datos.codigo}.ci_#{@centro_de_inscripcion.codigo}_clave_seq'::regclass);"
                ).values[0][0].to_i
            rescue
              return
            end
            novedad.clave_de_beneficiario = '09' + @unidad_de_alta_de_datos.codigo + @centro_de_inscripcion.codigo + ('%06d' % secuencia_siguiente)
            novedad.categoria_de_afiliado_id = novedad.categorizar
            novedad.estado_de_la_novedad_id = 2
            novedad.persistido = true
  #          puts novedad.inspect
            novedad.save
          end
        end
      end
      archivo.close
    end
    archivo.close
  end

  def persistir_inscripciones
    ActiveRecord::Base.connection.execute "
      INSERT INTO uad_#{unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados
          (tipo_de_novedad_id, estado_de_la_novedad_id, clave_de_beneficiario, apellido, nombre, clase_de_documento_id,
          tipo_de_documento_id, numero_de_documento, categoria_de_afiliado_id, sexo_id, fecha_de_nacimiento, domicilio_calle,
          domicilio_numero, domicilio_departamento_id, domicilio_distrito_id, observaciones, lugar_de_atencion_habitual_id,
          apellido_de_la_madre, nombre_de_la_madre, tipo_de_documento_de_la_madre_id, numero_de_documento_de_la_madre,
          apellido_del_padre, nombre_del_padre, tipo_de_documento_del_padre_id, numero_de_documento_del_padre,
          apellido_del_tutor, nombre_del_tutor, tipo_de_documento_del_tutor_id, numero_de_documento_del_tutor,
          fecha_de_la_novedad, centro_de_inscripcion_id, nombre_del_agente_inscriptor, created_at, updated_at, creator_id,
          updater_id)
        SELECT
            tipo_de_novedad_id, estado_de_la_novedad_id, clave_de_beneficiario, apellido, nombre, clase_de_documento_id,
            tipo_de_documento_id, numero_de_documento, categoria_de_afiliado_id, sexo_id, fecha_de_nacimiento, domicilio_calle,
            domicilio_numero, domicilio_departamento_id, domicilio_distrito_id, observaciones, lugar_de_atencion_habitual_id,
            apellido_de_la_madre, nombre_de_la_madre, tipo_de_documento_de_la_madre_id, numero_de_documento_de_la_madre,
            apellido_del_padre, nombre_del_padre, tipo_de_documento_del_padre_id, numero_de_documento_del_padre,
            apellido_del_tutor, nombre_del_tutor, tipo_de_documento_del_tutor_id, numero_de_documento_del_tutor,
            fecha_de_la_novedad, centro_de_inscripcion_id, nombre_del_agente_inscriptor, created_at, updated_at, creator_id,
            updater_id
          FROM uad_#{unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp
          WHERE persistido;
    "
  end

  def persistir_inscripciones
    ActiveRecord::Base.connection.execute "
      INSERT INTO uad_#{@unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados
          (tipo_de_novedad_id, estado_de_la_novedad_id, clave_de_beneficiario, apellido, nombre, clase_de_documento_id,
          tipo_de_documento_id, numero_de_documento, categoria_de_afiliado_id, sexo_id, fecha_de_nacimiento, domicilio_calle,
          domicilio_numero, domicilio_departamento_id, domicilio_distrito_id, observaciones, lugar_de_atencion_habitual_id,
          apellido_de_la_madre, nombre_de_la_madre, tipo_de_documento_de_la_madre_id, numero_de_documento_de_la_madre,
          apellido_del_padre, nombre_del_padre, tipo_de_documento_del_padre_id, numero_de_documento_del_padre,
          apellido_del_tutor, nombre_del_tutor, tipo_de_documento_del_tutor_id, numero_de_documento_del_tutor,
          fecha_de_la_novedad, centro_de_inscripcion_id, nombre_del_agente_inscriptor, created_at, updated_at, creator_id,
          updater_id)
        SELECT
            tipo_de_novedad_id, estado_de_la_novedad_id, clave_de_beneficiario, apellido, nombre, clase_de_documento_id,
            tipo_de_documento_id, numero_de_documento, categoria_de_afiliado_id, sexo_id, fecha_de_nacimiento, domicilio_calle,
            domicilio_numero, domicilio_departamento_id, domicilio_distrito_id, observaciones, lugar_de_atencion_habitual_id,
            apellido_de_la_madre, nombre_de_la_madre, tipo_de_documento_de_la_madre_id, numero_de_documento_de_la_madre,
            apellido_del_padre, nombre_del_padre, tipo_de_documento_del_padre_id, numero_de_documento_del_padre,
            apellido_del_tutor, nombre_del_tutor, tipo_de_documento_del_tutor_id, numero_de_documento_del_tutor,
            fecha_de_la_novedad, centro_de_inscripcion_id, nombre_del_agente_inscriptor, created_at, updated_at, creator_id,
            updater_id
          FROM uad_#{@unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_#{@parte}
          WHERE persistido;
    "
  end

  def parsear_linea(linea)
    return nil unless linea

    campos = linea.gsub(/[\r\n]/, "").split("\t")

    return {
      :apellido => a_texto(campos[0]),
      :nombre => a_texto(campos[1]),
      :clase_de_documento_id => hash_a_id(hash_clases, campos[2]),
      :tipo_de_documento_id => hash_a_id(hash_tipos, campos[3]),
      :numero_de_documento => a_numero_de_documento(campos[4]),
      :sexo_id => hash_a_id(hash_sexos, campos[5]),
      :fecha_de_nacimiento => a_fecha(campos[6]),
      :es_menor => (a_fecha(campos[11]) && a_fecha(campos[6]) && ((a_fecha(campos[6]) + 10.years) > a_fecha(campos[11]))),
      :alfabetizacion_del_beneficiario_id => hash_a_id(hash_alfabetizacion, campos[7]),
      :domicilio_calle => a_texto(campos[8]),
      :domicilio_departamento_id => hash_a_id(hash_departamentos, campos[9]),
      :domicilio_distrito_id => a_distrito_id(hash_a_id(hash_departamentos, campos[9]), a_texto(campos[10])),
      :fecha_de_la_novedad => a_fecha(campos[11]),
      :nombre_del_agente_inscriptor => a_texto(campos[12]),
      :apellido_de_la_madre => (["1", "M", "m"].member?(a_texto(campos[13])) ? a_texto(campos[14]) : nil),
      :nombre_de_la_madre => (["1", "M", "m"].member?(a_texto(campos[13])) ? a_texto(campos[15]) : nil),
      :tipo_de_documento_de_la_madre_id => (["1", "M", "m"].member?(a_texto(campos[13])) ? hash_a_id(hash_tipos, campos[16]) : nil),
      :numero_de_documento_de_la_madre => (["1", "M", "m"].member?(a_texto(campos[13])) ? a_numero_de_documento(campos[17]) : nil),
      :apellido_del_padre => (["2", "P", "p"].member?(a_texto(campos[13])) ? a_texto(campos[14]) : nil),
      :nombre_del_padre => (["2", "P", "p"].member?(a_texto(campos[13])) ? a_texto(campos[15]) : nil),
      :tipo_de_documento_del_padre_id => (["2", "P", "p"].member?(a_texto(campos[13])) ? hash_a_id(hash_tipos, campos[16]) : nil),
      :numero_de_documento_del_padre => (["2", "P", "p"].member?(a_texto(campos[13])) ? a_numero_de_documento(campos[17]) : nil),
      :apellido_del_tutor => (["3", "T", "t"].member?(a_texto(campos[13])) ? a_texto(campos[14]) : nil),
      :nombre_del_tutor => (["3", "T", "t"].member?(a_texto(campos[13])) ? a_texto(campos[15]) : nil),
      :tipo_de_documento_del_tutor_id => (["3", "T", "t"].member?(a_texto(campos[13])) ? hash_a_id(hash_tipos, campos[16]) : nil),
      :numero_de_documento_del_tutor => (["3", "T", "t"].member?(a_texto(campos[13])) ? a_numero_de_documento(campos[17]) : nil)
    }
  end

  # TODO: cambiar esta función cavernícola por las otras más inteligentes "a_..." en el ApplicationController
  def a_texto(cadena)
    texto = cadena.to_s.strip.gsub(/  /, " ").gsub("NULL", "").mb_chars.upcase.to_s
    return (texto.blank? ? nil : texto)
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

  def hash_a_id(hash, cadena)
    texto = cadena.to_s.strip.gsub("NULL", "").upcase
    return nil if texto.blank?
    return texto.to_i if (texto.to_i > 0 && hash.values.member?(texto.to_i))
    return hash[texto]
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
