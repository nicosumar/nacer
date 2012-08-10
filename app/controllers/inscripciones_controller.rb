class VerificadorController < ApplicationController
  before_filter :user_required

  def busqueda
    if not current_user.in_group?(:inscripción)
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación. Se ha notificado al administrador del sistema." 
      return
    end

    if params[:numero_de_documento]
      @procesado = true
      # TODO: Cambiar desde aquí, hay que buscar los afiliados por número de documento
      concordancia = /efector.*?(M[[:digit:]]+).*?\t*?/i.match(params[:facturacion])
      if concordancia
        @cuie_efector = concordancia[1].upcase
        @efector = Efector.find_by_cuie(@cuie_efector, :include => [:convenio_de_gestion, {:convenio_de_administracion => :administrador},
                {:asignaciones_de_nomenclador => :nomenclador}])
      end
      return unless @efector
      # Buscar el CUIE del administrador
      concordancia = /administrador.*?(M[[:digit:]]{5})/i.match(params[:facturacion])
      if concordancia
        @cuie_administrador = concordancia[1].upcase
        @administrador = Efector.find_by_cuie(@cuie_administrador)
      end
      # Buscar la fecha de presentación
      concordancia = /fecha.*?([[:digit:]]+)[^[:digit:]]+([[:digit:]]+)[^[:digit:]]([[:digit:]]+)/i.match(params[:facturacion])
      if concordancia
        dia, mes, año = concordancia[1,3]
        @texto_fecha = concordancia.to_s
        # Corregir años que no incluyan el siglo
        if año.size == 2 then año = "20" + año end
        begin # Intentar crear un objeto Date con los datos capturados
          @fecha = Date.new(año.to_i, mes.to_i, dia.to_i)
          rescue ArgumentError
            @fecha = nil # Si la fecha construida no es válida
        end
      end
      # Buscar el referente (director/encargado) del efector
      concordancia = /director.*?encargado.*?[^[:alpha:]]*?([[:alnum:]]+.*?)[\t\r\n]/i.match(params[:facturacion])
      if concordancia then @texto_referente = concordancia[1] end
      if @efector && (referente = Referente.actual_del_efector(@efector.id))
        @referente = Contacto.find(referente[:contacto_id])
      end

      # Determinar el mes facturado
      concordancia = /mes.*?prestaciones.*?[^[:alpha:]]*?([[:alpha:]]+).*?([[:digit:]]+)/i.match(params[:facturacion])
      if concordancia
        @texto_mes_de_prestaciones = concordancia.to_s
        mes = case
          when concordancia[1][0,1].upcase == "E" then 1    # E NERO
          when concordancia[1][0,1].upcase == "F" then 2    # F EBRERO
          when concordancia[1][0,3].upcase == "MAR" then 3  # MAR ZO
          when concordancia[1][0,2].upcase == "AB" then 4   # AB RIL
          when concordancia[1][0,3].upcase == "MAY" then 5  # MAY O
          when concordancia[1][0,3].upcase == "JUN" then 6  # JUN IO
          when concordancia[1][0,3].upcase == "JUL" then 7  # JUL IO
          when concordancia[1][0,2].upcase == "AG" then 8   # AG OSTO
          when concordancia[1][0,1].upcase == "S" then 9    # S ETIEMBRE
          when concordancia[1][0,1].upcase == "O" then 10   # O CTUBRE
          when concordancia[1][0,1].upcase == "N" then 11   # N OVIEMBRE
          when concordancia[1][0,1].upcase == "D" then 12   # D ICIEMBRE
          else 0
        end
        año = concordancia[2].to_i
        begin
          @primer_dia_de_prestaciones = Date.new((año > 2000 ? año : Date.today.year), mes, 1)
          rescue ArgumentError
        end
      end
      # Buscar los números de convenio de gestión y administración (si corresponde)
      concordancia = /G-000-[[:digit:]]{3}/i.match(params[:facturacion])
      if concordancia
        @texto_convenio_de_gestion = concordancia.to_s.upcase
        @convenio_de_gestion = @efector.convenio_de_gestion
      end
      concordancia = /A-000-[[:digit:]]{3}/i.match(params[:facturacion])
      if concordancia
        @texto_convenio_de_administracion = concordancia.to_s.upcase
        @convenio_de_administracion = @efector.convenio_de_administracion
      end
      # Buscar el detalle de las prestaciones facturadas
      concordancia = /valor.*?\n(.*[[:alpha:]]+.*?\t.*?[[:digit:]]+.*?\t.*?[[:digit:]]+.*?\t.*?[[:digit:]]+.*?)[\r\n]/mi.match(params[:facturacion])
      if concordancia
        @detalle = []
        concordancia[1].gsub(/\r/, '').split("\n").each do |linea|
          resultado = procesar_linea_detalle(linea)
          @detalle << resultado if resultado
        end
        @total_calculado = 0.0
        @detalle.each do |d|
          begin
            # Sólo cuando el precio informado de la prestación es correcto
            # se suma el subtotal de esa línea al total calculado
            if d[:precio_unitario_informado] == d[:precio_por_unidad]
              # Si el subtotal informado difiere del calculado (por un error
              # de multiplicación) se suma al total el menor de los dos.
              if d[:subtotal_informado] < d[:subtotal]
                @total_calculado += d[:subtotal_informado]
              else
                @total_calculado += d[:subtotal]
              end
            end
            rescue TypeError # Si el subtotal de alguna línea es nil
          end
        end
      end
      # Buscar el total facturado
      concordancia = /total.*?([[:digit:]].*?)[\r\t\n]/i.match(params[:facturacion])
      if concordancia
        texto_total = concordancia[1]
        @total_informado = texto_total.strip.gsub(/\./, '').gsub(/,/, '.').gsub(/\$* /, '').to_f
      end
    else # no hay parámetros
      @nomencladores = Nomenclador.find(:all, :conditions => "activo", :order => 'fecha_de_inicio DESC').collect{ |n| [n.nombre, n.id] }
      @nomenclador_id = @nomencladores[0][1]
    end
  end

