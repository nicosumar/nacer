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
    Departamento.where(:provincia_id => 9).each do |i|
      hash_alfabetizacion.merge! i.codigo => i.id
      hash_distritos.merge! i.id => Departamento.find(i.id).distritos.collect{ |d| {d.nombre => d.id} }
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
    return unless archivo_a_procesar

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
      :clase_de_documento_id => a_clase_de_documento_id(campos[2]),
      :tipo_de_documento_id => a_tipo_de_documento_id(campos[3]),
      :numero_de_documento => a_numero_de_documento(campos[4]),
      :sexo_id => a_sexo_id(campos[5]),
    }
  end

  # TODO: cambiar esta función cavernícola por las otras más inteligentes "a_..." en el ApplicationController
  def a_texto(cadena)
    texto = cadena.to_s.strip.gsub(/  /, " ").gsub("NULL", "").mb_chars.upcase.to_s
    return (texto.blank? ? nil : texto)
  end

  def a_clase_de_documento_id(cadena)
    texto = cadena.to_s.strip.gsub("NULL", "").upcase
    return nil if texto.blank?
    return texto.to_i if (texto.to_i > 0 && hash_clases.values.member?(texto.to_i))
    return hash_clases[texto]
  end

  def a_tipo_de_documento_id(cadena)
    texto = cadena.to_s.strip.gsub("NULL", "").upcase
    return nil if texto.blank?
    return texto.to_i if (texto.to_i > 0 && hash_tipos.values.member?(texto.to_i))
    return hash_tipos[texto]
  end

  def a_numero_de_documento(cadena)
    texto = cadena.to_s.strip.gsub(/[ ,.-]/, "").upcase
    return (texto.blank? ? nil : texto)
  end

  def a_sexo_id(cadena)
    texto = cadena.to_s.strip.gsub("NULL", "").upcase
    return nil if texto.blank?
    return texto.to_i if (texto.to_i > 0 && hash_sexos.values.member?(texto.to_i))
    return hash_sexos[texto]
  end


    # Cruzar datos de facturación mensual
    begin
      anio, mes = params[:anio_y_mes].split("-")
      primero_del_mes = Date.new(anio.to_i, mes.to_i, 1)
      primero_del_mes_siguiente = Date.new((mes == "12" ? anio.to_i + 1 : anio.to_i), (mes == "12" ? 1 : mes.to_i + 1), 1)
      origen = File.new("vendor/data/Facturación_#{params[:anio_y_mes]}.txt", "r")
      nomenclador = Nomenclador.find(params[:nomenclador_id], :include => {:asignaciones_de_precios => :prestacion})
      asignaciones_de_precios = {}
      nomenclador.asignaciones_de_precios.each do |asignacion|
        asignaciones_de_precios.merge! asignacion.prestacion.codigo => asignacion
      end
    rescue
      @errores_presentes = true
      @errores << "La fecha indicada es incorrecta, no se seleccionó un nomenclador, o no se encontró el archivo de la facturación."
      return
    end

    # ID necesarios para el cruce
    id_documento_propio = ClaseDeDocumento.id_del_codigo("P")

    # Cargar el hash de los periodos de actividad
    @periodos_de_actividad = {}
    PeriodoDeActividad.find_each do |p|
      if @periodos_de_actividad.has_key? p.afiliado_id
        @periodos_de_actividad[p.afiliado_id] += [{:inicio => p.fecha_de_inicio, :fin => p.fecha_de_finalizacion}]
      else
        @periodos_de_actividad.merge! p.afiliado_id => [{:inicio => p.fecha_de_inicio, :fin => p.fecha_de_finalizacion}]
      end
    end

    # Cargar el hash de los afiliados
    padron_de_afiliados = {}
    Afiliado.where("motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83) OR motivo_de_la_baja_id IS NULL").find_each do |af|
      if !af.numero_de_documento.blank?
        if padron_de_afiliados.has_key?(af.numero_de_documento)
          padron_de_afiliados[af.numero_de_documento] += [{
            :apellido => af.apellido, :nombre => af.nombre, :clase_de_documento => af.clase_de_documento_id,
            :activo => af.activo, :clave_de_beneficiario => af.clave_de_beneficiario, :tipo_de_documento => af.tipo_de_documento_id,
            :numero_de_documento => af.numero_de_documento, :afiliado_id => af.afiliado_id, :fecha_de_inscripcion => af.fecha_de_inscripcion
          }]
        else
          padron_de_afiliados.merge! af.numero_de_documento => [{
            :apellido => af.apellido, :nombre => af.nombre, :clase_de_documento => af.clase_de_documento_id,
            :activo => af.activo, :clave_de_beneficiario => af.clave_de_beneficiario, :tipo_de_documento => af.tipo_de_documento_id,
            :numero_de_documento => af.numero_de_documento, :afiliado_id => af.afiliado_id, :fecha_de_inscripcion => af.fecha_de_inscripcion
          }]
        end
      end

      if !af.numero_de_documento_de_la_madre.blank? &&
         (af.numero_de_documento.blank? || af.numero_de_documento != af.numero_de_documento_de_la_madre)
        if padron_de_afiliados.has_key?(af.numero_de_documento_de_la_madre)
          padron_de_afiliados[af.numero_de_documento_de_la_madre] += [{
            :apellido => af.apellido, :nombre => af.nombre, :clase_de_documento => af.clase_de_documento_id,
            :activo => af.activo, :clave_de_beneficiario => af.clave_de_beneficiario, :tipo_de_documento => af.tipo_de_documento_id,
            :numero_de_documento => af.numero_de_documento, :afiliado_id => af.afiliado_id, :fecha_de_inscripcion => af.fecha_de_inscripcion
          }]
        else
          padron_de_afiliados.merge! af.numero_de_documento_de_la_madre => [{
            :apellido => af.apellido, :nombre => af.nombre, :clase_de_documento => af.clase_de_documento_id,
            :activo => af.activo, :clave_de_beneficiario => af.clave_de_beneficiario, :tipo_de_documento => af.tipo_de_documento_id,
            :numero_de_documento => af.numero_de_documento, :afiliado_id => af.afiliado_id, :fecha_de_inscripcion => af.fecha_de_inscripcion
          }]
        end
      end

      if !af.numero_de_documento_del_padre.blank? &&
         (af.numero_de_documento.blank? || af.numero_de_documento != af.numero_de_documento_del_padre)
        if padron_de_afiliados.has_key?(af.numero_de_documento_del_padre)
          padron_de_afiliados[af.numero_de_documento_del_padre] += [{
            :apellido => af.apellido, :nombre => af.nombre, :clase_de_documento => af.clase_de_documento_id,
            :activo => af.activo, :clave_de_beneficiario => af.clave_de_beneficiario, :tipo_de_documento => af.tipo_de_documento_id,
            :numero_de_documento => af.numero_de_documento, :afiliado_id => af.afiliado_id, :fecha_de_inscripcion => af.fecha_de_inscripcion
          }]
        else
          padron_de_afiliados.merge! af.numero_de_documento_del_padre => [{
            :apellido => af.apellido, :nombre => af.nombre, :clase_de_documento => af.clase_de_documento_id,
            :activo => af.activo, :clave_de_beneficiario => af.clave_de_beneficiario, :tipo_de_documento => af.tipo_de_documento_id,
            :numero_de_documento => af.numero_de_documento, :afiliado_id => af.afiliado_id, :fecha_de_inscripcion => af.fecha_de_inscripcion
          }]
        end
      end

      if !af.numero_de_documento_del_tutor.blank? &&
         (af.numero_de_documento.blank? || af.numero_de_documento != af.numero_de_documento_del_tutor)
        if padron_de_afiliados.has_key?(af.numero_de_documento_del_tutor)
          padron_de_afiliados[af.numero_de_documento_del_tutor] += [{
            :apellido => af.apellido, :nombre => af.nombre, :clase_de_documento => af.clase_de_documento_id,
            :activo => af.activo, :clave_de_beneficiario => af.clave_de_beneficiario, :tipo_de_documento => af.tipo_de_documento_id,
            :numero_de_documento => af.numero_de_documento, :afiliado_id => af.afiliado_id, :fecha_de_inscripcion => af.fecha_de_inscripcion
          }]
        else
          padron_de_afiliados.merge! af.numero_de_documento_del_tutor => [{
            :apellido => af.apellido, :nombre => af.nombre, :clase_de_documento => af.clase_de_documento_id,
            :activo => af.activo, :clave_de_beneficiario => af.clave_de_beneficiario, :tipo_de_documento => af.tipo_de_documento_id,
            :numero_de_documento => af.numero_de_documento, :afiliado_id => af.afiliado_id, :fecha_de_inscripcion => af.fecha_de_inscripcion
          }]
        end
      end

    end

    # Procesar el archivo de prestaciones facturadas
    origen.each_with_index do |linea, i|
      prestacion = parsear_prestacion(linea)
      afiliado = nil
      case
        when !(prestacion[:fecha_prestacion] && prestacion[:fecha_prestacion].is_a?(Date))
          # Rechazar la prestación si el formato de la fecha es incorrecto
          prestacion.merge! :estado => :rechazada, :mensaje => "La fecha de la prestación no tiene un formato correcto."
          logger.warn "cruzar_facturacion: ADVERTENCIA, ocurrió un error. Datos de la prestación: #{prestacion.inspect}."
        when prestacion[:fecha_prestacion] >= primero_del_mes_siguiente
          # Rechazar la prestación si es posterior al periodo analizado
          prestacion.merge! :estado => :rechazada, :mensaje => "La fecha de la prestación es posterior al mes facturado."
          logger.warn "cruzar_facturacion: ADVERTENCIA, ocurrió un error. Datos de la prestación: #{prestacion.inspect}."
        #when prestacion[:fecha_prestacion] < (primero_del_mes - 5.months)
        #  prestacion.merge! :estado => :rechazada, :mensaje => "La prestación no puede pagarse porque se venció el periodo de pago."
        #  logger.warn "cruzar_facturacion: ADVERTENCIA, ocurrió un error. Datos de la prestación: #{prestacion.inspect}."
        #when !(asignaciones_de_precios.has_key?(prestacion[:codigo]))
        #  # Rechazar la prestación porque no se encontró el código de la prestación en el nomenclador
        #  prestacion.merge! :estado => :rechazada, :mensaje => "El código de la prestación no existe para el nomenclador seleccionado."
        #  logger.warn "cruzar_facturacion: ADVERTENCIA, ocurrió un error. Datos de la prestación: #{prestacion.inspect}."
        #when (asignaciones_de_precios[prestacion[:codigo]].adicional_por_prestacion == 0.0 &&
        #  asignaciones_de_precios[prestacion[:codigo]].precio_por_unidad != prestacion[:monto])
        #  # Rechazar la prestación porque no coincide el monto indicado
        #  prestacion.merge! :estado => :rechazada, :mensaje => "El monto de la prestación no coincide con el del nomenclador seleccionado."
        #  logger.warn "cruzar_facturacion: ADVERTENCIA, ocurrió un error. Datos de la prestación: #{prestacion.inspect}."
        else
          encontrados = []
          nivel_maximo = 1
          afiliados = (padron_de_afiliados[prestacion[:documento]] || [])
          nombre_y_apellido = (transformar_nombre(prestacion[:nombre]) || "")
          afiliados.each do |af|
            nivel_actual = 0
            apellido_afiliado = (transformar_nombre(af[:apellido]) || "")
            nombre_afiliado = (transformar_nombre(af[:nombre]) || "")

            # Verificar apellidos
            case
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
                nivel_actual *= 16 * nombre_afiliado.split(" ").size
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
              encontrados = [af]
            elsif nivel_actual == nivel_maximo
              encontrados << af
            end
          end
          afiliados = encontrados

          if afiliados && afiliados.size > 1
            # Se encontraron varios beneficiarios que cumplen los criterios de búsqueda, se mantiene el beneficiario que posee ese documento
            # propio, y (preferentemente) que esté activo, ya que existen dos casos posibles: si el documento de la prestación es propio,
            # manteniendo alguno de los registros devueltos con documento propio existen mejores probabilidades de seleccionar el registro
            # correcto, en caso contrario, con un documento ajeno, indica con altas probabilidades que se trata de un RN anotado con el documento
            # de la madre, y la prestación se le paga a ella.
            afiliados_con_documento_propio = []
            afiliados.each do |af|
              if af[:clase_de_documento] == id_documento_propio
                afiliados_con_documento_propio << af
              end
            end
            if afiliados_con_documento_propio.size == 0
              # Ninguno de los beneficiarios tenía documento propio, rechazar la prestación porque no está inscripto
              prestacion.merge! :estado => :rechazada, :mensaje => "No se encuentra al beneficiario."
            elsif afiliados_con_documento_propio.size > 1
              # No tan altamente improbable, dos registros con el mismo documento propio pero sin marcación de duplicados, mantener el que esté
              # activo, y si no hay ninguno activo, mantener el primero (igual será rechazado por no estar activo).
              afiliado_activo = nil
              afiliados_con_documento_propio.each do |af|
                if activo?(af, prestacion[:fecha_prestacion])
                  afiliado_activo = af
                  break
                end
              end
              if afiliado_activo
                afiliado = afiliado_activo
              else
                afiliado = afiliados_con_documento_propio.first
              end
            else
              # Un único afiliado posee ese documento propio, mantenerlo
              afiliado = afiliados_con_documento_propio.first
            end
          elsif afiliados && afiliados.size == 1
            # Se encontró un único beneficiario
            afiliado = afiliados.first
          else
            # No se encontró al beneficiario
            prestacion.merge! :estado => :rechazada, :mensaje => "No se encuentra al beneficiario."
          end
          if afiliado
            prestacion.merge! :clave_beneficiario => afiliado[:clave_de_beneficiario]
            if nivel_maximo >= 8
              # En caso de tener una buena coincidencia (supuestamente) cambiamos los datos del DNI, nombres, etc. por los registrados
              prestacion.merge! :apellido_afiliado => afiliado[:apellido], :nombre_afiliado => afiliado[:nombre],
                :tipo => afiliado[:tipo_de_documento], :clase => afiliado[:clase_de_documento], :documento => afiliado[:numero_de_documento]
            end
            case
              when (afiliado[:fecha_de_inscripcion] && prestacion[:fecha_prestacion] &&
                   afiliado[:fecha_de_inscripcion] > prestacion[:fecha_prestacion])
                # Rechazar la prestación porque la fecha de inscripción es posterior a la de prestación
                prestacion.merge! :estado => :rechazada, :mensaje => "La fecha de inscripción es posterior a la fecha de prestación."
                logger.warn "cruzar_facturacion: ADVERTENCIA, ocurrió un error. Datos de la prestación: #{prestacion.inspect}."
              when !(activo?(afiliado, prestacion[:fecha_prestacion]))
                # Rechazar la prestación porque el beneficiario aparece como inactivo para la fecha de prestación
                prestacion.merge! :estado => :rechazada, :mensaje => "El beneficiario no está activo."
              else
                # Prestación aceptada para el pago
                prestacion.merge! :estado => :aceptada, :mes_padron => padron_activo(afiliado, prestacion[:fecha_prestacion])
            end
          end
      end

      # Modificar el código de prestación si el precio de la misma puede ser variable, haciéndolo único
      if prestacion[:codigo] && asignaciones_de_precios[prestacion[:codigo]] &&
        asignaciones_de_precios[prestacion[:codigo]].adicional_por_prestacion != 0.0
        prestacion[:codigo] += " (" + i.to_s + ")"
      end

      # Almacenar el resultado en el hash
      guardar_resultado(prestacion)
    end   # origen.each
    origen.close

  end   # def cruzar_facturacion
