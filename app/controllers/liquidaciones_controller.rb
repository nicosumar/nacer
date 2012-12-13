# -*- encoding : utf-8 -*-
class LiquidacionesController < ApplicationController
  before_filter :authenticate_user!

  def index
    if can? :read, Liquidacion then
      @liquidaciones = Liquidacion.paginate(:page => params[:page], :per_page => 20, :include => [:efector, {:cuasi_facturas => :efector}],
        :order => "updated_at DESC")
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def show
    @liquidacion = Liquidacion.find(params[:id], :include => [:efector, {:cuasi_facturas => :efector}])
    if cannot? :read, @liquidacion then
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def new
    if can? :create, Liquidacion then
      @liquidacion = Liquidacion.new
      @efectores = Efector.administradores_y_autoadministrados.collect{ |e| [e.nombre_corto, e.id] }
      @efector_id = nil
      @meses_de_prestaciones = [["Enero", 1], ["Febrero", 2], ["Marzo", 3], ["Abril", 4], ["Mayo", 5], ["Junio", 6], ["Julio", 7], ["Agosto", 8],
        ["Septiembre", 9], ["Octubre", 10], ["Noviembre", 11], ["Diciembre", 12]]
      @mes_de_prestaciones = Date.today.month - 1
      @años_de_prestaciones = ((Date.today.year - 5)..(Date.today.year)).collect {|a| [a.to_s, a]}
      @año_de_prestaciones = Date.today.year
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def edit
    @liquidacion = Liquidacion.find(params[:id], :include => [:efector, {:cuasi_facturas => :efector}])
    if can? :update, @liquidacion then
      @efectores = [[@liquidacion.efector.nombre_corto, @liquidacion.efector_id]]
      @efector_id = @liquidacion.efector_id
      @meses_de_prestaciones = [["Enero", 1], ["Febrero", 2], ["Marzo", 3], ["Abril", 4], ["Mayo", 5], ["Junio", 6], ["Julio", 7], ["Agosto", 8],
        ["Septiembre", 9], ["Octubre", 10], ["Noviembre", 11], ["Diciembre", 12]]
      @mes_de_prestaciones = @liquidacion.mes_de_prestaciones
      @años_de_prestaciones = ((Date.today.year - 5)..(Date.today.year)).collect {|a| [a.to_s, a]}
      @año_de_prestaciones = @liquidacion.año_de_prestaciones
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
    end
  end

  def create
    if can? :create, Liquidacion then
      # Establecer el valor de los atributos protegidos
      @liquidacion = Liquidacion.new
      @liquidacion.efector_id = params[:liquidacion][:efector_id]
      @liquidacion.mes_de_prestaciones = params[:liquidacion][:mes_de_prestaciones]
      @liquidacion.año_de_prestaciones = params[:liquidacion][:año_de_prestaciones]

      # Establecer el valor del resto de los atributos por asignación masiva
      @liquidacion.attributes = params[:liquidacion]
    else
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    if @liquidacion.save
      redirect_to liquidacion_path(@liquidacion), :notice => 'La liquidación se creó exitosamente.'
      return
    end

    # Si la grabación falla volver a mostrar el formulario con los errores
    @efectores = Efector.administradores_y_autoadministrados.collect{ |e| [e.nombre_corto, e.id] }
    @efector_id = @liquidacion.efector_id
    @meses_de_prestaciones = [["Enero", 1], ["Febrero", 2], ["Marzo", 3], ["Abril", 4], ["Mayo", 5], ["Junio", 6], ["Julio", 7], ["Agosto", 8],
      ["Septiembre", 9], ["Octubre", 10], ["Noviembre", 11], ["Diciembre", 12]]
    @mes_de_prestaciones = @liquidacion.mes_de_prestaciones
    @años_de_prestaciones = ((Date.today.year - 5)..(Date.today.year)).collect {|a| [a.to_s, a]}
    @año_de_prestaciones = @liquidacion.año_de_prestaciones
    render :action => "new"
  end

  def update
    @liquidacion = Liquidacion.find(params[:id])
    if cannot? :update, @liquidacion then
      redirect_to root_url, :notice => "No está autorizado para realizar esta operación." 
      return
    end

    if @liquidacion.update_attributes(params[:liquidacion])
      redirect_to liquidacion_path(@liquidacion), :notice => 'Los datos de la liquidación se actualizaron correctamente.'
      return
    end

    # Si la grabación falla, mostrar el formulario con los errores
    @efectores = [[@liquidacion.efector.nombre_corto, @liquidacion.efector_id]]
    @meses_de_prestaciones = [["Enero", 1], ["Febrero", 2], ["Marzo", 3], ["Abril", 4], ["Mayo", 5], ["Junio", 6], ["Julio", 7], ["Agosto", 8],
      ["Septiembre", 9], ["Octubre", 10], ["Noviembre", 11], ["Diciembre", 12]]
    @mes_de_prestaciones = @liquidacion.mes_de_prestaciones
    @años_de_prestaciones = ((Date.today.year - 5)..(Date.today.year)).collect {|a| [a.to_s, a]}
    @año_de_prestaciones = @liquidacion.año_de_prestaciones
    render :action => "edit"
  end

