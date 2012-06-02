class PadronesController < ApplicationController
  before_filter :user_required

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
          @resultado = {}
          cruzar_facturacion
          escribir_resultados
        else
          @errores_presentes = true
          @errores << "Proceso no implementado"
      end
    else # no hay parámetros
      @procesos = [["Importación del padrón de afiliados", 1],
                   ["Cruce de la facturación", 2]]
      @proceso_id = 1
      @nomencladores = Nomenclador.find(:all).collect {|n| [n.nombre, n.id]}
    end
  end

  def escribir_resultados
    efectores_segun_cuie = {}
    Efector.find(:all).each do |efector|
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

  def cruzar_facturacion
    # Cruzar datos de facturación mensual
    begin
      año, mes = params[:año_y_mes].split("-")
      primero_del_mes = Date.new(año.to_i, mes.to_i, 1)
      primero_del_mes_siguiente = Date.new((mes == "12" ? año.to_i + 1 : año.to_i), (mes == "12" ? 1 : mes.to_i + 1), 1)
      origen = File.new("vendor/data/Facturación_#{params[:año_y_mes]}.txt", "r")
#      resultado = File.new("vendor/data/ResultadoDelCruce_#{params[:año_y_mes]}.txt", "w")  # BORRAME
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

    # Procesar el archivo de prestaciones facturadas
    origen.each_with_index do |linea, i|
      prestacion = parsear_prestacion(linea)
      afiliado = nil
      case
        when !(prestacion[:fecha_prestacion] && prestacion[:fecha_prestacion].is_a?(Date))
          # Rechazar la prestación si el formato de la fecha es incorrecto
          prestacion.merge! :estado => :rechazada, :mensaje => "La fecha de la prestación no tiene un formato correcto."
        when (prestacion[:fecha_prestacion] < primero_del_mes || prestacion[:fecha_prestacion] >= primero_del_mes_siguiente)
          # Rechazar la prestación si no está dentro del periodo facturado
          prestacion.merge! :estado => :rechazada, :mensaje => "La fecha de la prestación no se encuentra dentro del mes facturado."
        when !(asignaciones_de_precios.has_key?(prestacion[:codigo]))
          # Rechazar la prestación porque no se encontró el código de la prestación en el nomenclador
          prestacion.merge! :estado => :rechazada, :mensaje => "El código de la prestación no existe para el nomenclador seleccionado."
          puts prestacion
        when (asignaciones_de_precios[prestacion[:codigo]].adicional_por_prestacion == 0.0 &&
          asignaciones_de_precios[prestacion[:codigo]].precio_por_unidad != prestacion[:monto])
          # Rechazar la prestación porque no coincide el monto indicado
          prestacion.merge! :estado => :rechazada, :mensaje => "El monto de la prestación no coincide con el del nomenclador seleccionado."
        else
          afiliados, nivel_coincidencia = Afiliado.busqueda_por_aproximacion(prestacion[:documento], prestacion[:nombre])
          if afiliados && afiliados.size > 1
            # Se encontraron varios beneficiarios que cumplen los criterios de búsqueda, se mantiene el beneficiario que posee ese documento
            # propio, y (preferentemente) que esté activo, ya que existen dos casos posibles: si el documento de la prestación es propio,
            # manteniendo alguno de los registros devueltos con documento propio existen mejores probabilidades de seleccionar el registro
            # correcto, en caso contrario, con un documento ajeno, indica con altas probabilidades que se trata de un RN anotado con el documento
            # de la madre, y la prestación se le paga a ella.
            afiliados_con_documento_propio = []
            afiliados.each do |afiliado|
              if afiliado.clase_de_documento.upcase == "P"
                afiliados_con_documento_propio << afiliado
              end
            end
            if afiliados_con_documento_propio.size == 0
              # Ninguno de los beneficiarios tenía documento propio, rechazar la prestación porque no está inscripto
              prestacion.merge! :estado => :rechazada, :mensaje => "No se encuentra al beneficiario."
            elsif afiliados_con_documento_propio.size > 1
              # Altamente improbable, dos registros con el mismo documento propio pero sin marcación de duplicados, mantener el que esté
              # activo, y si no hay ninguno activo, mantener el primero (igual será rechazado por no estar activo).
              afiliado_activo = nil
              afiliados_con_documento_propio.each do |afiliado|
                if afiliado.activo?(prestacion[:fecha_prestacion])
                  afiliado_activo = afiliado
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
            prestacion.merge! :clave_beneficiario => afiliado.clave_de_beneficiario
            if nivel_coincidencia >= 8
              # En caso de tener una buena coincidencia (supuestamente) cambiamos los datos del DNI, nombres, etc. por los registrados
              prestacion.merge! :apellido_afiliado => afiliado.apellido, :nombre_afiliado => afiliado.nombre, :tipo => afiliado.tipo_de_documento,
                :clase => afiliado.clase_de_documento, :documento => afiliado.numero_de_documento
            end
            case
              when !(afiliado.inscripto?(prestacion[:fecha_prestacion]))
                # Rechazar la prestación porque la fecha de inscripción es posterior a la de prestación
                prestacion.merge! :estado => :rechazada, :mensaje => "La fecha de inscripción es posterior a la fecha de prestación."
              when !(afiliado.activo?(prestacion[:fecha_prestacion]))
                # Rechazar la prestación porque el beneficiario aparece como activo para la fecha de prestación
                prestacion.merge! :estado => :rechazada, :mensaje => "El beneficiario no está activo."
              when !(afiliado.categorias(prestacion[:fecha_prestacion]).any? {|c| (CategoriaDeAfiliado.find(c).prestaciones.collect {|p| p.codigo}).member? prestacion[:codigo]})
                # TODO: Cambiar todo el esquema de validación de categorías por otro que tenga en cuenta otras propiedades del usuario (edad, sexo, etc.)
                # Rechazar la prestación porque la categoría del beneficiario no condice con la prestación para la fecha en que se realizó
                prestacion.merge! :estado => :rechazada, :mensaje => "La categoría del beneficiario no condice con la prestación.", :categorias => afiliado.categorias
              else
                # Prestación aceptada para el pago
                prestacion.merge! :estado => :aceptada, :mes_padron => afiliado.padron_activo(prestacion[:fecha_prestacion])
            end
          end
      end

      # Modificar el código de prestación si el precio de la misma puede ser variable, haciéndolo único
      if asignaciones_de_precios[prestacion[:codigo]].adicional_por_prestacion != 0.0
        prestacion[:codigo] += " (" + i.to_s + ")"
      end

      # Almacenar el resultado en el hash
      guardar_resultado(prestacion)
