# -*- encoding : utf-8 -*-
class PadronesController < ApplicationController
  before_filter :authenticate_user!

  def index
    if not current_user.in_group?(:administradores)
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación."
      return
    end

    if params[:proceso_id]
      @procesado = true
      @errores_presentes = false
      @errores = []

      case
        when params[:proceso_id] == "1"
          actualizacion_del_padron
        when params[:proceso_id] == "2"
          actualizacion_de_las_novedades
        when params[:proceso_id] == "3"
          @resultado = {}
          cruzar_facturacion
          escribir_resultados
        when params[:proceso_id] == "4"
          resumen_para_el_cierre
        else
          @errores_presentes = true
          @errores << "Proceso no implementado"
      end
    else # no hay parámetros
      @procesos = [["Actualización del padrón de afiliados", 1],
                   ["Actualización de los estados de las novedades", 2],
                   ["Cruce de la facturación", 3],
                   ["Cierre del padrón", 4]]
      @proceso_id = 1
      @nomencladores = Nomenclador.find(:all).collect {|n| [n.nombre, n.id]}
    end
  end

  def escribir_resultados
    efectores_segun_cuie = {}
    Efector.unscoped.find(:all).each do |efector|
      efectores_segun_cuie.merge! efector.cuie => efector.nombre
    end
    archivo_sumas = File.new("vendor/data/SUMAS.csv", "w")
    archivo_declaracion = File.new("vendor/data/DeclaraciónDePrestacionesFacturadas.csv", "w")
    suma_total_aceptadas = 0
    suma_total_rechazadas = 0
    archivo_sumas.puts "CUIE\tEfector\tMonto total entregado\tMonto rechazado\tMonto aceptado para liquidar"
    archivo_sumas.puts
    aceptadas_por_administrador = {}
    general_de_prestaciones = {}
    @resultado.each do |hash_administrador|
      aceptadas_por_efector = {}
      suma_aceptadas = 0.0
      rechazadas_por_efector = {}
      suma_rechazadas = 0.0
      listado_de_prestaciones = {}
      listado_de_efectores = {}
      administrador = efectores_segun_cuie[hash_administrador[0]]
      archivo_salida = File.new("vendor/data/#{hash_administrador[0]} - #{administrador}.csv", "w")
      aceptadas = (hash_administrador[1].collect { |hash_efector| hash_efector[1][:aceptada]}).flatten
      rechazadas = (hash_administrador[1].collect { |hash_efector| hash_efector[1][:rechazada]}).flatten
      archivo_salida.puts "Aceptadas:"
      archivo_salida.puts "CUIE\tEfector\tFolio\tFecha\tApellidos\tNombres\tDocumento\tH. clínica\tCódigo prest.\tMonto\tMes padrón\tClave beneficiario"
      aceptadas.each do |prestacion|
        archivo_salida.puts prestacion[:efector] +
                            "\t" + efectores_segun_cuie[prestacion[:efector]] +
                            "\t" + prestacion[:nro_foja].to_s +
                            "\t" + (prestacion[:fecha_prestacion] && prestacion[:fecha_prestacion].is_a?(Date) ?
                                    prestacion[:fecha_prestacion].strftime("%d/%m/%Y") : "") +
                            "\t" + (prestacion[:apellido_afiliado] ? prestacion[:apellido_afiliado] : prestacion[:nombre]) +
                            "\t" + (prestacion[:nombre_afiliado] ? prestacion[:nombre_afiliado] : "") +
                            "\t" + prestacion[:documento] +
                            "\t" + prestacion[:historia_clinica] +
                            "\t" + prestacion[:codigo] +
                            "\t" + ("%.2f" % prestacion[:monto]).gsub(".", ",") +
                            "\t" + prestacion[:mes_padron] +
                            "\t" + prestacion[:clave_beneficiario]
        if aceptadas_por_efector.has_key? prestacion[:efector]
          if aceptadas_por_efector[prestacion[:efector]].has_key? prestacion[:codigo]
            aceptadas_por_efector[prestacion[:efector]][prestacion[:codigo]][1] += 1
          else
            aceptadas_por_efector[prestacion[:efector]].merge! prestacion[:codigo] => [prestacion[:monto], 1]
          end
        else
          aceptadas_por_efector.merge! prestacion[:efector] => { prestacion[:codigo] => [prestacion[:monto], 1]}
        end
        listado_de_prestaciones.merge! prestacion[:codigo] => prestacion[:monto] unless listado_de_prestaciones.has_key? prestacion[:codigo]
        listado_de_efectores.merge! prestacion[:efector] => efectores_segun_cuie[prestacion[:efector]] unless listado_de_efectores.has_key? prestacion[:efector]
        suma_aceptadas += prestacion[:monto]
        if aceptadas_por_administrador.has_key? hash_administrador[0]
          if aceptadas_por_administrador[hash_administrador[0]].has_key? prestacion[:codigo]
            aceptadas_por_administrador[hash_administrador[0]][prestacion[:codigo]][1] += 1
          else
            aceptadas_por_administrador[hash_administrador[0]].merge! prestacion[:codigo] => [prestacion[:monto], 1]
          end
        else
          aceptadas_por_administrador.merge! hash_administrador[0] => { prestacion[:codigo] => [prestacion[:monto], 1]}
        end
        general_de_prestaciones.merge! prestacion[:codigo] => prestacion[:monto] unless general_de_prestaciones.has_key? prestacion[:codigo]
      end
      archivo_salida.puts "\t\t\t\t\t\t\t\t\t#{("%.2f" % suma_aceptadas).gsub(".", ",")}"
      archivo_salida.puts
      archivo_salida.puts "Rechazadas:"
      archivo_salida.puts "CUIE\tEfector\tFolio\tFecha\tApellidos\tNombres\tDocumento\tH. clínica\tCódigo prest.\tMonto\tMotivo de rechazo\tClave beneficiario"
      rechazadas.each do |prestacion|
        archivo_salida.puts prestacion[:efector] +
                            "\t" + efectores_segun_cuie[prestacion[:efector]] +
                            "\t" + prestacion[:nro_foja].to_s +
                            "\t" + (prestacion[:fecha_prestacion] && prestacion[:fecha_prestacion].is_a?(Date) ?
                                    prestacion[:fecha_prestacion].strftime("%d/%m/%Y") : "") +
                            "\t" + (prestacion[:apellido_afiliado] ? prestacion[:apellido_afiliado] : prestacion[:nombre]) +
                            "\t" + (prestacion[:nombre_afiliado] ? prestacion[:nombre_afiliado] : "") +
                            "\t" + prestacion[:documento] +
                            "\t" + prestacion[:historia_clinica] +
                            "\t" + prestacion[:codigo] +
                            "\t" + ("%.02f" % prestacion[:monto]).gsub(".", ",") +
                            "\t" + prestacion[:mensaje] +
                            "\t" + (prestacion[:clave_beneficiario] ? prestacion[:clave_beneficiario] : "")
        if rechazadas_por_efector.has_key? prestacion[:efector]
          if rechazadas_por_efector[prestacion[:efector]].has_key? prestacion[:codigo]
            rechazadas_por_efector[prestacion[:efector]][prestacion[:codigo]][1] += 1
          else
            rechazadas_por_efector[prestacion[:efector]].merge! prestacion[:codigo] => [prestacion[:monto], 1]
          end
        else
          rechazadas_por_efector.merge! prestacion[:efector] => { prestacion[:codigo] => [prestacion[:monto], 1]}
        end
        listado_de_prestaciones.merge! prestacion[:codigo] => prestacion[:monto] unless listado_de_prestaciones.has_key? prestacion[:codigo]
        listado_de_efectores.merge! prestacion[:efector] => efectores_segun_cuie[prestacion[:efector]] unless listado_de_efectores.has_key? prestacion[:efector]
        suma_rechazadas += prestacion[:monto]