#  def destroy
#  end

  def importar_archivo_p
    # Verificar los permisos del usuario
    if cannot? :create, RegistroDePrestacion
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:liquidacion_id]
      redirect_to root_url, :notice => "La petición no es válida. El incidente será reportado al administrador del sistema." 
      return
    end

    # Obtener la liquidación
    begin
      @liquidacion = Liquidacion.find(params[:liquidacion_id], :include => [:efector, {:cuasi_facturas => :efector}])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :notice => "Petición no válida. El incidente será reportado al administrador del sistema.")
    end
    @efector = @liquidacion.efector

    # Preparar los datos para la importación
    if @liquidacion.cuasi_facturas.any?
      # Ya existen cuasi-facturas importadas (petición fraguada)
      redirect_to(cuasi_factura_path(@cuasi_factura),
        :notice => "Ya se han importado o cargado datos previos para esta liquidación.")
      return
    end

    #TODO: Agregar validaciones de fechas
#    @primer_dia_de_prestaciones = Date.new(@liquidacion.año_de_prestaciones, @liquidacion.mes_de_prestaciones, 1)

    # Verificar en cuál paso del proceso nos encontramos
    if params[:commit] == "Verificar"
      @nomenclador_id = params[:nomenclador_id]
      if @nomenclador_id.nil?
        @nomencladores = Nomenclador.find(:all).collect{ |n| [n.nombre, n.id] }
        render :action => "importar_archivo_p", :notice => "Debe seleccionar un nomenclador"
        return
      end
      @detalle = []
      @resumen = {}
      @importacion_p = procesar_registros_p
    elsif params[:commit] == "Importar"
      @nomenclador_id = params[:nomenclador_id]
      if @nomenclador_id.nil?
        @nomencladores = Nomenclador.find(:all).collect{ |n| [n.nombre, n.id] }
        render :action => "importar_archivo_p", :notice => "Debe seleccionar un nomenclador"
        return
      end
      if !importar_registros_p
        redirect_to(liquidacion_path(@liquidacion),
          :notice => "Se produjo un error al intentar importar los datos. Notifique al administrador del sistema.")
        return
