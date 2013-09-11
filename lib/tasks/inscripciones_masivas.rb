# -*- encoding : utf-8 -*-

class InscripcionMasiva

  attr_accessor :archivo_a_procesar
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

  def initialize(uad = nil, ci = nil, efe = nil)
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
    @unidad_de_alta_de_datos = uad
    @centro_de_inscripcion = ci
    @efector_de_atencion_habitual = efe
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

  def procesar_archivo
    return unless archivo_a_procesar.present?

    begin
      archivo = File.open(archivo_a_procesar, "r")
    rescue
      return
    end

    ActiveRecord::Base.connection.schema_search_path = "uad_" + unidad_de_alta_de_datos.codigo + ", public"

    ActiveRecord::Base.connection.execute "
      DROP TABLE IF EXISTS novedades_de_los_afiliados_temp;
      CREATE TABLE novedades_de_los_afiliados_temp (LIKE novedades_de_los_afiliados);
      ALTER TABLE novedades_de_los_afiliados_temp ADD COLUMN persistido boolean;
      ALTER TABLE novedades_de_los_afiliados_temp ADD COLUMN errores_y_advertencias text;
      DROP SEQUENCE IF EXISTS uad_#{unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_id_seq;
      CREATE SEQUENCE uad_#{unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_id_seq;
      ALTER SEQUENCE uad_#{unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_id_seq
        OWNED BY uad_#{unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp.id;
      ALTER TABLE uad_#{unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp
        ALTER COLUMN id
        SET DEFAULT nextval('uad_#{unidad_de_alta_de_datos.codigo}.novedades_de_los_afiliados_temp_id_seq'::regclass);
    "

    if !Class::constants.member?(:NovedadDelAfiliadoTemp)
      Object.const_set("NovedadDelAfiliadoTemp", Class.new(NovedadDelAfiliado) { set_table_name :novedades_de_los_afiliados_temp })
    end

    archivo.each_with_index do |linea, i|
      if !tiene_etiquetas_de_columnas || i != 0
        novedad = NovedadDelAfiliadoTemp.new(parsear_linea(linea).merge!(
          :domicilio_numero => "-",
          :observaciones => "Inscripción registrada por importación de datos masivos",
          :lugar_de_atencion_habitual_id => efector_de_atencion_habitual.id
        ))
        novedad.generar_advertencias
        novedad.tipo_de_novedad_id = 1
        novedad.centro_de_inscripcion_id = centro_de_inscripcion.id
        novedad.creator_id = 1
        novedad.updater_id = 1

        if !novedad.valid? || novedad.advertencias.size > 0
          novedad.persistido = false
          novedad.errores_y_advertencias = novedad.errors.full_messages.join("\n")
#          puts novedad.inspect
          novedad.estado_de_la_novedad_id = 1
          novedad.clave_de_beneficiario = "9999999999999999"
          novedad.save(:validate => false)
        else
          begin
            secuencia_siguiente =
              ActiveRecord::Base.connection.execute(
                "SELECT nextval('uad_#{unidad_de_alta_de_datos.codigo}.ci_#{centro_de_inscripcion.codigo}_clave_seq'::regclass);"
              ).values[0][0].to_i
          rescue
            return
          end
          novedad.clave_de_beneficiario = ('%02d' % Parametro.valor_del_parametro(:id_de_esta_provincia)) + unidad_de_alta_de_datos.codigo + centro_de_inscripcion.codigo + ('%06d' % secuencia_siguiente)
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
      :alfabetizacion_del_beneficiario_id => hash_a_id(hash_alfabetizacion, campos[7]),
      :domicilio_calle => a_texto(campos[8]),
      :domicilio_departamento_id => hash_a_id(hash_departamentos, campos[9]),
      :domicilio_distrito_id => a_distrito_id(hash_a_id(hash_departamentos, campos[9]), a_texto(campos[10])),
      :fecha_de_la_novedad => a_fecha(campos[11]),
      :nombre_del_agente_inscriptor => a_texto(campos[12]),
      :apellido_de_la_madre => ([1, "M", "m"].member?(a_texto(campos[13])) ? a_texto(campos[14]) : nil),
      :nombre_de_la_madre => ([1, "M", "m"].member?(a_texto(campos[13])) ? a_texto(campos[15]) : nil),
      :tipo_de_documento_de_la_madre_id => ([1, "M", "m"].member?(a_texto(campos[13])) ? hash_a_id(hash_tipos, campos[16]) : nil),
      :numero_de_documento_de_la_madre => ([1, "M", "m"].member?(a_texto(campos[13])) ? a_numero_de_documento(campos[17]) : nil),
      :apellido_del_padre => ([2, "P", "p"].member?(a_texto(campos[13])) ? a_texto(campos[14]) : nil),
      :nombre_del_padre => ([2, "P", "p"].member?(a_texto(campos[13])) ? a_texto(campos[15]) : nil),
      :tipo_de_documento_del_padre_id => ([2, "P", "p"].member?(a_texto(campos[13])) ? hash_a_id(hash_tipos, campos[16]) : nil),
      :numero_de_documento_del_padre => ([2, "P", "p"].member?(a_texto(campos[13])) ? a_numero_de_documento(campos[17]) : nil),
      :apellido_del_tutor => ([3, "T", "t"].member?(a_texto(campos[13])) ? a_texto(campos[14]) : nil),
      :nombre_del_tutor => ([3, "T", "t"].member?(a_texto(campos[13])) ? a_texto(campos[15]) : nil),
      :tipo_de_documento_del_tutor_id => ([3, "T", "t"].member?(a_texto(campos[13])) ? hash_a_id(hash_tipos, campos[16]) : nil),
      :numero_de_documento_del_tutor => ([3, "T", "t"].member?(a_texto(campos[13])) ? a_numero_de_documento(campos[17]) : nil)
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

    distrito = Distrito.where("departamento_id = '#{departamento_id}' AND nombre ILIKE '#{cadena.mb_chars.upcase.to_s.strip}'").first
    return distrito ? distrito.id : nil
  end

end