#        general_de_prestaciones.merge! prestacion[:codigo] => prestacion[:monto] unless general_de_prestaciones.has_key? prestacion[:codigo]
      end
      archivo_salida.puts "\t\t\t\t\t\t\t\t\t#{("%.02f" % suma_rechazadas).gsub(".", ",")}"
      archivo_salida.puts
      archivo_salida.puts "\t\t\t\t\t\t\t\t\t#{("%.02f" % (suma_aceptadas + suma_rechazadas)).gsub(".", ",")}"
      archivo_salida.puts
      archivo_salida.puts "Aceptadas:"
      archivo_salida.puts "S/nomenclador\t\t" +
                          (aceptadas_por_efector.collect { |hash_efector| efectores_segun_cuie[hash_efector[0]] + "\t" }).join("\t")
      archivo_salida.puts "Prestación\tValor\t" +
                          (aceptadas_por_efector.collect { |hash_efector| "Cantidad\tTotal" }).join("\t")
      (listado_de_prestaciones.collect { |prest| prest[0]}).sort.each do |prestacion|
        archivo_salida.puts prestacion + "\t" + ("%.02f" % listado_de_prestaciones[prestacion]).gsub(".", ",") + "\t" +
                            (aceptadas_por_efector.collect { |efector| (efector[1].has_key?(prestacion) ?
                                                             efector[1][prestacion][1].to_s + "\t" +
                                                             ("%.02f" % (efector[1][prestacion][0] * efector[1][prestacion][1])).gsub(".", ",") :
                                                             "0\t0,00") }).join("\t")
      end
      archivo_salida.puts "\t\t\t" +
        (aceptadas_por_efector.collect { |efector| ("%.02f" % ((efector[1].values.collect { |prest| prest[0] * prest[1] }).sum)).gsub(".", ",") }).join("\t\t") +
        "\t" + ("%.02f" % ((aceptadas_por_efector.collect { |efector| (efector[1].values.collect { |prest| prest[0] * prest[1] }).sum }).sum)).gsub(".", ",")
      archivo_salida.puts
      archivo_salida.puts
      archivo_salida.puts
      archivo_salida.puts "Rechazadas:"
      archivo_salida.puts "S/nomenclador\t\t" +
                          (rechazadas_por_efector.collect { |hash_efector| efectores_segun_cuie[hash_efector[0]] + "\t" }).join("\t")
      archivo_salida.puts "Prestación\tValor\t" +
                          (rechazadas_por_efector.collect { |hash_efector| "Cantidad\tTotal" }).join("\t")
      (listado_de_prestaciones.collect { |prest| prest[0]}).sort.each do |prestacion|
        archivo_salida.puts prestacion + "\t" + listado_de_prestaciones[prestacion].to_s.gsub(".", ",") + "\t" +
                            (rechazadas_por_efector.collect { |efector| (efector[1].has_key?(prestacion) ?
                                                              efector[1][prestacion][1].to_s + "\t" +
                                                              (efector[1][prestacion][0] * efector[1][prestacion][1]).to_s.gsub(".", ",") :
                                                              "0\t0,00") }).join("\t")
      end
      archivo_salida.puts "\t\t\t" +
        (rechazadas_por_efector.collect { |efector| ("%.02f" % ((efector[1].values.collect { |prest| prest[0] * prest[1] }).sum)).gsub(".", ",") }).join("\t\t") +
        "\t" + ("%.02f" % ((rechazadas_por_efector.collect { |efector| (efector[1].values.collect { |prest| prest[0] * prest[1] }).sum }).sum)).gsub(".", ",")
      archivo_salida.close

      # Registrar totales por efector en el archivo de salida SUMAS.csv
      archivo_sumas.puts "#{hash_administrador[0]} - #{administrador}"
      (listado_de_efectores.collect {|efector| efector[0]}).sort.each do |efector|
        if aceptadas_por_efector[efector]
          acep = (aceptadas_por_efector[efector].collect { |prestacion| (prestacion[1][0]).to_f * (prestacion[1][1]).to_f }).sum
        else
          acep = 0.0
        end
        if rechazadas_por_efector[efector]
          rech = (rechazadas_por_efector[efector].collect { |prestacion| (prestacion[1][0]).to_f * (prestacion[1][1]).to_f }).sum
        else
          rech = 0.0
        end
        archivo_sumas.puts "#{efector}\t#{listado_de_efectores[efector]}\t#{("%.02f" % (acep + rech)).gsub(".", ",")}\t#{("%.02f" % rech).gsub(".", ",")}\t#{("%.02f" % acep).gsub(".", ",")}"
      end
      archivo_sumas.puts "Subtotal (#{administrador})\t\t#{("%.02f" % (suma_aceptadas + suma_rechazadas)).gsub(".", ",")}\t#{("%.02f" % suma_rechazadas).gsub(".", ",")}\t#{("%.02f" % suma_aceptadas).gsub(".", ",")}\n"
      archivo_sumas.puts
      suma_total_aceptadas += suma_aceptadas
      suma_total_rechazadas += suma_rechazadas
    end
    archivo_sumas.puts
    archivo_sumas.puts "TOTALES\t\t#{("%.02f" % (suma_total_aceptadas + suma_total_rechazadas)).gsub(".", ",")}\t#{("%.02f" % suma_total_rechazadas).gsub(".", ",")}\t#{("%.02f" % suma_total_aceptadas).gsub(".", ",")}"
    archivo_sumas.close

    archivo_declaracion.puts "Código de prestación\tValor\tTOTALES\t\t" +
      (aceptadas_por_administrador.collect { |hash_administrador| efectores_segun_cuie[hash_administrador[0]] + "\t" }).join("\t")
    archivo_declaracion.puts "\t\tCantidad\tTotal\t" +
      (aceptadas_por_administrador.collect { |hash_administrador| "Cantidad\tTotal" }).join("\t")
    (general_de_prestaciones.collect { |prest| prest[0]}).sort.each do |prestacion|
      archivo_declaracion.puts prestacion + "\t" + ("%.02f" % general_de_prestaciones[prestacion]).gsub(".", ",") + "\t" +
        (aceptadas_por_administrador.collect { |administrador| (administrador[1].has_key?(prestacion) ?
          administrador[1][prestacion][1] : 0) }).sum.to_s + "\t" +
        ("%.02f" % (aceptadas_por_administrador.collect { |administrador| (administrador[1].has_key?(prestacion) ?
          administrador[1][prestacion][0].to_f * administrador[1][prestacion][1] : 0.0) }).sum).gsub(".", ",") + "\t" +
        (aceptadas_por_administrador.collect { |administrador| (administrador[1].has_key?(prestacion) ?
          administrador[1][prestacion][1].to_s + "\t" +
          ("%.02f" % (administrador[1][prestacion][0] * administrador[1][prestacion][1])).gsub(".", ",") : "0\t0,00") }).join("\t")
    end
    archivo_declaracion.close
  end

  def transformar_nombre(nombre)
    return nil unless nombre
    normalizado = nombre.mb_chars.upcase.to_s.chomp
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

  # Indica si el afiliado estaba activo en el padrón correspondiente al mes y año de la fecha indicada, o
  # en alguno de los padrones de los dos meses siguientes (lapso ventana para la carga de la ficha de inscripción).
  # Si no se pasa una fecha, indica si figura como activo
  def activo?(afiliado, fecha = nil)
    # Devuelve 'true' si no se especifica una fecha y el campo 'activo' es 'S'
    return afiliado[:activo] unless fecha

    # Obtener los periodos de actividad de este afiliado
    periodos = (@periodos_de_actividad[afiliado[:afiliado_id]] || [])
    periodos.each do |p|
      # Tomamos como fecha de inicio del periodo la que sea mayor entre la inscripción y la fecha de inicio del periodo
      # desplazada tres meses antes (lapso ventana para la carga de la ficha de inscripción).
      inicio = [p[:inicio] - 3.months, afiliado[:fecha_de_inscripcion]].max
      if ( fecha >= inicio && (!p[:fin] || fecha < p[:fin]))
        return true
      end
    end
    return false
  end

  # Devuelve el mes y año del padrón donde aparece activo si el afiliado estaba activo en esa fecha
  # Esto puede ser el año y mes correspondiente al inicio del periodo de actividad, si estaba activo
  # en ese momento, o bien alguno de los dos meses siguientes (lapso ventana para la carga de la
  # ficha de inscripción).

  def padron_activo(afiliado, fecha = Date.today)
    return nil unless activo?(afiliado, fecha)

    # Obtener los periodos de actividad de este afiliado
    periodos = (@periodos_de_actividad[afiliado[:afiliado_id]] || [])
    periodos.each do |p|
      if (fecha >= [p[:inicio] - 3.months, afiliado[:fecha_de_inscripcion]].max) &&
         (!p[:fin] || fecha < p[:fin])
        return p[:inicio].strftime("%Y-%m")
      end
    end
  end

  def cruzar_facturacion
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

  def guardar_resultado(prestacion)
    if @resultado.has_key? prestacion[:administrador]
      if @resultado[prestacion[:administrador]].has_key? prestacion[:efector]
        if prestacion[:estado] == :aceptada
          @resultado[prestacion[:administrador]][prestacion[:efector]][:aceptada] << prestacion
        else
          @resultado[prestacion[:administrador]][prestacion[:efector]][:rechazada] << prestacion
        end
      else
        @resultado[prestacion[:administrador]].merge! prestacion[:efector] => (
          prestacion[:estado] == :aceptada ? { :aceptada => [prestacion], :rechazada => [] } : { :aceptada => [], :rechazada => [prestacion] })
      end
    else
      @resultado.merge! prestacion[:administrador] => { prestacion[:efector] => (
          prestacion[:estado] == :aceptada ? { :aceptada => [prestacion], :rechazada => [] } : { :aceptada => [], :rechazada => [prestacion] }) }
    end
  end

  # Parsear una línea de texto CSV que representa una prestación y devolver un Hash
  # etiquetado con el nombre de los campos
  def parsear_prestacion(linea)
    return nil unless linea

    campos = linea.gsub!(/[\r\n]/, "").split("\t")
    return {  :administrador => valor(campos[0], :texto),
              :efector => valor(campos[1], :texto),
              :nro_foja => valor(campos[2], :texto),
              :fecha_prestacion => valor(campos[3], :fecha),
              :nombre => valor(campos[4], :texto),
              :clase => valor(campos[5], :texto) == "R" ? "P" : "A",
              :tipo => valor(campos[6], :texto).gsub(/[ \.]/, ""),
              :documento => valor(campos[7], :texto).gsub(/[ \.]/, ""),
              :historia_clinica => valor(campos[8], :texto),
              :codigo => valor(campos[9], :texto).gsub(/[^[:alpha:][:digit:]\.]/,""),
              :monto => valor(campos[10], :decimal) }
  end

  # TODO: cambiar esta función cavernícola por las otras más inteligentes "a_..." en el ApplicationController
  def valor(texto, tipo)

    texto.to_s.strip!

    begin
      case
        when tipo == :texto
          return "" if texto == "NULL"
          return texto.gsub(/  /, " ").mb_chars.upcase.to_s
        when tipo == :texto_sql
          return "" if texto == "NULL"
          return ActiveRecord::Base.connection.quote(texto.gsub(/  /, " ").mb_chars.upcase.to_s)
        when tipo == :entero
          return 0 if texto == "NULL"
          return texto.to_i
        when tipo == :fecha
          # TODO: Añadir verificaciones para otros formatos de fecha
          return nil if texto == "NULL"
          anio, mes, dia = texto.split("-")
          if !mes || mes.strip.empty?
            dia, mes, anio = texto.split("/")
          end
          if anio.strip.to_i < 100
            anio = "20" + anio.strip
          end
          return Date.new(anio.to_i, mes.to_i, dia.to_i)
        when tipo == :decimal
          return 0.0 if texto == "NULL"
          return texto.gsub(/[\.\(\) $]/, "").gsub(",", ".").to_f
        else
          return nil
      end
    rescue
      return nil
    end

  end

  def actualizacion_del_padron
    # Actualización del padrón de afiliados
    begin
      anio, mes = params[:anio_y_mes].split("-")
      primero_del_mes = Date.new(anio.to_i, mes.to_i, 1)
      origen = File.new("vendor/data/#{params[:anio_y_mes]}.txt.diff#{!params[:multiparte].blank? ? '.part' + params[:multiparte] : ''}", "r")
    rescue
      @errores_presentes = true
      @errores << "La fecha indicada del padrón es incorrecta, o no se subieron los archivos a procesar dentro de la carpeta correcta del servidor."
      return
    end

    origen.each do |linea|
      # Hacemos la actualización dentro de una transacción
      ActiveRecord::Base.transaction do

        # Procesar la siguiente línea del archivo
        linea.gsub!(/[\r\n]+/, '')
        atr_afiliado = Afiliado.attr_hash_desde_texto(linea)
        afiliado_id = atr_afiliado[:afiliado_id]
        begin
          afiliado = Afiliado.find(afiliado_id)
        rescue
        end
        if afiliado.nil?
          # El afiliado no existe en la versión actual (ha sido agregado al padrón)
          afiliado = Afiliado.new(atr_afiliado)
          if afiliado.save
            # Como el afiliado es nuevo, tenemos que agregar un registro a la tabla de 'periodos_de_actividad' si está ACTIVO, a
            # la de 'periodos_de_cobertura' si tiene CEB, a la de 'periodos_de_capita' si devengó cápita, y a la de
            # 'periodos_de_embarazo' si es un embarazo actual
            if afiliado.activo
              PeriodoDeActividad.create({:afiliado_id => afiliado.afiliado_id,
                :fecha_de_inicio => afiliado.fecha_de_inscripcion,
                :fecha_de_finalizacion => nil
              })
            end
            if afiliado.cobertura_efectiva_basica
              PeriodoDeCobertura.create({:afiliado_id => afiliado.afiliado_id,
                :fecha_de_inicio => primero_del_mes,
                :fecha_de_finalizacion => nil
              })
            end
            if afiliado.activo && afiliado.devenga_capita
              PeriodoDeCapita.create({:afiliado_id => afiliado.afiliado_id,
                :fecha_de_inicio => primero_del_mes,
                :fecha_de_finalizacion => nil,
                :capitas_al_inicio => afiliado.devenga_cantidad_de_capitas
              })
            end
            if afiliado.embarazo_actual
              PeriodoDeEmbarazo.create({:afiliado_id => afiliado.afiliado_id,
                :fecha_de_inicio => primero_del_mes,
                :fecha_de_finalizacion => nil,
                :fecha_de_la_ultima_menstruacion => afiliado.fecha_de_la_ultima_menstruacion,
                :fecha_de_diagnostico_del_embarazo => afiliado.fecha_de_diagnostico_del_embarazo,
                :semanas_de_embarazo => afiliado.semanas_de_embarazo,
                :fecha_probable_de_parto => afiliado.fecha_probable_de_parto,
                :fecha_efectiva_de_parto => afiliado.fecha_efectiva_de_parto,
                :unidad_de_alta_de_datos_id => afiliado.unidad_de_alta_de_datos_id,
                :centro_de_inscripcion_id => afiliado.centro_de_inscripcion_id
              })
            end
          else
            @errores_presentes = true
            afiliado.errors.full_messages.each do |e|
              @errores << "Afiliado " + afiliado.afiliado_id.to_s + ": " + e
            end
          end
        else
          # El afiliado ya existe en la tabla, actualizar sus datos
          if afiliado.update_attributes(atr_afiliado)
            # Actualizar el periodo de actividad de este beneficiario
            begin
              periodo = PeriodoDeActividad.where("afiliado_id = '#{afiliado.afiliado_id}' AND fecha_de_finalizacion IS NULL").first
            rescue
              periodo = nil
            end
            if afiliado.activo
              if periodo.nil?
                # Activar el beneficiario
                PeriodoDeActividad.create({
                  :afiliado_id => afiliado.afiliado_id,
                  :fecha_de_inicio => primero_del_mes,
                  :fecha_de_finalizacion => nil
                })
              end
            else
              if periodo
                if periodo.fecha_de_inicio == primero_del_mes
                  # Eliminar el periodo (actualización de la información del mismo mes, el periodo no debía existir)
                  periodo.destroy
                else
                  # Desactivar el beneficiario
                  periodo.update_attributes({
                    :fecha_de_finalizacion => primero_del_mes,
                    :motivo_de_la_baja_id => afiliado.motivo_de_la_baja_id,
                    :mensaje_de_la_baja => afiliado.mensaje_de_la_baja
                  })
                end
              end
            end

            # Actualizar el periodo de cobertura efectiva básica
            begin
              periodo =
                PeriodoDeCobertura.where(
                  "afiliado_id = '#{afiliado.afiliado_id}'
                    AND (
                      fecha_de_finalizacion IS NULL
                      OR fecha_de_finalizacion > '#{(primero_del_mes - afiliado.devenga_cantidad_de_capitas.months).strftime("%Y/%m/%d")}'
                    )"
                ).first
            rescue
              periodo = nil
            end
            if afiliado.cobertura_efectiva_basica
              if periodo.nil?
                # Crear un nuevo periodo de cobertura
                PeriodoDeCobertura.create({
                  :afiliado_id => afiliado.afiliado_id,
                  :fecha_de_inicio => primero_del_mes,
                  :fecha_de_finalizacion => nil
                })
              else
                if !periodo.fecha_de_finalizacion.nil?
                  # Beneficiario que recupera CEB en forma retroactiva, eliminar la fecha de finalización
                  periodo.update_attributes({:fecha_de_finalizacion => nil})
                end
              end
            else
              if periodo
                if periodo.fecha_de_inicio == primero_del_mes
                  # Eliminar el periodo (actualización de la información del mismo mes, el periodo no debía existir)
                  periodo.destroy
                else
                  # Finalizar el periodo de cobertura
                  periodo.update_attributes({:fecha_de_finalizacion => primero_del_mes})
                end
              end
            end

            # Actualizar el periodo de devengamiento de cápitas
            begin
              periodo = PeriodoDeCapita.where("afiliado_id = '#{afiliado.afiliado_id}' AND fecha_de_finalizacion IS NULL").first
            rescue
              periodo = nil
            end
            if afiliado.devenga_capita
              if periodo.nil?
                # Crear un nuevo periodo de devengamiento de cápitas
                PeriodoDeCapita.create({
                  :afiliado_id => afiliado.afiliado_id,
                  :fecha_de_inicio => primero_del_mes,
                  :fecha_de_finalizacion => nil,
                  :capitas_al_inicio => afiliado.devenga_cantidad_de_capitas
                })
              end
            else
              if periodo
                if periodo.fecha_de_inicio == primero_del_mes
                  # Eliminar el periodo (actualización de la información del mismo mes, el periodo no debía existir)
                  periodo.destroy
                else
                  # Finalizar el periodo de devengamiento de cápitas
                  periodo.update_attributes({:fecha_de_finalizacion => primero_del_mes})
                end
              end
            end

            # Actualizar el periodo de embarazo
            begin
              periodo = PeriodoDeEmbarazo.where("afiliado_id = '#{afiliado.afiliado_id}' AND fecha_de_finalizacion IS NULL").first
            rescue
              periodo = nil
            end
            if afiliado.embarazo_actual
              if periodo.nil?
                # Crear un nuevo periodo de embarazo
                PeriodoDeEmbarazo.create({:afiliado_id => afiliado.afiliado_id,
                  :fecha_de_inicio => primero_del_mes,
                  :fecha_de_finalizacion => nil,
                  :fecha_de_la_ultima_menstruacion => afiliado.fecha_de_la_ultima_menstruacion,
                  :fecha_de_diagnostico_del_embarazo => afiliado.fecha_de_diagnostico_del_embarazo,
                  :semanas_de_embarazo => afiliado.semanas_de_embarazo,
                  :fecha_probable_de_parto => afiliado.fecha_probable_de_parto,
                  :fecha_efectiva_de_parto => afiliado.fecha_efectiva_de_parto,
                  :unidad_de_alta_de_datos_id => afiliado.unidad_de_alta_de_datos_id,
                  :centro_de_inscripcion_id => afiliado.centro_de_inscripcion_id
                })
              else
                # Recrear un nuevo periodo si se han modificado los datos del embarazo
                if ( periodo.fecha_de_la_ultima_menstruacion != afiliado.fecha_de_la_ultima_menstruacion ||
                     periodo.fecha_de_diagnostico_del_embarazo != afiliado.fecha_de_diagnostico_del_embarazo ||
                     periodo.semanas_de_embarazo != afiliado.semanas_de_embarazo ||
                     periodo.fecha_probable_de_parto != afiliado.fecha_probable_de_parto ||
                     periodo.fecha_efectiva_de_parto != afiliado.fecha_efectiva_de_parto )
                  periodo.update_attributes({:fecha_de_finalizacion => primero_del_mes})
                  PeriodoDeEmbarazo.create({:afiliado_id => afiliado.afiliado_id,
                    :fecha_de_inicio => primero_del_mes,
                    :fecha_de_finalizacion => nil,
                    :fecha_de_la_ultima_menstruacion => afiliado.fecha_de_la_ultima_menstruacion,
                    :fecha_de_diagnostico_del_embarazo => afiliado.fecha_de_diagnostico_del_embarazo,
                    :semanas_de_embarazo => afiliado.semanas_de_embarazo,
                    :fecha_probable_de_parto => afiliado.fecha_probable_de_parto,
                    :fecha_efectiva_de_parto => afiliado.fecha_efectiva_de_parto,
                    :unidad_de_alta_de_datos_id => afiliado.unidad_de_alta_de_datos_id,
                    :centro_de_inscripcion_id => afiliado.centro_de_inscripcion_id
                  })
                end
              end
            else
              if periodo
                if periodo.fecha_de_inicio == primero_del_mes
                  # Eliminar el periodo (actualización de la información del mismo mes, el periodo no debía existir)
                  periodo.destroy
                else
                  # Finalizar el periodo de devengamiento de cápitas
                  periodo.update_attributes({:fecha_de_finalizacion => primero_del_mes})
                end
              end
            end
          else
            @errores_presentes = true
            afiliado.errors.full_messages.each do |e|
              @errores << "Afiliado " + afiliado.afiliado_id.to_s + ": " + e
            end
          end
        end
      end # Base::connection.transaction
    end
    origen.close

  end

  def actualizacion_de_las_novedades
    # Actualización de las novedades del padrón cargadas por las UADS
    begin
      anio, mes = params[:anio_y_mes].split("-")
      primero_del_mes = Date.new(anio.to_i, mes.to_i, 1)
      origen = File.new("vendor/data/ActEstadoNovedades_#{params[:anio_y_mes]}.txt", "r")
    rescue
      @errores_presentes = true
      @errores << "La fecha indicada del padrón es incorrecta, o no se subieron los archivos a procesar dentro de la carpeta correcta del servidor."
      return
    end

    # Hacemos la actualización dentro de una transacción
    ActiveRecord::Base.transaction do

      # Procesamiento de la actualización del estado de las novedades
      esquema_actual = ActiveRecord::Base.connection.exec_query("SHOW search_path;").rows[0][0]
      ultima_uad = ''
      i=0
      origen.each do |linea|
        # Obtener la siguiente línea del archivo
        linea.gsub!(/[\r\n]+/, '')
        # Separar los campos
        campos = linea.split("\t")
        if i==0
          codigo_uad = valor(campos[0], :texto).gsub!(/[^0-9A-Za-z]/, '')
        else
          codigo_uad = valor(campos[0], :texto)#.gsub!(/[^0-9A-Za-z]/, '')
        end
        i += 1
        puts i
        # codigo_uad = valor(campos[0], :texto)#.gsub!(/[^0-9A-Za-z]/, '')
        id_de_novedad = valor(campos[1], :entero)
        aceptado = valor(campos[2], :texto).upcase
        activo = valor(campos[3], :texto).upcase
        mensaje_baja = valor(campos[5], :texto_sql)

        if codigo_uad != ultima_uad
          # La línea pertenece a una UAD distinta de la que veníamos procesando, cambiar la ruta de búsqueda de esquemas
          ActiveRecord::Base.connection.schema_search_path = "uad_#{codigo_uad},public"
          ActiveRecord::Base.connection.execute("SET search_path TO #{ActiveRecord::Base.connection.schema_search_path};")
          ultima_uad = codigo_uad
        end

        if aceptado == 'S'
          if activo == 'S'
            estado = EstadoDeLaNovedad.id_del_codigo("A")
          else
            estado = EstadoDeLaNovedad.id_del_codigo("N")
          end
        else
          estado = EstadoDeLaNovedad.id_del_codigo("Z")
        end
        ActiveRecord::Base.connection.execute "
          UPDATE uad_#{codigo_uad}.novedades_de_los_afiliados
            SET
              estado_de_la_novedad_id = #{estado},
              mes_y_anio_de_proceso = '#{primero_del_mes.strftime('%Y-%m-%d')}',
              mensaje_de_la_baja = #{mensaje_baja.blank? ? 'NULL' : mensaje_baja}
            WHERE id = '#{id_de_novedad}';
        "

      end
      origen.close
      ActiveRecord::Base.connection.schema_search_path = esquema_actual
      ActiveRecord::Base.connection.exec_query("SET search_path TO #{esquema_actual};")
    end
  end

  def resumen_para_el_cierre
    # Proceso de cierre del padrón y generación de archivos "A"
    begin
      anio, mes = params[:anio_y_mes].split("-")
      @primero_del_mes_siguiente = Date.new(anio.to_i, mes.to_i, 1) + 1.month
    rescue
      @errores_presentes = true
      @errores << "La fecha indicada de cierre del padrón es incorrecta."
    end

    # Primero generamos un resumen con todas las UADs que tengan datos para procesar
    @uads = []
    UnidadDeAltaDeDatos.where(:inscripcion => true).order(:codigo).each do |uad|
      novedades_a_procesar = uad.cantidad_de_novedades_para_procesar(@primero_del_mes_siguiente)
      if novedades_a_procesar > 0
        @uads << {:codigo => uad.codigo, :nombre => uad.nombre, :a_procesar => novedades_a_procesar}
      end
    end

    render "resumen"

  end

  def cierre
    if not current_user.in_group?(:administradores)
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación."
      return
    end

    # TODO: ¡¡¡Añadir verificaciones!!!
    anio, mes, dia = params[:primero_del_mes_siguiente].split("-")
    primero_del_mes_siguiente = Date.new(anio.to_i, mes.to_i, dia.to_i)
    uads_a_procesar = UnidadDeAltaDeDatos.where(:codigo => params[:uads_a_procesar].keys)

    @directorio = "vendor/data/cierre_padron_#{DateTime.now.strftime('%Y%m%d%H%M%S')}"
    Dir.mkdir(@directorio)

    @archivos_generados = []

    uads_a_procesar.each do |uad|
      uad.codigos_de_CIs_con_novedades(primero_del_mes_siguiente).each do |codigo_ci|
        archivo_generado = NovedadDelAfiliado.generar_archivo_a( uad.codigo, codigo_ci, primero_del_mes_siguiente, @directorio )
        @archivos_generados <<
          "UAD: #{uad.nombre} (#{uad.codigo}) - Centro de inscripción: #{CentroDeInscripcion.find_by_codigo(codigo_ci).nombre} " +
          "(#{codigo_ci}) => #{archivo_generado ? archivo_generado : 'ERROR'}"
      end
    end

  end

end
