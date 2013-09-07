# -*- encoding : utf-8 -*-

class InscripcionMasiva

  attr_accessor :archivo_a_procesar
  attr_accessor :unidad_de_alta_de_datos
  attr_accessor :centro_de_inscripcion
  attr_accessor :efector_de_atencion_habitual
  attr_accessor :registros_leidos
  attr_accessor :tiene_etiquetas_de_columna
  attr_accessor :hash_clases
  attr_accessor :hash_tipos
  attr_accessor :hash_sexos
  attr_accessor :hash_alfabetizacion
  attr_accessor :hash_departamentos
  attr_accessor :hash_distritos

  def initialize
    @archivo_a_procesar = nil
    @unidad_de_alta_de_datos = UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual])
    if unidad_de_alta_de_datos.centros_de_inscripcion.size == 1
      @centro_de_inscripcion = unidad_de_alta_de_datos.centros_de_inscripcion.first
    else
      @centro_de_inscripcion = nil
    end
    if unidad_de_alta_de_datos.efectores.size == 1
      @efector_de_atencion_habitual = unidad_de_alta_de_datos.efectores.first
    else
      @efector_de_atencion_habitual = nil
    end
    @tiene_etiquetas_de_columna = false
    @hash_clases = {}
    @hash_tipos = {}
    @hash_sexos = {}
    @hash_alfabetizacion = {}
    @hash_departamentos = {}
    @hash_distritos = {}

    ClaseDeDocumento.find(:all).each do |i|
      hash_clases.merge! i.codigo => i.id
    end
    TipoDeDocumento.find(:all).each do |i|
      hash_tipos.merge! i.codigo => i.id
    end
    Sexo.find(:all).each do |i|
      hash_sexos.merge! i.codigo => i.id
    end
    NivelDeInstruccion.find(:all).each do |i|
      hash_alfabetizacion.merge! i.codigo => i.id
    end
    Departamento.where(:provincia_id => 9).each do |depto|
      hash_departamentos.merge! depto.codigo => depto.id
      hash_dist = {}
      depto.distritos.each do |dist|
        hash_dist.merge! dist.nombre => dist.id
      end
      hash_distritos.merge! depto.id => hash_dist
    end
  end

  def establecer_esquema(esquema = "public")
    ActiveRecord::Base.connection.schema_search_path = esquema
  end

  def crear_tabla_temporal
    ActiveRecord::Base.connection.execute "
      DROP TABLE IF EXISTS novedades_de_los_afiliados_temp;
      CREATE TEMPORARY TABLE novedades_de_los_afiliados_temp (LIKE novedades_de_los_afiliados);
    "

    if !Class::constants.member?(:NovedadDelAfiliadoTemp)
      Object.const_set("NovedadDelAfiliadoTemp", Class.new(NovedadDelAfiliado) { set_table_name :novedades_de_los_afiliados_temp })
    end
  end

  def procesar_archivo
    return unless archivo_a_procesar.present?

    begin
      archivo = File.open(archivo_a_procesar, "r")
    rescue
      return
    end

    archivo.each_with_index do |linea, i|
      if !tiene_etiquetas_de_columnas || linea != 0
        atributos = parsear_linea(linea)
      end
    end
  end

  def parsear_linea(linea)
    return nil unless linea

    campos = linea.gsub(/[\r\n]/, "").split("\t")
    return nil unless campos.size == 18

    return {
      :apellido => a_texto(campos[0]),
      :nombre => a_texto(campos[1]),
      :clase_de_documento_id => hash_a_id(hash_clases, campos[2]),
      :tipo_de_documento_id => hash_a_id(hash_tipos, campos[3]),
      :numero_de_documento => a_numero_de_documento(campos[4]),
      :sexo_id => hash_a_id(hash_sexos, campos[5]),
      :fecha_de_nacimiento => a_fecha(campos[6]),
      :alfabetizacion_del_beneficiario_id => hash_a_id(hash_alfabetizacion, campos[7]),
      :domicilio => a_texto(campos[8]),
      :departamento_id => hash_a_id(hash_departamentos, campos[9]),
      :distrito_id => a_distrito_id(hash_a_id(hash_departamentos, campos[9]), a_texto(campos[10]))
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
    texto = cadena.to_s.strip.gsub("NULL", "").upcase
    hash_distritos[departamento_id].each do |nombre,id|

    end
  end

end
