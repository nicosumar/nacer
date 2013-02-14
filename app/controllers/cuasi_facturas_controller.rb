# -*- encoding : utf-8 -*-
class CuasiFacturasController < ApplicationController
  before_filter :authenticate_user!
  helper_method :resultado_verificacion

  def index
    # Verificar los permisos del usuario
    if can? :read, CuasiFactura
      @cuasi_facturas = CuasiFactura.paginate(:page => params[:page], :per_page => 20,
        :include => [{:liquidacion => :efector}, :efector, :nomenclador], :order => "updated_at DESC")
    else
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end
  end

  def show
    # Verificar los permisos del usuario
    if cannot? :read, CuasiFactura
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end

    # Obtener la cuasi-factura solicitada
    begin
      @cuasi_factura = CuasiFactura.find(params[:id], :include => [{:liquidacion => :efector}, :efector, :nomenclador,
        {:renglones_de_cuasi_facturas => :prestacion}, :registros_de_prestaciones])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :notice => "La cuasi-factura solicitada no existe. El incidente será reportado al administrador del sistema.")
      return
    end

    # Obtener la liquidacion asociada con la cuasi-factura
    @liquidacion = @cuasi_factura.liquidacion
  end

  def new
    # Verificar los permisos del usuario
    if cannot? :create, CuasiFactura
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end

    # Para crear una cuasi-factura, debe accederse desde la página de la liquidación correspondiente
    if !params[:liquidacion_id]
      redirect_to(liquidaciones_url,
        :notice => "Para crear una cuasi-factura, primero seleccione la liquidación a la que pertenece.")
      return
    end

    # Crear variables requeridas para generar el formulario
    @cuasi_factura = CuasiFactura.new

    # Obtener el convenio de gestión asociado
    begin
      @liquidacion = Liquidacion.find(params[:liquidacion_id], :include => :efector)
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :notice => "Petición no válida. El incidente será reportado al administrador del sistema.")
      return
    end
    @efectores = Efector.del_administrador_sin_liquidar(@liquidacion.efector_id, @liquidacion.id).collect{ |e| [e.nombre_corto, e.id] }
    @efector_id = nil
    @nomencladores = Nomenclador.find(:all).collect{ |n| [n.nombre, n.id] }
    @nomenclador_id = nil
  end

  def edit
    # Verificar los permisos del usuario
    if cannot? :update, CuasiFactura
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end

    # Crear las variables requeridas para generar el formulario
    begin
      @cuasi_factura = CuasiFactura.find(params[:id], :include => [{:liquidacion => :efector}, :efector, :nomenclador])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :notice => "Petición no válida. El incidente será reportado al administrador del sistema.")
      return
    end
    @liquidacion = @cuasi_factura.liquidacion
    @efectores = [[@cuasi_factura.efector.nombre_corto, @cuasi_factura.efector_id]]
    @efector_id = @cuasi_factura.efector_id
    @nomencladores = Nomenclador.find(:all).collect{ |n| [n.nombre, n.id] }
    @nomenclador_id = @cuasi_factura.nomenclador_id
  end

  def create
    # Verificar los permisos del usuario
    if cannot? :create, CuasiFactura
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:cuasi_factura] || !params[:cuasi_factura][:liquidacion_id]
      redirect_to root_url, :notice => "La petición no es válida. El incidente será reportado al administrador del sistema." 
      return
    end

    # Crear el nuevo objeto
    @cuasi_factura = CuasiFactura.new

    # Obtener la liquidación asociada
    begin
      @liquidacion = Liquidacion.find(params[:cuasi_factura][:liquidacion_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :notice => "Petición no válida. El incidente será reportado al administrador del sistema.")
      return
    end

    # Verificar que el efector y el nomenclador seleccionados coincidan con las opciones válidas del formulario
    @efectores = Efector.del_administrador_sin_liquidar(@liquidacion.efector_id,
      @liquidacion.id).collect{ |e| [e.nombre_corto, e.id] }
    @nomencladores = Nomenclador.find(:all).collect{ |n| [n.nombre, n.id] }
    @efector_id = params[:cuasi_factura][:efector_id]
    @nomenclador_id = params[:cuasi_factura][:nomenclador_id]
    if !((@efectores.collect{|e| e[1]}).member?(@efector_id.to_i)) ||
         !((@nomencladores.collect{|n| n[1]}).member?(@nomenclador_id.to_i))
      redirect_to root_url, :notice => "La petición no es válida. El incidente será reportado al administrador del sistema." 
      return
    end

    # Establecer el valor de los atributos protegidos
    @cuasi_factura.liquidacion_id = @liquidacion.id
    @cuasi_factura.efector_id = @efector_id
    @cuasi_factura.nomenclador_id = @nomenclador_id

    # Establecer los valores del resto de los atributos
    @cuasi_factura.attributes = params[:cuasi_factura]

    # Intentar persistir el objeto en la base de datos
    if @cuasi_factura.save
      redirect_to cuasi_factura_path(@cuasi_factura), :notice => 'La cuasi-factura se creó exitosamente.'
      return
    end

    # Si la grabación falla volver a mostrar el formulario con los errores
    render :action => "new"
  end

  def update
    # Verificar los permisos del usuario
    if cannot? :update, CuasiFactura
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:cuasi_factura]
      redirect_to(root_url,
        :notice => "La petición no es válida. El incidente será reportado al administrador del sistema.")
      return
    end

    # Obtener la cuasi-factura que se actualizará y su liquidación correspondiente
    begin
      @cuasi_factura = CuasiFactura.find(params[:id], :include => [{:liquidacion => :efector}, :efector, :nomenclador])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :notice => "Petición no válida. El incidente será reportado al administrador del sistema.")
      return
    end
    @liquidacion = @cuasi_factura.liquidacion

    # Actualizar los valores de los atributos no protegidos por asignación masiva
    @cuasi_factura.attributes = params[:cuasi_factura]

    # Intentar persistir el objeto en la base de datos
    if @cuasi_factura.save
      redirect_to cuasi_factura_path(@cuasi_factura), :notice => 'Los datos de la cuasi-factura se actualizaron correctamente.'
      return
    end

    # Si la grabación falla, volver a mostrar el formulario con los errores
    render :action => "edit"
  end

  def importar_detalle
    # Verificar los permisos del usuario
    if cannot? :create, RenglonDeCuasiFactura
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:cuasi_factura_id]
      redirect_to root_url, :notice => "La petición no es válida. El incidente será reportado al administrador del sistema." 
      return
    end

    # Obtener la cuasi-factura
    begin
      @cuasi_factura = CuasiFactura.find(params[:cuasi_factura_id], :include => [:efector, {:liquidacion => :efector},
        :nomenclador, :renglones_de_cuasi_facturas])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :notice => "Petición no válida. El incidente será reportado al administrador del sistema.")
    end
    @liquidacion = @cuasi_factura.liquidacion
    @efector = @cuasi_factura.efector
    @nomenclador = @cuasi_factura.nomenclador

    # Preparar los datos para la importación
    if @cuasi_factura.renglones_de_cuasi_facturas.any?
      # Ya existen datos importados para esta cuasi-factura (petición fraguada o se volvió a enviar la información)
      redirect_to(cuasi_factura_path(@cuasi_factura),
        :notice => "Ya se importaron los datos de la cuasi-factura. No es posible volver a importarlos.")
      return
    end

    # Verificar en cuál paso del proceso nos encontramos
    if params[:detalle]
      if params[:commit] == "Verificar"
        # Procesar los datos importados para la verificación preliminar
        @primer_dia_de_prestaciones = Date.new(@liquidacion.anio_de_prestaciones, @liquidacion.mes_de_prestaciones, 1)
        @total_informado = params[:total_informado].gsub("$", '').gsub(/\./, '').gsub(/,/, '.').strip.to_f
        @detalle = []
        params[:detalle].split("\n").each_with_index do |linea, i|
          if (resultado = procesar_linea_detalle(linea))
            if resultado[:adicional_por_prestacion] && resultado[:adicional_por_prestacion] > 0.0
              resultado[:codigo_de_prestacion_informado] += " (#{i})"
            end
            if @detalle.any? {|r| r[:codigo_de_prestacion_informado] == resultado[:codigo_de_prestacion_informado]}
              # Se ha duplicado una misma prestación en dos líneas del detalle
              @detalle.each do |r|
                if r[:codigo_de_prestacion_informado] == resultado[:codigo_de_prestacion_informado]
                  r[:cantidad] += resultado[:cantidad]
                  r[:subtotal_informado] += resultado[:cantidad].to_f * resultado[:precio_unitario_informado]
                  r[:subtotal] += resultado[:cantidad].to_f * resultado[:precio_por_unidad] + resultado[:adicional_por_prestacion]
                end
              end
            else
              @detalle << resultado
            end
          end
        end
        @detalle_importacion = ""
        @total_calculado = 0.0
        @detalle.each do |d|
          @detalle_importacion += "#{d[:codigo_de_prestacion_informado]}\t#{d[:prestacion_id]}\t#{d[:cantidad]}\t#{d[:precio_unitario_informado]}\t#{d[:subtotal_informado]}\n"
          @total_calculado += d[:subtotal_informado]
        end
        @detalle_importacion = @detalle_importacion.chomp
      elsif params[:commit] == "Importar"
        # El parámetro 'detalle' ya contiene los datos procesados, importarlos en el sistema
        params[:detalle].split("\n").each do |linea|
          cpi, p, c, m, s = linea.chomp.split("\t")
          begin
            RenglonDeCuasiFactura.create({:cuasi_factura_id => @cuasi_factura.id, :codigo_de_prestacion_informado => cpi,
              :prestacion_id => p, :cantidad_informada => c.to_i, :monto_informado => m.to_f,
              :subtotal_informado => s.to_f})
          rescue
            redirect_to(cuasi_factura_path(@cuasi_factura),
              :notice => "Se produjo un error al intentar importar los datos. Notifique al administrador del sistema.")
            return
          end
        end
        # El parámetro total informado contiene el total indicado en la cuasi-factura
        begin
          @cuasi_factura.total_informado = params[:total_informado]
          @cuasi_factura.save
        rescue
          redirect_to(cuasi_factura_path(@cuasi_factura),
            :notice => "Se produjo un error al intentar importar los datos. Notifique al administrador del sistema.")
          return
        end
        redirect_to cuasi_factura_path(@cuasi_factura), :notice => "El detalle de la cuasi-factura se importó correctamente."
      else
        # ¿Petición fraguada?
        redirect_to root_url, :notice => "La petición no es válida. Este incidente será reportado al administrador del sistema."
      end
    end

  end

  def importar_registros_de_prestaciones
    # Verificar los permisos del usuario
    if cannot? :create, RegistroDePrestacion
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:cuasi_factura_id]
      redirect_to root_url, :notice => "La petición no es válida. El incidente será reportado al administrador del sistema." 
      return
    end

    # Obtener la cuasi-factura
    begin
      @cuasi_factura = CuasiFactura.find(params[:cuasi_factura_id], :include => [:efector, {:liquidacion => :efector},
        :nomenclador, :renglones_de_cuasi_facturas, :registros_de_prestaciones])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :notice => "Petición no válida. El incidente será reportado al administrador del sistema.")
    end
    @liquidacion = @cuasi_factura.liquidacion
    @efector = @cuasi_factura.efector
    @nomenclador = @cuasi_factura.nomenclador

    # Preparar los datos para la importación
    if !@cuasi_factura.renglones_de_cuasi_facturas.any?
      # No existen renglones de cuasi-factura importados (petición fraguada)
      redirect_to(cuasi_factura_path(@cuasi_factura),
        :notice => "Antes de importar la digitalización debe importar el detalle de la cuasi-factura.")
      return
    end

    # Preparar los datos para la importación
    if @cuasi_factura.registros_de_prestaciones.any?
      # Ya existen datos importados para esta cuasi-factura (petición fraguada o se volvió a enviar la información)
      redirect_to(cuasi_factura_path(@cuasi_factura),
        :notice => "Ya se importaron las prestaciones. No es posible volver a importarlas.")
      return
    end

    #TODO: Agregar validaciones de fechas