private
  def procesar_linea_detalle(linea)
    # Separar los campos y analizarlos
    begin
      texto_codigo, texto_cantidad, texto_precio_unitario, texto_subtotal = linea.split("\t")
      cantidad = texto_cantidad.strip.gsub(/\./, '').gsub(/,/, '.').gsub(/\$* /, '').to_i
      precio_unitario_informado = texto_precio_unitario.strip.gsub(/\./, '').gsub(/,/, '.').gsub(/\$* /, '').to_f
      subtotal_informado = texto_subtotal.strip.gsub(/\./, '').gsub(/,/, '.').gsub(/\$* /, '').to_f

      # Inicializar valores
      codigo_informado = texto_codigo.strip.gsub(/ +/, " ")
      codigo = nil
      precio_por_unidad = nil
      adicional_por_prestacion = nil
      subtotal = nil
      autorizada = false

      # Buscar el código de la prestación
      prestacion = Prestacion.find_by_codigo(codigo_informado)
      if prestacion
        codigo = prestacion.codigo
        ids_prestaciones_autorizadas = PrestacionAutorizada.autorizadas_antes_del_dia(@efector.id, (@primer_dia_de_prestaciones + 1)).collect {|p| p.prestacion_id}
        autorizada = true if ids_prestaciones_autorizadas.member?(prestacion.id)
        if autorizada
          asignacion_de_precios = AsignacionDePrecios.where(:nomenclador_id => params[:nomenclador_id], :prestacion_id => prestacion.id).first
          if asignacion_de_precios
            precio_por_unidad = asignacion_de_precios.precio_por_unidad
            adicional_por_prestacion = asignacion_de_precios.adicional_por_prestacion
            subtotal = cantidad * precio_por_unidad + adicional_por_prestacion
          end
        end
      end

      return {:codigo_informado => codigo_informado, :codigo => codigo, :cantidad => cantidad, :autorizada => autorizada,
              :precio_unitario_informado => precio_unitario_informado, :subtotal_informado => subtotal_informado,
              :precio_por_unidad => precio_por_unidad, :adicional_por_prestacion => adicional_por_prestacion,
              :subtotal => subtotal}
      rescue NoMethodError
        return nil # Si la línea está mal formateada (error probable en la detección de los límites del detalle)
    end
  end

end