#      else
#        # Actualizar los renglones de la cuasi-factura con los totales de prestaciones digitalizadas.
#        begin
#          totales_digitalizados = @cuasi_factura.registros_de_prestaciones.sum(:cantidad,
#            :group => [:codigo_de_prestacion_informado, :prestacion_id])
#          totales_digitalizados.each_pair do |prestacion, cantidad_digitalizada|
#            renglon = @cuasi_factura.renglones_de_cuasi_facturas.find(:all,
#              :conditions => ["codigo_de_prestacion_informado = ?", prestacion[0]]).first
#            if renglon
#              renglon.update_attributes({:cantidad_digitalizada => cantidad_digitalizada})
#            else
#              renglon = RenglonDeCuasiFactura.new({:codigo_de_prestacion_informado => prestacion[0],
#                :monto_informado => 0.0, :subtotal_informado => 0.0, :prestacion_id => prestacion[1],
#                :cantidad_digitalizada => cantidad_digitalizada})
#              @cuasi_factura.renglones_de_cuasi_facturas << renglon
#            end
#          end
#        rescue
#          redirect_to(cuasi_factura_path(@cuasi_factura),
#            :notice => "Se produjo un error al intentar importar los datos. Notifique al administrador del sistema.")
#          return
#        end
      end
      redirect_to(liquidacion_path(@liquidacion),
        :notice => "El detalle del archivo 'P' se importó correctamente.")
    else
      # Listado de nomencladores contra el cual verificar la importación
      @nomencladores = Nomenclador.find(:all).collect{ |n| [n.nombre, n.id] }
      @nomenclador_id = nil
    end
  end

private

  def procesar_registros_p
    importacion_p = ""
    params[:detalle_p].chomp.split("\n").each do |linea|
      if (d = procesar_registro_p(linea))
        @detalle << d
        if d[:efector_id]
          efector = Efector.find(d[:efector_id])
          clave = efector.nombre_corto + " (" + efector.cuie + ")"
          if @resumen.has_key? clave
            if @resumen[clave].has_key? d[:codigo_de_prestacion_informado]
              @resumen[clave][d[:codigo_de_prestacion_informado]][1] += 1
            else
              @resumen[clave].merge! d[:codigo_de_prestacion_informado] => [d[:precio_unitario], 1]
            end
          else
            @resumen.merge! clave => { d[:codigo_de_prestacion_informado] => [d[:precio_unitario], 1]}
          end
        end
        importacion_p += "#{d[:efector_id]}\t#{d[:fecha_de_prestacion]}\t#{d[:clase_de_documento_id]}\t#{d[:tipo_de_documento_id]}\t#{d[:numero_de_documento]}\t#{d[:apellido]}\t#{d[:nombre]}\t#{d[:afiliado_id]}\t#{d[:fecha_de_nacimiento]}\t#{d[:codigo_de_prestacion_informado]}\t#{d[:prestacion_id]}\t#{d[:precio_unitario]}\t#{d[:historia_clinica]}\t#{d[:numero_de_informe]}\t#{d[:fecha_de_ultima_menstruacion]}\t#{d[:fecha_probable_de_parto]}\t#{d[:fecha_efectiva_de_parto]}\t#{d[:apgar_5]}\t#{d[:peso_del_rn]}\t#{d[:vdrl_antitetanica]}\t#{d[:numero_de_control]}\t#{d[:peso_actual]}\t#{d[:talla_actual]}\t#{d[:perimetro_cefalico]}\t#{d[:percentil_peso_edad_id]}\t#{d[:percentil_talla_edad_id]}\t#{d[:percentil_peso_talla_id]}\t#{d[:percentil_pc_edad_id]}\n"
      end
    end
    importacion_p.chomp!

    return importacion_p
  end

  def importar_registros_p
    # El parámetro 'detalle_p' ya contiene los datos del archivo p procesados, separar los datos por efector
    # y código de prestación
    detalle = {}
    params[:detalle_p].split("\n").each do |linea|
      efe, fp, cd, td, nd, ape, nom, afi, fn, cpi, pr, pu, hc, ni, fum, fpp, fep, a5, prn, vdrl, nc, pa, ta, pc,
        ppe, pte, ppt, ppce = linea.chomp.split("\t")
      if detalle.has_key? efe
        if detalle[efe].has_key? cpi
          detalle[efe][cpi].concat([{:fecha_de_prestacion => fp, :clase_de_documento_id => cd,
            :tipo_de_documento_id => td, :numero_de_documento => nd, :apellido => ape, :nombre => nom,
            :afiliado_id => afi, :fecha_de_nacimiento => fn, :prestacion_id => pr, :precio_unitario => pu,
            :historia_clinica => hc, :numero_de_informe => ni, :fecha_de_ultima_menstruacion => fum,
            :fecha_probable_de_parto => fpp, :fecha_efectiva_de_parto => fep, :apgar_5 => a5,
            :peso_del_rn => prn, :vdrl_antitetanica => vdrl, :numero_de_control => nc, :peso_actual => pa,
            :talla_actual => ta, :perimetro_cefalico => pc, :percentil_peso_edad_id => ppe,
            :percentil_talla_edad_id => pte, :percentil_peso_talla_id => ppt,
            :percentil_pc_edad_id => ppce}])
        else
          detalle[efe].merge! cpi => [{:fecha_de_prestacion => fp, :clase_de_documento_id => cd,
            :tipo_de_documento_id => td, :numero_de_documento => nd, :apellido => ape, :nombre => nom,
            :afiliado_id => afi, :fecha_de_nacimiento => fn, :prestacion_id => pr, :precio_unitario => pu,
            :historia_clinica => hc, :numero_de_informe => ni, :fecha_de_ultima_menstruacion => fum,
            :fecha_probable_de_parto => fpp, :fecha_efectiva_de_parto => fep, :apgar_5 => a5,
            :peso_del_rn => prn, :vdrl_antitetanica => vdrl, :numero_de_control => nc, :peso_actual => pa,
            :talla_actual => ta, :perimetro_cefalico => pc, :percentil_peso_edad_id => ppe,
            :percentil_talla_edad_id => pte, :percentil_peso_talla_id => ppt,
            :percentil_pc_edad_id => ppce}]
        end
      else
        detalle.merge! efe => { cpi => [{:fecha_de_prestacion => fp, :clase_de_documento_id => cd,
            :tipo_de_documento_id => td, :numero_de_documento => nd, :apellido => ape, :nombre => nom,
            :afiliado_id => afi, :fecha_de_nacimiento => fn, :prestacion_id => pr, :precio_unitario => pu,
            :historia_clinica => hc, :numero_de_informe => ni, :fecha_de_ultima_menstruacion => fum,
            :fecha_probable_de_parto => fpp, :fecha_efectiva_de_parto => fep, :apgar_5 => a5,
            :peso_del_rn => prn, :vdrl_antitetanica => vdrl, :numero_de_control => nc, :peso_actual => pa,
            :talla_actual => ta, :perimetro_cefalico => pc, :percentil_peso_edad_id => ppe,
            :percentil_talla_edad_id => pte, :percentil_peso_talla_id => ppt,
            :percentil_pc_edad_id => ppce}]}
      end
    end

    # Importar los datos
