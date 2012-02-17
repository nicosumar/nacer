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
    @resultado.each do |hash_administrador|
      aceptadas_por_efector = {}
      suma_aceptadas = 0.0
      rechazadas_por_efector = {}
      suma_rechazadas = 0.0
      listado_de_prestaciones = {}
      administrador = efectores_segun_cuie[hash_administrador[0]]
      archivo_salida = File.new("vendor/data/#{hash_administrador[0]} - #{administrador}.csv", "w")
      aceptadas = (hash_administrador[1].collect { |hash_efector| hash_efector[1][:aceptada]}).flatten
      rechazadas = (hash_administrador[1].collect { |hash_efector| hash_efector[1][:rechazada]}).flatten
      archivo_salida.puts "Aceptadas:"
      archivo_salida.puts "\tEfector\tFolio\tFecha\tApellidos\tNombres\tDocumento\tH. clínica\tCódigo prest.\tMonto\tMes padrón\tClave beneficiario"
      aceptadas.each do |prestacion|
        archivo_salida.puts "\t" + efectores_segun_cuie[prestacion[:efector]] +
                            "\t" + prestacion[:nro_foja].to_s +
                            "\t" + prestacion[:fecha_prestacion].strftime("%d/%m/%Y") +
                            "\t" + prestacion[:apellido_afiliado] +
                            "\t" + prestacion[:nombre_afiliado] +
                            "\t" + prestacion[:numero_documento] +
                            "\t" + prestacion[:historia_clinica] +
                            "\t" + prestacion[:codigo] +
                            "\t" + prestacion[:monto].to_s.gsub(".", ",") +
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
        suma_aceptadas += prestacion[:monto]
      end
      archivo_salida.puts "\t\t\t\t\t\t\t\t\t#{suma_aceptadas.to_s.gsub(".", ",")}"
      archivo_salida.puts
      archivo_salida.puts "Rechazadas:"
      archivo_salida.puts "\tEfector\tFolio\tFecha\tApellidos\tNombres\tDocumento\tH. clínica\tCódigo prest.\tMonto\tMes padrón\tClave beneficiario"
      rechazadas.each do |prestacion|
        archivo_salida.puts "\t" + efectores_segun_cuie[prestacion[:efector]] +
                            "\t" + prestacion[:nro_foja].to_s +
                            "\t" + prestacion[:fecha_prestacion].strftime("%d/%m/%Y") +
                            "\t" + (prestacion[:apellido_afiliado] ? prestacion[:apellido_afiliado] : prestacion[:nombre]) +
                            "\t" + (prestacion[:nombre_afiliado] ? prestacion[:nombre_afiliado] : "") +
                            "\t" + prestacion[:documento] +
                            "\t" + prestacion[:historia_clinica] +
                            "\t" + prestacion[:codigo] +
                            "\t" + prestacion[:monto].to_s.gsub(".", ",") +
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
        suma_rechazadas += prestacion[:monto]
      end
      archivo_salida.puts "\t\t\t\t\t\t\t\t\t#{suma_rechazadas.to_s.gsub(".", ",")}"
      archivo_salida.puts
      archivo_salida.puts "\t\t\t\t\t\t\t\t\t#{(suma_aceptadas + suma_rechazadas).to_s.gsub(".", ",")}"
      archivo_salida.puts
      archivo_salida.puts "Aceptadas:"
      archivo_salida.puts "S/nomenclador\t\t" + 
                          (aceptadas_por_efector.collect { |hash_efector| efectores_segun_cuie[hash_efector[0]] + "\t" }).join("\t")
      archivo_salida.puts "Prestación\tValor\t" + 
                          (aceptadas_por_efector.collect { |hash_efector| "Cantidad\tTotal" }).join("\t")
      (listado_de_prestaciones.collect { |prest| prest[0]}).sort.each do |prestacion|
        archivo_salida.puts prestacion + "\t" + listado_de_prestaciones[prestacion].to_s.gsub(".", ",") + "\t" +
                            (aceptadas_por_efector.collect { |efector| (efector[1].has_key?(prestacion) ?
                                                             efector[1][prestacion][1].to_s + "\t" +
                                                             (efector[1][prestacion][0] * efector[1][prestacion][1]).to_s.gsub(".", ",") :
                                                             "0\t0,00") }).join("\t")
      end
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
      archivo_salida.close
    end
  end

  def cruzar_facturacion
    # Cruzar datos de facturación mensual
    begin
      año, mes = params[:año_y_mes].split("-")
      primero_del_mes = Date.new(año.to_i, mes.to_i, 1)
      primero_del_mes_siguiente = Date.new((mes == "12" ? año.to_i + 1 : año.to_i), (mes == "12" ? 1 : mes.to_i + 1), 1)
      origen = File.new("vendor/data/Facturación_#{params[:año_y_mes]}.txt", "r")
      nomenclador = Nomenclador.find(params[:nomenclador_id], :include => {:asignaciones_de_precios => :prestacion})
      asignaciones_de_precios = {}
      nomenclador.asignaciones_de_precios.each do |asignacion|
        asignaciones_de_precios.merge! asignacion.prestacion.codigo => asignacion
      end
    rescue
      @errores_presentes = true
      @errores << "La fecha indicada es incorrecta, no se seleccionó el nomenclador, o no se encontró el archivo de la facturación."
      return
    end

    # Procesar el archivo de prestaciones facturadas
    origen.each do |linea|
      prestacion = parsear_prestacion(linea)
      case
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
        when (afiliados = Afiliado.busqueda_por_aproximacion(prestacion[:documento], prestacion[:nombre], prestacion[:clase]))
          if afiliados.size > 1
            # Se encontraron varios beneficiarios que cumplen los criterios de búsqueda
            prestacion.merge!(:estado => :rechazada,
                             :mensaje => "No se pudo individualizar al beneficiario entre: " +
                                         (afiliados.collect {|a| a.clave_de_beneficiario}).join(", ") + ".")
          else
            # Se encontró un único beneficiario
            afiliado = afiliados[0]
            prestacion.merge! :clave_beneficiario => afiliado.clave_de_beneficiario, :apellido_afiliado => afiliado.apellido,
                              :nombre_afiliado => afiliado.nombre, :tipo_documento => afiliado.tipo_de_documento,
                              :clase_documento => afiliado.clase_de_documento, :numero_documento => afiliado.numero_de_documento
            case
              when !(afiliado.inscripto?(prestacion[:fecha_prestacion]))
                # Rechazar la prestación porque la fecha de inscripción es posterior a la de prestación
                prestacion.merge! :estado => :rechazada, :mensaje => "La fecha de inscripción es posterior a la fecha de prestación."
              when !(afiliado.activo?(prestacion[:fecha_prestacion]))
                # Rechazar la prestación porque el beneficiario aparece como activo para la fecha de prestación
                prestacion.merge! :estado => :rechazada, :mensaje => "El beneficiario no está activo."
              when !(afiliado.categorias(prestacion[:fecha_prestacion]).any? {|c| (CategoriaDeAfiliado.find(c).prestaciones.collect {|p| p.codigo}).member? prestacion[:codigo]})
                # Rechazar la prestación porque la categoría del beneficiario no condice con la prestación para la fecha en que se realizó
                prestacion.merge! :estado => :rechazada, :mensaje => "La categoría del beneficiario no condice con la prestación.",
                                  :categorias => afiliado.categorias
              else
                # Prestación aceptada para el pago
                prestacion.merge! :estado => :aceptada, :mes_padron => afiliado.padron_activo(prestacion[:fecha_prestacion])
            end
          end
        else
          # No se encontró al beneficiario
          prestacion.merge! :estado => :rechazada, :mensaje => "No se encuentra al beneficiario."
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

  def valor(texto, tipo)

    texto.strip!

    begin
      case
        when tipo == :texto
          return "" if texto == "NULL"
          return texto.gsub(/  /, " ")
        when tipo == :entero
          return 0 if texto == "NULL"
          return texto.to_i
        when tipo == :fecha
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
      origen = File.new("vendor/data/#{params[:año_y_mes]}.txt", "r")
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