#    @primer_dia_de_prestaciones = Date.new(@liquidacion.anio_de_prestaciones, @liquidacion.mes_de_prestaciones, 1)

    # Verificar en cuál paso del proceso nos encontramos
    if params[:commit] == "Verificar"
      @detalle = []
      @resumen = {}
      @importacion_pediatria = procesar_registros_pediatria
      @importacion_lactantes = procesar_registros_lactantes
      @importacion_vacunacion = procesar_registros_vacunacion
      @importacion_laboratorio = procesar_registros_laboratorio
      @importacion_general = procesar_registros_general
      @importacion_parto = procesar_registros_parto
      @importacion_incubadora = procesar_registros_incubadora
    elsif params[:commit] == "Importar"
      if !importar_registros_pediatria || !importar_registros_lactantes || !importar_registros_vacunacion ||
        !importar_registros_laboratorio || !importar_registros_general || !importar_registros_parto ||
        !importar_registros_incubadora
        redirect_to(cuasi_factura_path(@cuasi_factura),
          :notice => "Se produjo un error al intentar importar los datos. Notifique al administrador del sistema.")
        return
      else
        # Actualizar los renglones de la cuasi-factura con los totales de prestaciones digitalizadas.
        begin
          totales_digitalizados = @cuasi_factura.registros_de_prestaciones.sum(:cantidad,
            :group => [:codigo_de_prestacion_informado, :prestacion_id])
          totales_digitalizados.each_pair do |prestacion, cantidad_digitalizada|
            renglon = @cuasi_factura.renglones_de_cuasi_facturas.find(:all,
              :conditions => ["codigo_de_prestacion_informado = ?", prestacion[0]]).first
            if renglon
              renglon.update_attributes({:cantidad_digitalizada => cantidad_digitalizada})
            else
              renglon = RenglonDeCuasiFactura.new({:codigo_de_prestacion_informado => prestacion[0],
                :monto_informado => 0.0, :subtotal_informado => 0.0, :prestacion_id => prestacion[1],
                :cantidad_digitalizada => cantidad_digitalizada})
              @cuasi_factura.renglones_de_cuasi_facturas << renglon
            end
          end
        rescue
          redirect_to(cuasi_factura_path(@cuasi_factura),
            :notice => "Se produjo un error al intentar importar los datos. Notifique al administrador del sistema.")
          return
        end
      end
      redirect_to(cuasi_factura_path(@cuasi_factura),
        :notice => "La digitalización de la cuasi-factura se importó correctamente.")
    end

  end