#    begin
      detalle.keys.each do |efector_id|
        # Calcular el total de la cuasi-factura para este efector
        total = (detalle[efector_id].collect{|prestacion| prestacion[1].size.to_f * prestacion[1][0][:precio_unitario].to_f}).sum

        # Crear la cuasi-factura
        cuasi_factura = CuasiFactura.new({:fecha_de_presentacion => @liquidacion.fecha_de_recepcion,
          :numero_de_liquidacion => ("%02d" % @liquidacion.mes_de_prestaciones) + '/' + @liquidacion.año_de_prestaciones.to_s})
        cuasi_factura.liquidacion_id = @liquidacion.id
        cuasi_factura.efector_id = efector_id
        cuasi_factura.nomenclador_id = @nomenclador_id
        cuasi_factura.total_informado = total
        cuasi_factura.save

        detalle[efector_id].keys.each do |prestacion|
          # Crear los renglones de la cuasi-factura
          prestacion_id = detalle[efector_id][prestacion][0][:prestacion_id]
          cantidad = detalle[efector_id][prestacion].size
          monto = detalle[efector_id][prestacion][0][:precio_unitario]
          subtotal = cantidad.to_f * monto.to_f
          renglon_de_cuasi_factura = RenglonDeCuasiFactura.new({:codigo_de_prestacion_informado => prestacion,
            :prestacion_id => prestacion_id, :cantidad_informada => cantidad, :monto_informado => monto,
            :subtotal_informado => subtotal, :cantidad_digitalizada => cantidad})
          cuasi_factura.renglones_de_cuasi_facturas << renglon_de_cuasi_factura

          detalle[efector_id][prestacion].each do |rp|
            # Crear los registros de las prestaciones
            registro_de_prestacion = RegistroDePrestacion.create({:fecha_de_prestacion => rp[:fecha_de_prestacion],
              :apellido => rp[:apellido], :nombre => rp[:nombre], :clase_de_documento_id => rp[:clase_de_documento_id],
              :tipo_de_documento_id => rp[:tipo_de_documento_id], :numero_de_documento => rp[:numero_de_documento],
              :codigo_de_prestacion_informado => prestacion, :prestacion_id => rp[:prestacion_id], :cantidad => 1,
              :historia_clinica => rp[:historia_clinica], :estado_de_la_prestacion_id => 2,
              :cuasi_factura_id => cuasi_factura.id, :nomenclador_id => @nomenclador_id,
              :afiliado_id => rp[:afiliado_id]})

            # Crear los registros de datos adicionales
            if rp[:fecha_de_nacimiento] && !rp[:fecha_de_nacimiento].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 1, :valor => rp[:fecha_de_nacimiento]})
            end
            if rp[:numero_de_informe] && !rp[:numero_de_informe].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 10, :valor => rp[:numero_de_informe]})
            end
            if rp[:fecha_de_ultima_menstruacion] && !rp[:fecha_de_ultima_menstruacion].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 11, :valor => rp[:fecha_de_ultima_menstruacion]})
            end
            if rp[:fecha_probable_de_parto] && !rp[:fecha_probable_de_parto].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 12, :valor => rp[:fecha_probable_de_parto]})
            end
            if rp[:fecha_efectiva_de_parto] && !rp[:fecha_efectiva_de_parto].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 13, :valor => rp[:fecha_efectiva_de_parto]})
            end
            if rp[:apgar_5] && !rp[:apgar_5].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 14, :valor => rp[:apgar_5]})
            end
            if rp[:peso_del_rn] && !rp[:peso_del_rn].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 15, :valor => rp[:peso_del_rn]})
            end
            if rp[:vdrl_antitetanica] && !rp[:vdrl_antitetanica].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 16, :valor => rp[:vdrl_antitetanica]})
            end
            if rp[:numero_de_control] && !rp[:numero_de_control].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 2, :valor => rp[:numero_de_control]})
            end
            if rp[:peso_actual] && !rp[:peso_actual].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 3, :valor => rp[:peso_actual]})
            end
            if rp[:talla_actual] && !rp[:talla_actual].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 4, :valor => rp[:talla_actual]})
            end
            if rp[:perimetro_cefalico] && !rp[:perimetro_cefalico].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 5, :valor => rp[:perimetro_cefalico]})
            end
            if rp[:percentil_peso_edad_id] && !rp[:percentil_peso_edad_id].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 6, :valor => rp[:percentil_peso_edad_id]})
            end
            if rp[:percentil_talla_edad_id] && !rp[:percentil_talla_edad_id].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 20, :valor => rp[:percentil_talla_edad_id]})
            end
            if rp[:percentil_peso_talla_id] && !rp[:percentil_peso_talla_id].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 18, :valor => rp[:percentil_peso_talla_id]})
            end
            if rp[:percentil_pc_edad_id] && !rp[:percentil_pc_edad_id].empty?
              RegistroDeDatoAdicional.create({:registro_de_prestacion_id => registro_de_prestacion.id,
                :dato_adicional_id => 7, :valor => rp[:percentil_pc_edad_id]})
            end
          end
        end
      end