#      resultado.puts((prestacion.collect {|d| d[0].to_s + " => " + d[1].to_s }).join(" | ")) # BORRAME
#      resultado.flush # BORRAME
    end   # origen.each
    origen.close
#    resultado.close #BORRAME

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
              :nro_foja => valor(campos[2], :entero),
              :fecha_prestacion => valor(campos[3], :fecha),
              :nombre => valor(campos[4], :texto),
              :clase => valor(campos[5], :texto) == "R" ? "P" : "A",
              :tipo => valor(campos[6], :texto),
              :documento => valor(campos[7], :texto),
              :historia_clinica => valor(campos[8], :texto),
              :codigo => valor(campos[9], :texto),
              :monto => valor(campos[10], :decimal) }
  end

  # TODO: cambiar esta función cavernícola por las otras más inteligentes "a_..." en el ApplicationController
  def valor(texto, tipo)

    texto.strip!

    begin
      case
        when tipo == :texto
          return "" if texto == "NULL"
          return texto.gsub(/  /, " ").upcase
        when tipo == :entero
          return 0 if texto == "NULL"
          return texto.to_i
        when tipo == :fecha
          # TODO: Añadir verificaciones para otros formatos de fecha
          return nil if texto == "NULL"
          año, mes, dia = texto.split("-")
          return Date.new(año.to_i, mes.to_i, dia.to_i)
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
      año, mes = params[:año_y_mes].split("-")
      primero_del_mes = Date.new(año.to_i, mes.to_i, 1)
      origen = File.new("vendor/data/#{params[:año_y_mes]}.txt.diff", "r")
    rescue
      @errores_presentes = true
      @errores << "La fecha indicada del padrón es incorrecta, o no se subió el archivo a la carpeta correcta del servidor."
    end

    origen.each do |linea|
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
        afiliado.afiliado_id = atr_afiliado[:afiliado_id]
        if afiliado.save
          # Como el afiliado es nuevo, tenemos que agregar un registro a la tabla de 'periodos_activos' si está ACTIVO
          if afiliado.activo == "S"
            PeriodoDeActividad.create({:afiliado_id => afiliado.afiliado_id,
              :fecha_de_inicio => primero_del_mes,
              :fecha_de_finalizacion => nil
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
          end
          if afiliado.activo == "S"
            if periodo.nil?
              # Reactivar el beneficiario
              PeriodoDeActividad.create({:afiliado_id => afiliado.afiliado_id,
                :fecha_de_inicio => primero_del_mes,
                :fecha_de_finalizacion => nil
              })
            end
          else
            if periodo
              # Desactivar el beneficiario
              periodo.update_attributes({:fecha_de_finalizacion => primero_del_mes})
            end
          end
        else
          @errores_presentes = true
          afiliado.errors.full_messages.each do |e|
            @errores << "Afiliado " + afiliado.afiliado_id.to_s + ": " + e
          end
        end
      end
    end
  end

end