#  def destroy
#  end

private

  def procesar_linea_detalle(linea)
    # Separar los campos y analizarlos
    begin
      texto_codigo, texto_cantidad, texto_precio_unitario, texto_subtotal = linea.split("\t")
      cantidad = texto_cantidad.gsub("$", '').gsub(/\./, '').gsub(/,/, '.').strip.to_i
      precio_unitario_informado = texto_precio_unitario.gsub("$", '').gsub(/\./, '').gsub(/,/, '.').strip.to_f
      subtotal_informado = texto_subtotal.gsub("$", '').gsub(/\./, '').gsub(/,/, '.').strip.to_f

      # Inicializar valores
      codigo = nil
      precio_por_unidad = nil
      adicional_por_prestacion = nil
      subtotal = nil
      autorizada = false
      prestacion_id = nil

      # Buscar el código de la prestación
      prestacion_id, codigo = a_prestacion(texto_codigo)
      if prestacion_id
        ids_prestaciones_autorizadas = PrestacionAutorizada.autorizadas_antes_del_dia(@efector.id,
          (@primer_dia_de_prestaciones + 1)).collect {|p| p.prestacion_id}
        autorizada = true if ids_prestaciones_autorizadas.member?(prestacion_id)
        if autorizada
          asignacion_de_precios =
            AsignacionDePrecios.where(:nomenclador_id => @nomenclador.id, :prestacion_id => prestacion_id).first
          if asignacion_de_precios
            precio_por_unidad = asignacion_de_precios.precio_por_unidad
            adicional_por_prestacion = asignacion_de_precios.adicional_por_prestacion
            subtotal = cantidad * precio_por_unidad + adicional_por_prestacion
          end
        end
      end

      return {:codigo_de_prestacion_informado => codigo, :cantidad => cantidad,
        :autorizada => autorizada, :precio_unitario_informado => precio_unitario_informado,
        :subtotal_informado => subtotal_informado, :precio_por_unidad => precio_por_unidad,
        :adicional_por_prestacion => adicional_por_prestacion, :subtotal => subtotal, :prestacion_id => prestacion_id}
      rescue
        return nil # Si la línea está mal formateada
    end
  end

  def procesar_registros_pediatria
    # Procesar los datos importados para la verificación preliminar
    importacion_pediatria = ""
    params[:detalle_pediatria].chomp.split("\n").each do |linea|
      if (d = procesar_registro_pediatria(linea))
        @detalle << d
        if @resumen.has_key?(d[:codigo_de_prestacion_informado])
          @resumen[d[:codigo_de_prestacion_informado]] += (d[:cantidad] || 1)
        else
          @resumen.merge! d[:codigo_de_prestacion_informado] => (d[:cantidad] || 1)
        end
        importacion_pediatria += "#{d[:fecha_de_prestacion]}\t#{d[:apellido]}\t#{d[:nombre]}\t#{d[:clase_de_documento_id]}\t#{d[:tipo_de_documento_id]}\t#{d[:numero_de_documento]}\t#{d[:codigo_de_prestacion_informado]}\t#{d[:prestacion_id]}\t#{d[:historia_clinica]}\t#{d[:afiliado_id]}\t#{d[:fecha_de_nacimiento]}\t#{d[:peso_actual]}\t#{d[:talla_actual]}\t#{d[:numero_de_control]}\t#{d[:percentil_peso_edad_id]}\t#{d[:percentil_peso_talla_id]}\n"
      end
    end
    importacion_pediatria.chomp!

    return importacion_pediatria
  end

  def importar_registros_pediatria
    # El parámetro 'detalle_pediatria' ya contiene los datos de pediatria procesados, importarlos en el sistema
    params[:detalle_pediatria].split("\n").each do |linea|
      fp, ape, nom, cd, td, nd, cpi, pr, hc, afi, fn, pa, ta, nc, ppe, ppt = linea.chomp.split("\t")
      begin
        rp = RegistroDePrestacion.create({:fecha_de_prestacion => fp, :apellido => ape, :nombre => nom,
          :clase_de_documento_id => cd, :tipo_de_documento_id => td, :numero_de_documento => nd,
          :codigo_de_prestacion_informado => cpi, :prestacion_id => pr, :historia_clinica => hc,
          :afiliado_id => afi, :estado_de_la_prestacion_id => 2, :cuasi_factura_id => @cuasi_factura.id,
          :nomenclador_id => @nomenclador.id})
        if fn && !fn.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 1,
            :valor => fn})
        end
        if pa && !pa.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 3,
            :valor => pa})
        end
        if ta && !ta.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 4,
            :valor => ta})
        end
        if nc && !nc.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 2,
            :valor => nc})
        end
        if ppe && !ppe.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 6,
            :valor => ppe})
        end
        if ppt && !ppt.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 18,
            :valor => ppt})
        end
      rescue
        return false
      end
    end

    return true
  end

  def procesar_registro_pediatria(linea)
    # Separar los campos y analizarlos
    fecha, nombre, clase, tipo, numero, hc, prestacion, nacimiento, control, peso, talla, peso_edad, peso_talla = 
      linea.chomp.strip.split("\t")

    # Obtener el código de prestación informado
    prestacion_id, codigo = a_prestacion(prestacion || "")
    # Regresar nil si no se encontró un código (¿línea vacía?)
    return nil if !codigo

    # Convertir cada campo a su tipo de datos correspondiente
    fecha_de_prestacion = a_fecha(fecha || "")
    clase_de_documento_id = a_clase(clase || "")
    tipo_de_documento_id = a_tipo(tipo || "")
    numero_de_documento = a_documento(numero || "")
    historia_clinica = (hc ? hc.strip.upcase : nil)

    # Intentar encontrar al afiliado
    afiliados, nivel_concordancia = Afiliado.busqueda_por_aproximacion(numero_de_documento, (nombre ? nombre.upcase : ""))
    if afiliados && afiliados.size == 1
      apellido = afiliados.first.apellido
      nombre = afiliados.first.nombre
      afiliado_id = afiliados.first.afiliado_id
    else
      apellido, nombre = separar_nombre(nombre ? nombre.upcase : "")
      afiliado_id = nil
    end
    fecha_de_nacimiento = a_fecha(nacimiento || "")
    numero_de_control = a_control(control || "")
    peso_actual = a_peso(peso || "")
    talla_actual = a_talla(talla || "")
    percentil_peso_edad_id = a_percentil_pe(peso_edad || "")
    percentil_peso_talla_id = a_percentil_pt(peso_talla || "")

    return { :fecha_de_prestacion => fecha_de_prestacion, :clase_de_documento_id => clase_de_documento_id,
      :tipo_de_documento_id => tipo_de_documento_id, :numero_de_documento => numero_de_documento,
      :apellido => apellido, :nombre => nombre, :afiliado_id => afiliado_id,
      :codigo_de_prestacion_informado => codigo, :prestacion_id => prestacion_id,
      :fecha_de_nacimiento => fecha_de_nacimiento, :historia_clinica => historia_clinica,
      :peso_actual => peso_actual, :talla_actual => talla_actual, :numero_de_control => numero_de_control,
      :percentil_peso_edad_id => percentil_peso_edad_id, :percentil_peso_talla_id => percentil_peso_talla_id }

  end

  def procesar_registros_lactantes
    # Procesar los datos importados para la verificación preliminar
    importacion_lactantes = ""
    params[:detalle_lactantes].chomp.split("\n").each do |linea|
      if (d = procesar_registro_lactante(linea))
        @detalle << d
        if @resumen.has_key?(d[:codigo_de_prestacion_informado])
          @resumen[d[:codigo_de_prestacion_informado]] += (d[:cantidad] || 1)
        else
          @resumen.merge! d[:codigo_de_prestacion_informado] => (d[:cantidad] || 1)
        end
        importacion_lactantes += "#{d[:fecha_de_prestacion]}\t#{d[:apellido]}\t#{d[:nombre]}\t#{d[:clase_de_documento_id]}\t#{d[:tipo_de_documento_id]}\t#{d[:numero_de_documento]}\t#{d[:codigo_de_prestacion_informado]}\t#{d[:prestacion_id]}\t#{d[:historia_clinica]}\t#{d[:afiliado_id]}\t#{d[:fecha_de_nacimiento]}\t#{d[:peso_actual]}\t#{d[:talla_actual]}\t#{d[:perimetro_cefalico]}\t#{d[:numero_de_control]}\t#{d[:percentil_peso_edad_id]}\t#{d[:percentil_per_cefalico_edad_id]}\n"
      end
    end
    importacion_lactantes.chomp!

    return importacion_lactantes
  end

  def importar_registros_lactantes
    # El parámetro 'detalle_lactantes' ya contiene los datos procesados, importarlos en el sistema
    params[:detalle_lactantes].split("\n").each do |linea|
      fp, ape, nom, cd, td, nd, cpi, pr, hc, afi, fn, pa, ta, pc, nc, ppe, ppce = linea.chomp.split("\t")
      begin
        rp = RegistroDePrestacion.create({:fecha_de_prestacion => fp, :apellido => ape, :nombre => nom,
          :clase_de_documento_id => cd, :tipo_de_documento_id => td, :numero_de_documento => nd,
          :codigo_de_prestacion_informado => cpi, :prestacion_id => pr, :historia_clinica => hc,
          :afiliado_id => afi, :estado_de_la_prestacion_id => 2, :cuasi_factura_id => @cuasi_factura.id,
          :nomenclador_id => @nomenclador.id})
        if fn && !fn.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 1,
            :valor => fn})
        end
        if pa && !pa.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 3,
            :valor => pa})
        end
        if ta && !ta.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 4,
            :valor => ta})
        end
        if pc && !pc.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 5,
            :valor => pc})
        end
        if nc && !nc.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 2,
            :valor => nc})
        end
        if ppe && !ppe.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 6,
            :valor => ppe})
        end
        if ppce && !ppce.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 7,
            :valor => ppce})
        end
      rescue
        return false
      end
    end

    return true
  end

  def procesar_registro_lactante(linea)
    # Separar los campos y analizarlos
    fecha, nombre, clase, tipo, numero, hc, prestacion, nacimiento, control, peso, talla, perimetro, peso_edad, perimetro_edad = 
      linea.chomp.strip.split("\t")

    # Obtener el código de prestación informado
    prestacion_id, codigo = a_prestacion(prestacion || "")
    # Regresar nil si no se encontró un código (¿línea vacía?)
    return nil if !codigo

    # Convertir cada campo a su tipo de datos correspondiente
    fecha_de_prestacion = a_fecha(fecha || "")
    clase_de_documento_id = a_clase(clase || "")
    tipo_de_documento_id = a_tipo(tipo || "")
    numero_de_documento = a_documento(numero || "")
    historia_clinica = (hc ? hc.strip.upcase : nil)

    # Intentar encontrar al afiliado
    afiliados, nivel_concordancia = Afiliado.busqueda_por_aproximacion(numero_de_documento, (nombre ? nombre.upcase : ""))
    if afiliados && afiliados.size == 1
      apellido = afiliados.first.apellido
      nombre = afiliados.first.nombre
      afiliado_id = afiliados.first.afiliado_id
    else
      apellido, nombre = separar_nombre(nombre ? nombre.upcase : "")
      afiliado_id = nil
    end

    fecha_de_nacimiento = a_fecha(nacimiento || "")
    numero_de_control = a_control(control || "")
    peso_actual = a_peso(peso || "")
    talla_actual = a_talla(talla || "")
    perimetro_cefalico = a_perimetro(perimetro || "")
    percentil_peso_edad_id = a_percentil_pe(peso_edad || "")
    percentil_per_cefalico_edad_id = a_percentil_pce(perimetro_edad || "")

    return { :fecha_de_prestacion => fecha_de_prestacion, :clase_de_documento_id => clase_de_documento_id,
      :tipo_de_documento_id => tipo_de_documento_id, :numero_de_documento => numero_de_documento,
      :apellido => apellido, :nombre => nombre, :afiliado_id => afiliado_id,
      :codigo_de_prestacion_informado => codigo, :prestacion_id => prestacion_id,
      :fecha_de_nacimiento => fecha_de_nacimiento, :historia_clinica => historia_clinica,
      :peso_actual => peso_actual, :talla_actual => talla_actual, :perimetro_cefalico => perimetro_cefalico,
      :numero_de_control => numero_de_control, :percentil_peso_edad_id => percentil_peso_edad_id,
      :percentil_per_cefalico_edad_id => percentil_per_cefalico_edad_id }

  end

  def procesar_registros_vacunacion
    # Procesar los datos importados para la verificación preliminar
    importacion_vacunacion = ""
    params[:detalle_vacunacion].chomp.split("\n").each do |linea|
      if (d = procesar_registro_vacunacion(linea))
        @detalle << d
        if @resumen.has_key?(d[:codigo_de_prestacion_informado])
          @resumen[d[:codigo_de_prestacion_informado]] += (d[:cantidad] || 1)
        else
          @resumen.merge! d[:codigo_de_prestacion_informado] => (d[:cantidad] || 1)
        end
        importacion_vacunacion += "#{d[:fecha_de_prestacion]}\t#{d[:apellido]}\t#{d[:nombre]}\t#{d[:clase_de_documento_id]}\t#{d[:tipo_de_documento_id]}\t#{d[:numero_de_documento]}\t#{d[:codigo_de_prestacion_informado]}\t#{d[:prestacion_id]}\t#{d[:historia_clinica]}\t#{d[:afiliado_id]}\n"
      end
    end
    importacion_vacunacion.chomp!

    return importacion_vacunacion
  end

  def importar_registros_vacunacion
    # El parámetro 'detalle_vacunacion' ya contiene los datos procesados, importarlos en el sistema
    params[:detalle_vacunacion].split("\n").each do |linea|
      fp, ape, nom, cd, td, nd, cpi, pr, hc, afi = linea.chomp.split("\t")
      begin
        rp = RegistroDePrestacion.create({:fecha_de_prestacion => fp, :apellido => ape, :nombre => nom,
          :clase_de_documento_id => cd, :tipo_de_documento_id => td, :numero_de_documento => nd,
          :codigo_de_prestacion_informado => cpi, :prestacion_id => pr, :historia_clinica => hc,
          :afiliado_id => afi, :estado_de_la_prestacion_id => 2, :cuasi_factura_id => @cuasi_factura.id,
          :nomenclador_id => @nomenclador.id})
      rescue
        return false
      end
    end

    return true
  end

  def procesar_registro_vacunacion(linea)
    # Separar los campos y analizarlos
    fecha, nombre, clase, tipo, numero, hc, prestacion = linea.chomp.strip.split("\t")

    # Obtener el código de prestación informado
    prestacion_id, codigo = a_prestacion(prestacion || "")
    # Regresar nil si no se encontró un código (¿línea vacía?)
    return nil if !codigo

    # Convertir cada campo a su tipo de datos correspondiente
    fecha_de_prestacion = a_fecha(fecha || "")
    clase_de_documento_id = a_clase(clase || "")
    tipo_de_documento_id = a_tipo(tipo || "")
    numero_de_documento = a_documento(numero || "")
    historia_clinica = (hc ? hc.strip.upcase : nil)

    # Intentar encontrar al afiliado
    afiliados, nivel_concordancia = Afiliado.busqueda_por_aproximacion(numero_de_documento, (nombre ? nombre.upcase : ""))
    if afiliados && afiliados.size == 1
      apellido = afiliados.first.apellido
      nombre = afiliados.first.nombre
      afiliado_id = afiliados.first.afiliado_id
    else
      apellido, nombre = separar_nombre(nombre ? nombre.upcase : "")
      afiliado_id = nil
    end

    return { :fecha_de_prestacion => fecha_de_prestacion, :clase_de_documento_id => clase_de_documento_id,
      :tipo_de_documento_id => tipo_de_documento_id, :numero_de_documento => numero_de_documento,
      :apellido => apellido, :nombre => nombre, :afiliado_id => afiliado_id,
      :codigo_de_prestacion_informado => codigo, :prestacion_id => prestacion_id,
      :historia_clinica => historia_clinica }

  end

  def procesar_registros_laboratorio
    # Procesar los datos importados para la verificación preliminar
    importacion_laboratorio = ""
    params[:detalle_laboratorio].chomp.split("\n").each do |linea|
      if (d = procesar_registro_laboratorio(linea))
        @detalle << d
        if @resumen.has_key?(d[:codigo_de_prestacion_informado])
          @resumen[d[:codigo_de_prestacion_informado]] += (d[:cantidad] || 1)
        else
          @resumen.merge! d[:codigo_de_prestacion_informado] => (d[:cantidad] || 1)
        end
        importacion_laboratorio += "#{d[:fecha_de_prestacion]}\t#{d[:apellido]}\t#{d[:nombre]}\t#{d[:clase_de_documento_id]}\t#{d[:tipo_de_documento_id]}\t#{d[:numero_de_documento]}\t#{d[:codigo_de_prestacion_informado]}\t#{d[:prestacion_id]}\t#{d[:historia_clinica]}\t#{d[:afiliado_id]}\t#{d[:numero_de_pedido]}\t#{d[:numero_de_informe]}\n"
      end
    end
    importacion_laboratorio.chomp!

    return importacion_laboratorio
  end

  def importar_registros_laboratorio
    # El parámetro 'detalle_laboratorio' ya contiene los datos procesados, importarlos en el sistema
    params[:detalle_laboratorio].split("\n").each do |linea|
      fp, ape, nom, cd, td, nd, cpi, pr, hc, afi, np, ni = linea.chomp.split("\t")
      begin
        rp = RegistroDePrestacion.create({:fecha_de_prestacion => fp, :apellido => ape, :nombre => nom,
          :clase_de_documento_id => cd, :tipo_de_documento_id => td, :numero_de_documento => nd,
          :codigo_de_prestacion_informado => cpi, :prestacion_id => pr, :historia_clinica => hc,
          :afiliado_id => afi, :estado_de_la_prestacion_id => 2, :cuasi_factura_id => @cuasi_factura.id,
          :nomenclador_id => @nomenclador.id})
        if np && !np.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 9,
            :valor => np})
        end
        if ni && !ni.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 10,
            :valor => ni})
        end
      rescue
        return false
      end
    end

    return true
  end

  def procesar_registro_laboratorio(linea)
    # Separar los campos y analizarlos
    fecha, nombre, clase, tipo, numero, np, hc, ni, prestacion = linea.chomp.strip.split("\t")

    # Obtener el código de prestación informado
    prestacion_id, codigo = a_prestacion(prestacion || "")
    # Regresar nil si no se encontró un código (¿línea vacía?)
    return nil if !codigo

    # Convertir cada campo a su tipo de datos correspondiente
    fecha_de_prestacion = a_fecha(fecha || "")
    clase_de_documento_id = a_clase(clase || "")
    tipo_de_documento_id = a_tipo(tipo || "")
    numero_de_documento = a_documento(numero || "")
    historia_clinica = (hc ? hc.strip.upcase : nil)

    # Intentar encontrar al afiliado
    afiliados, nivel_concordancia = Afiliado.busqueda_por_aproximacion(numero_de_documento, (nombre ? nombre.upcase : ""))
    if afiliados && afiliados.size == 1
      apellido = afiliados.first.apellido
      nombre = afiliados.first.nombre
      afiliado_id = afiliados.first.afiliado_id
    else
      apellido, nombre = separar_nombre(nombre ? nombre.upcase : "")
      afiliado_id = nil
    end

    numero_de_pedido = (np ? np.strip.upcase : nil)
    numero_de_informe = (ni ? ni.strip.upcase : nil)

    return { :fecha_de_prestacion => fecha_de_prestacion, :clase_de_documento_id => clase_de_documento_id,
      :tipo_de_documento_id => tipo_de_documento_id, :numero_de_documento => numero_de_documento,
      :apellido => apellido, :nombre => nombre, :afiliado_id => afiliado_id,
      :codigo_de_prestacion_informado => codigo, :prestacion_id => prestacion_id,
      :historia_clinica => historia_clinica, :numero_de_pedido => numero_de_pedido,
      :numero_de_informe => numero_de_informe }

  end

  def procesar_registros_general
    # Procesar los datos importados para la verificación preliminar
    importacion_general = ""
    params[:detalle_general].chomp.split("\n").each do |linea|
      if (d = procesar_registro_general(linea))
        @detalle << d
        if @resumen.has_key?(d[:codigo_de_prestacion_informado])
          @resumen[d[:codigo_de_prestacion_informado]] += (d[:cantidad] || 1)
        else
          @resumen.merge! d[:codigo_de_prestacion_informado] => (d[:cantidad] || 1)
        end
        importacion_general += "#{d[:fecha_de_prestacion]}\t#{d[:apellido]}\t#{d[:nombre]}\t#{d[:clase_de_documento_id]}\t#{d[:tipo_de_documento_id]}\t#{d[:numero_de_documento]}\t#{d[:codigo_de_prestacion_informado]}\t#{d[:prestacion_id]}\t#{d[:historia_clinica]}\t#{d[:afiliado_id]}\t#{d[:fecha_ultima_menstruacion]}\t#{d[:fecha_probable_parto]}\t#{d[:cantidad]}\n"
      end
    end
    importacion_general.chomp!

    return importacion_general
  end

  def importar_registros_general
    # El parámetro 'detalle_general' ya contiene los datos procesados, importarlos en el sistema
    params[:detalle_general].split("\n").each do |linea|
      fp, ape, nom, cd, td, nd, cpi, pr, hc, afi, fum, fpp, cant = linea.chomp.split("\t")
      begin
        rp = RegistroDePrestacion.create({:fecha_de_prestacion => fp, :apellido => ape, :nombre => nom,
          :clase_de_documento_id => cd, :tipo_de_documento_id => td, :numero_de_documento => nd,
          :codigo_de_prestacion_informado => cpi, :prestacion_id => pr, :historia_clinica => hc,
          :afiliado_id => afi, :estado_de_la_prestacion_id => 2, :cuasi_factura_id => @cuasi_factura.id,
          :nomenclador_id => @nomenclador.id, :cantidad => cant})
        if fum && !fum.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 11,
            :valor => fum})
        end
        if fpp && !fpp.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 12,
            :valor => fpp})
        end
      rescue
        return false
      end
    end

    return true
  end

  def procesar_registro_general(linea)
    # Separar los campos y analizarlos
    fecha, nombre, clase, tipo, numero, hc, fum, fpp, prestacion = linea.chomp.strip.split("\t")

    # Obtener el código de prestación informado
    prestacion_id, codigo = a_prestacion(prestacion || "")
    # Regresar nil si no se encontró un código (¿línea vacía?)
    return nil if !codigo

    # Convertir cada campo a su tipo de datos correspondiente
    fecha_de_prestacion = a_fecha(fecha || "")
    clase_de_documento_id = a_clase(clase || "")
    tipo_de_documento_id = a_tipo(tipo || "")
    numero_de_documento = a_documento(numero || "")
    historia_clinica = (hc ? hc.strip.upcase : nil)
    cantidad = 1

    # Intentar encontrar al afiliado
    afiliados, nivel_concordancia = Afiliado.busqueda_por_aproximacion(numero_de_documento, (nombre ? nombre.upcase : ""))
    if afiliados && afiliados.size == 1
      apellido = afiliados.first.apellido
      nombre = afiliados.first.nombre
      afiliado_id = afiliados.first.afiliado_id
    else
      apellido, nombre = separar_nombre(nombre ? nombre.upcase : "")
      afiliado_id = nil
    end

    if prestacion_id
      # Verificar si la prestación paga adicional por prestación (cantidad variable)
      begin
        asignacion_de_precios = AsignacionDePrecios.where(:prestacion_id => prestacion_id, :nomenclador_id => @nomenclador.id).first
        if asignacion_de_precios && asignacion_de_precios.adicional_por_prestacion > 0.0
          # Asignar la cantidad desde el renglón de la cuasi-factura
          renglon = RenglonDeCuasiFactura.where(:cuasi_factura_id => @cuasi_factura.id, :codigo_de_prestacion_informado => codigo).first
          if renglon
            cantidad = renglon.cantidad_informada
          end
        end
      rescue
      end
    end

    fecha_ultima_menstruacion = a_fecha(fum || "")
    fecha_probable_parto = a_fecha(fpp || "")

    return { :fecha_de_prestacion => fecha_de_prestacion, :clase_de_documento_id => clase_de_documento_id,
      :tipo_de_documento_id => tipo_de_documento_id, :numero_de_documento => numero_de_documento,
      :apellido => apellido, :nombre => nombre, :afiliado_id => afiliado_id,
      :codigo_de_prestacion_informado => codigo, :prestacion_id => prestacion_id,
      :historia_clinica => historia_clinica, :fecha_ultima_menstruacion => fecha_ultima_menstruacion,
      :fecha_probable_parto => fecha_probable_parto, :cantidad => cantidad }

  end

  def procesar_registros_parto
    # Procesar los datos importados para la verificación preliminar
    importacion_parto = ""
    params[:detalle_parto].chomp.split("\n").each do |linea|
      if (d = procesar_registro_parto(linea))
        @detalle << d
        if @resumen.has_key?(d[:codigo_de_prestacion_informado])
          @resumen[d[:codigo_de_prestacion_informado]] += (d[:cantidad] || 1)
        else
          @resumen.merge! d[:codigo_de_prestacion_informado] => (d[:cantidad] || 1)
        end
        importacion_parto += "#{d[:fecha_de_prestacion]}\t#{d[:apellido]}\t#{d[:nombre]}\t#{d[:clase_de_documento_id]}\t#{d[:tipo_de_documento_id]}\t#{d[:numero_de_documento]}\t#{d[:codigo_de_prestacion_informado]}\t#{d[:prestacion_id]}\t#{d[:historia_clinica]}\t#{d[:afiliado_id]}\t#{d[:fecha_de_parto]}\t#{d[:apgar_5]}\t#{d[:peso_recien_nacido]}\t#{d[:vdrl_antitetanica]}\t#{d[:consejeria_salud_reproductiva]}\n"
      end
    end
    importacion_parto.chomp!

    return importacion_parto
  end

  def importar_registros_parto
    # El parámetro 'detalle_parto' ya contiene los datos procesados, importarlos en el sistema
    params[:detalle_parto].split("\n").each do |linea|
      fp, ape, nom, cd, td, nd, cpi, pr, hc, afi, fpa, a5, prn, va, csr = linea.chomp.split("\t")
      begin
        rp = RegistroDePrestacion.create({:fecha_de_prestacion => fp, :apellido => ape, :nombre => nom,
          :clase_de_documento_id => cd, :tipo_de_documento_id => td, :numero_de_documento => nd,
          :codigo_de_prestacion_informado => cpi, :prestacion_id => pr, :historia_clinica => hc,
          :afiliado_id => afi, :estado_de_la_prestacion_id => 2, :cuasi_factura_id => @cuasi_factura.id,
          :nomenclador_id => @nomenclador.id})
        if fpa && !fpa.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 13,
            :valor => fpa})
        end
        if a5 && !a5.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 14,
            :valor => a5})
        end
        if prn && !prn.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 15,
            :valor => prn})
        end
        if va && !va.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 16,
            :valor => va})
        end
        if csr && !csr.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 17,
            :valor => csr})
        end
      rescue
        return false
      end
    end

    return true
  end

  def procesar_registro_parto(linea)
    # Separar los campos y analizarlos
    fecha, nombre, clase, tipo, numero, hc, prestacion, fparto, apgar, peso, vdrl, consejeria = linea.chomp.strip.split("\t")

    # Obtener el código de prestación informado
    prestacion_id, codigo = a_prestacion(prestacion || "")
    # Regresar nil si no se encontró un código (¿línea vacía?)
    return nil if !codigo

    # Convertir cada campo a su tipo de datos correspondiente
    fecha_de_prestacion = a_fecha(fecha || "")
    clase_de_documento_id = a_clase(clase || "")
    tipo_de_documento_id = a_tipo(tipo || "")
    numero_de_documento = a_documento(numero || "")
    historia_clinica = (hc ? hc.strip.upcase : nil)

    # Intentar encontrar al afiliado
    afiliados, nivel_concordancia = Afiliado.busqueda_por_aproximacion(numero_de_documento, (nombre ? nombre.upcase : ""))
    if afiliados && afiliados.size == 1
      apellido = afiliados.first.apellido
      nombre = afiliados.first.nombre
      afiliado_id = afiliados.first.afiliado_id
    else
      apellido, nombre = separar_nombre(nombre ? nombre.upcase : "")
      afiliado_id = nil
    end

    fecha_de_parto = a_fecha(fparto || "")
    apgar_5 = a_apgar(apgar || "")
    peso_recien_nacido = a_peso_rn(peso || "")
    vdrl_antitetanica = a_si_no(vdrl || "")
    consejeria_salud_reproductiva = a_si_no(consejeria || "")

    return { :fecha_de_prestacion => fecha_de_prestacion, :clase_de_documento_id => clase_de_documento_id,
      :tipo_de_documento_id => tipo_de_documento_id, :numero_de_documento => numero_de_documento,
      :apellido => apellido, :nombre => nombre, :afiliado_id => afiliado_id,
      :codigo_de_prestacion_informado => codigo, :prestacion_id => prestacion_id,
      :fecha_de_parto => fecha_de_parto, :historia_clinica => historia_clinica,
      :apgar_5 => apgar_5, :peso_recien_nacido => peso_recien_nacido, :vdrl_antitetanica => vdrl_antitetanica,
      :consejeria_salud_reproductiva => consejeria_salud_reproductiva }
  end

  def procesar_registros_incubadora
    # Procesar los datos importados para la verificación preliminar
    importacion_incubadora = ""
    params[:detalle_incubadora].chomp.split("\n").each do |linea|
      if (d = procesar_registro_incubadora(linea))
        @detalle << d
        if @resumen.has_key?(d[:codigo_de_prestacion_informado])
          @resumen[d[:codigo_de_prestacion_informado]] += (d[:cantidad] || 1)
        else
          @resumen.merge! d[:codigo_de_prestacion_informado] => (d[:cantidad] || 1)
        end
        importacion_incubadora += "#{d[:fecha_de_prestacion]}\t#{d[:apellido]}\t#{d[:nombre]}\t#{d[:clase_de_documento_id]}\t#{d[:tipo_de_documento_id]}\t#{d[:numero_de_documento]}\t#{d[:codigo_de_prestacion_informado]}\t#{d[:prestacion_id]}\t#{d[:historia_clinica]}\t#{d[:afiliado_id]}\t#{d[:cantidad]}\t#{d[:fecha_de_parto]}\t#{d[:apgar_5]}\t#{d[:peso_recien_nacido]}\n"
      end
    end
    importacion_incubadora.chomp!

    return importacion_incubadora
  end

  def importar_registros_incubadora
    # El parámetro 'detalle_incubadora' ya contiene los datos procesados, importarlos en el sistema
    params[:detalle_incubadora].split("\n").each do |linea|
      fp, ape, nom, cd, td, nd, cpi, pr, hc, afi, cant, fpa, a5, prn = linea.chomp.split("\t")
      begin
        rp = RegistroDePrestacion.create({:fecha_de_prestacion => fp, :apellido => ape, :nombre => nom,
          :clase_de_documento_id => cd, :tipo_de_documento_id => td, :numero_de_documento => nd,
          :codigo_de_prestacion_informado => cpi, :prestacion_id => pr, :historia_clinica => hc,
          :afiliado_id => afi, :estado_de_la_prestacion_id => 2, :cuasi_factura_id => @cuasi_factura.id,
          :nomenclador_id => @nomenclador.id, :cantidad => cant})
        if fpa && !fpa.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 13,
            :valor => fpa})
        end
        if a5 && !a5.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 14,
            :valor => a5})
        end
        if prn && !prn.empty?
          RegistroDeDatoAdicional.create({:registro_de_prestacion_id => rp.id, :dato_adicional_id => 15,
            :valor => prn})
        end
      rescue
        return false
      end
    end

    return true
  end

  def procesar_registro_incubadora(linea)
    # Separar los campos y analizarlos
    fecha, nombre, clase, tipo, numero, hc, prestacion, cant, fparto, apgar, peso = linea.chomp.strip.split("\t")

    # Obtener el código de prestación informado
    prestacion_id, codigo = a_prestacion(prestacion || "")
    # Regresar nil si no se encontró un código (¿línea vacía?)
    return nil if !codigo

    # Convertir cada campo a su tipo de datos correspondiente
    fecha_de_prestacion = a_fecha(fecha || "")
    clase_de_documento_id = a_clase(clase || "")
    tipo_de_documento_id = a_tipo(tipo || "")
    numero_de_documento = a_documento(numero || "")
    historia_clinica = (hc ? hc.strip.upcase : nil)

    # Intentar encontrar al afiliado
    afiliados, nivel_concordancia = Afiliado.busqueda_por_aproximacion(numero_de_documento, (nombre ? nombre.upcase : ""))
    if afiliados && afiliados.size == 1
      apellido = afiliados.first.apellido
      nombre = afiliados.first.nombre
      afiliado_id = afiliados.first.afiliado_id
    else
      apellido, nombre = separar_nombre(nombre ? nombre.upcase : "")
      afiliado_id = nil
    end

    cantidad = a_cantidad(cant || "")
    fecha_de_parto = a_fecha(fparto || "")
    apgar_5 = a_apgar(apgar || "")
    peso_recien_nacido = a_peso_rn(peso || "")

    return { :fecha_de_prestacion => fecha_de_prestacion, :clase_de_documento_id => clase_de_documento_id,
      :tipo_de_documento_id => tipo_de_documento_id, :numero_de_documento => numero_de_documento,
      :apellido => apellido, :nombre => nombre, :afiliado_id => afiliado_id,
      :codigo_de_prestacion_informado => codigo, :prestacion_id => prestacion_id,
      :cantidad => cantidad, :fecha_de_parto => fecha_de_parto, :historia_clinica => historia_clinica,
      :apgar_5 => apgar_5 }
  end

  def resultado_verificacion(codigo_informado, informada, digitalizada, monto_informado, subtotal_informado)
    codigo = nil
    precio_por_unidad = nil
    adicional_por_prestacion = nil
    subtotal = nil
    autorizada = false
    error = false

    # Buscar el código de la prestación
    prestacion = Prestacion.find_by_codigo(codigo_informado)
    if prestacion
      codigo = prestacion.codigo
      ids_prestaciones_autorizadas = PrestacionAutorizada.autorizadas_antes_del_dia(@cuasi_factura.efector_id, (Date.new(@cuasi_factura.liquidacion.anio_de_prestaciones, @cuasi_factura.liquidacion.mes_de_prestaciones, 1) + 1)).collect {|p| p.prestacion_id}
      autorizada = true if ids_prestaciones_autorizadas.member?(prestacion.id)
      if autorizada
        asignacion_de_precios = AsignacionDePrecios.where(:nomenclador_id => @cuasi_factura.nomenclador_id, :prestacion_id => prestacion.id).first
        if asignacion_de_precios
          precio_por_unidad = asignacion_de_precios.precio_por_unidad
          adicional_por_prestacion = asignacion_de_precios.adicional_por_prestacion
        end
      end
    end

    case
      when !codigo
        error = true
        mensaje = "El código de la prestación no existe."
      when !autorizada
        error = true
        mensaje = "La prestación no está autorizada."
      when !precio_por_unidad
        error = true
        mensaje = "La prestación no está incluida en el nomenclador."
      when !adicional_por_prestacion && (precio_por_unidad != (monto_informado || 0.0))
        error = true
        mensaje = "El precio unitario informado no es correcto."
    end
    
    diferencia = ((informada || 0) - (digitalizada || 0))
    if !error && diferencia != 0
      error = true
      mensaje = "\nDiferencia algebraica."
    end

    return [error, error ? mensaje : "Verificación correcta"]
  end
end