#    rescue
#    end

    return true
  end

  def procesar_registro_p(linea)
    # Separar los campos y analizarlos
    tipo_de_registro, nro_prest, cuie, usuario, fecha_carga, fecha_prest, clave, nom, ape, clase_doc, tipo_doc, numero_doc,
    categoria_de_afiliado_id, sexo, fecha_nac, prestacion, subprestacion, precio, hc, nro_inf, profesional, fum, fpp, fep,
    apgar5, peso_rn, vdrl_att, nro_control, peso, talla, per_cefalico, ppe, pte, ppt, ppce, imc, pimce =
      linea.chomp.strip.split("\t")

    # Verificar si es un registro de datos
    if tipo_de_registro.strip != "P"
      return nil
    end

    # Convertir cada campo a su tipo de datos correspondiente
    efector_id = a_efector(cuie || "")
    fecha_de_prestacion = a_fecha(fecha_prest || "")

    # Intentar encontrar al afiliado
    afiliado = nil
    if clave
      begin
        afiliado = Afiliado.find_by_clave_de_beneficiario(clave.strip)
      rescue
      end
    end
    if afiliado
      apellido = afiliado.apellido
      nombre = afiliado.nombre
      afiliado_id = afiliado.afiliado_id
    else
      apellido = ape.strip.upcase
      nombre = nom.strip.upcase
      afiliado_id = nil
    end

    clase_de_documento_id = a_clase(clase_doc || "")
    tipo_de_documento_id = a_tipo(tipo_doc || "")
    numero_de_documento = a_documento(numero_doc || "")
    fecha_de_nacimiento = a_fecha(fecha_nac || "")
    prestacion_id, codigo = a_prestacion(prestacion || "")
    precio_unitario = a_precio(precio || "")
    historia_clinica = (hc ? hc.strip.upcase : nil)
    numero_de_informe = (nro_inf ? nro_inf.strip.upcase : nil)
    fecha_de_ultima_menstruacion = a_fecha(fum || "")
    fecha_probable_de_parto = a_fecha(fpp || "")
    fecha_efectiva_de_parto = a_fecha(fep || "")
    apgar_5 = a_apgar(apgar5 || "")
    peso_del_rn = a_peso_rn(peso_rn || "")
    vdrl_antitetanica = a_si_no(vdrl_att || "")
    numero_de_control = a_control(nro_control || "")
    peso_actual = a_peso(peso || "")
    talla_actual = a_talla(talla || "")
    perimetro_cefalico = a_perimetro(per_cefalico || "")
    percentil_peso_edad_id = (ppe ? (ppe.strip.empty? ? nil : ppe.strip) : nil)
    percentil_talla_edad_id = (pte ? (pte.strip.empty? ? nil : pte.strip) : nil)
    percentil_peso_talla_id = (ppt ? (ppt.strip.empty? ? nil : ppt.strip) : nil)
    percentil_pc_edad_id = (ppce ? (ppce.strip.empty? ? nil : ppce.strip) : nil)

    return { :efector_id => efector_id, :fecha_de_prestacion => fecha_de_prestacion,
      :clase_de_documento_id => clase_de_documento_id, :tipo_de_documento_id => tipo_de_documento_id,
      :numero_de_documento => numero_de_documento, :apellido => apellido, :nombre => nombre,
      :afiliado_id => afiliado_id, :fecha_de_nacimiento => fecha_de_nacimiento,
      :codigo_de_prestacion_informado => codigo, :prestacion_id => prestacion_id,
      :precio_unitario => precio_unitario,
      :historia_clinica => historia_clinica, :numero_de_informe => numero_de_informe,
      :fecha_de_ultima_menstruacion => fecha_de_ultima_menstruacion,
      :fecha_probable_de_parto => fecha_probable_de_parto,
      :fecha_efectiva_de_parto => fecha_efectiva_de_parto, :apgar_5 => apgar_5,
      :peso_del_rn => peso_del_rn, :vdrl_antitetanica => vdrl_antitetanica,
      :numero_de_control => numero_de_control, :peso_actual => peso_actual,
      :talla_actual => talla_actual, :perimetro_cefalico => perimetro_cefalico,
      :percentil_peso_edad_id => percentil_peso_edad_id,
      :percentil_talla_edad_id => percentil_talla_edad_id,
      :percentil_peso_talla_id => percentil_peso_talla_id,
      :percentil_pc_edad_id => percentil_pc_edad_id }

  end

end
