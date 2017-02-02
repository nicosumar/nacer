# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  attr_reader :uad_actual
  helper :all
  helper_method :admin_required, :modelos_autorizados, :uad_actual
  before_filter :establecer_uad

  # establecer_uad
  # Cambia la ruta de búsqueda de esquemas de PostgreSQL para que el usuario acceda prioritariamente
  # a las tablas asociadas con la UAD en la que está habilitado a operar.
  def establecer_uad
    @uad_actual = nil
    if !session[:codigo_uad_actual].blank?
      # Algunos recomiendan limpiar la caché antes de cambiar la ruta de búsqueda
      # de esquemas (parece que por un bug ya corregido, pero no lastima a nadie hacerlo).
      ActiveRecord::Base.connection.clear_cache!

      # Ejecutamos en un bloque con recuperación por si se produce un error
      begin
        # Cambiamos la ruta de búsqueda sobre la conexión ActiveRecord
        ActiveRecord::Base.connection.schema_search_path = "uad_#{session[:codigo_uad_actual]}, public"
        @uad_actual = UnidadDeAltaDeDatos.find_by_codigo!(session[:codigo_uad_actual])
      rescue
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "Se produjo un error al iniciar la sesión",
            :mensaje => "Sus credenciales son correctas, pero se produjo un error desconocido al intentar asignar su UAD. " +
                        "Póngase en contacto con los administradores del sistema para solucionar este inconveniente."
          }
        )
        return false
      end
    end

    return true
  end

  def admin_required
    if !current_user
      store_location
      redirect_to root_url, :notice => "Debe iniciar una sesión de administrador antes de intentar acceder a esta página."
      return false
    else
      return true if current_user.in_group? :administradores
      redirect_to root_url, :notice => "Sólo los administradores pueden acceder a esta página."
      return false
    end
  end

  def store_location
    session[:return_to] = request.url
  end

  def redirect_to_stored(info)
    redirect_to((session[:return_to] || root_url), :flash => info)
    session[:return_to] = nil
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, session)
  end

  def parametro_fecha(hash, clave)
    atributo = clave.to_s
    return Date.new(hash[atributo + '(1i)'].to_i, hash[atributo + '(2i)'].to_i, hash[atributo + '(3i)'].to_i)
  end

  def modelos_autorizados
    autorizados = []
    if current_user
      autorizados << :afiliados if can? :read, Afiliado
      autorizados << :novedades_de_los_afiliados if can? :read, NovedadDelAfiliado
      autorizados << :contactos if can? :read, Contacto
      autorizados << :convenios_de_gestion if can? :read, ConvenioDeGestion
      autorizados << :convenios_de_administracion if can? :read, ConvenioDeAdministracion
      autorizados << :efectores if can? :read, Efector
      autorizados << :users if can? :read, User
      autorizados << :addendas if can? :read, Addenda
      autorizados << :prestaciones_brindadas if can? :read, PrestacionBrindada
      autorizados << :convenios_de_gestion_sumar if can? :read, ConvenioDeGestionSumar
      autorizados << :convenios_de_administracion_sumar if can? :read, ConvenioDeAdministracionSumar
      autorizados << :addendas_sumar if can? :read, AddendaSumar
    end
    return autorizados
  end

private
  def a_fecha(cadena)
    # Intentar encontrar una concordancia con el formato de fecha
    fecha = nil
    concordancia = /.*?([[:digit:]]+)[^[:digit:]]+([[:digit:]]+)[^[:digit:]]([[:digit:]]+)/i.match(cadena)
    if concordancia
      dia, mes, año = concordancia[1,3]
      # Corregir años que no incluyan el siglo
      if año.size == 2 then año = "20" + año end
      begin # Intentar crear un objeto Date con los datos capturados
        fecha = Date.new(año.to_i, mes.to_i, dia.to_i)
      rescue ArgumentError
      end
    end
    if cadena && !cadena.empty? && !fecha
      logger.warn "a_fecha: ADVERTENCIA, no pude determinar el formato de fecha de la cadena '#{cadena}'."
    end
    return fecha
  end

  def a_clase(cadena)
    clase_de_documento = nil
    begin
      clase_de_documento = ClaseDeDocumento.where("codigo_para_prestaciones = ?", cadena.strip.upcase).first
    rescue
    end
    if cadena && !cadena.empty? && !clase_de_documento
      logger.warn "a_clase: ADVERTENCIA, no pude determinar la clase de documento desde la cadena '#{cadena}'."
    end
    return (clase_de_documento ? clase_de_documento.id : nil)
  end

  def a_tipo(cadena)
    tipo_de_documento = nil
    begin
      tipo_de_documento = TipoDeDocumento.where("codigo = ?", cadena.strip.upcase.gsub(".", "")).first
    rescue
    end
    if cadena && !cadena.empty? && !tipo_de_documento
      logger.warn "a_tipo: ADVERTENCIA, no pude determinar el tipo de documento desde la cadena '#{cadena}'."
    end
    return (tipo_de_documento ? tipo_de_documento.id : nil)
  end

  def a_documento(cadena)
    # Intentar encontrar una concordancia con el formato de número de documento
    concordancia = /.*?([[:digit:]]+).*/i.match(cadena.strip.gsub(".", ""))
    if cadena && !cadena.empty? && !concordancia
      logger.warn "a_documento: ADVERTENCIA, no pude determinar el número de documento desde la cadena '#{cadena}'."
    end
    return (concordancia ? concordancia[1] : nil)
  end

  def a_cantidad(cadena)
    # Intentar encontrar una concordancia con el formato de la cantidad
    cantidad = cadena.strip.to_i.abs
    if cadena && !cadena.empty? && !((1..2) === cantidad)
      logger.warn "a_cantidad: ADVERTENCIA, no pude determinar la cantidad de días de internación desde la cadena '#{cadena}'."
    end
    return ((1..2) === cantidad ? cantidad : nil)
  end

  def separar_nombre(cadena)
    # Intentar separar el apellido del nombre utilizando el carácter ','
    apellido, nombre = cadena.strip.split(",")
    return [apellido.strip, nombre.strip] if nombre

    # No hay separador, separar la primer cadena hasta un carácter de espacio como apellido y el resto como nombre
    # TODO: mejorar este método mediante separación de todas las subcadenas y apareado estadístico con conjuntos
    # de apellidos y nombres.
    concordancia = /(.*?)[ ]+(.*)/i.match(cadena.strip)
    return (concordancia ? concordancia[1,2] : nil)
  end

  def a_prestacion(cadena)
    prestacion = nil

    # La cadena de entrada se normaliza antes de buscarla en la base de datos
    codigo_de_prestacion = cadena.strip.upcase

    # Regresar nulos si se pasó un código de prestación en blanco (probablemente una línea en blanco en la
    # digitalización).
    return [nil, nil] if codigo_de_prestacion.empty?

    begin
      # Eliminar el sufijo de unicidad que se añade a las prestaciones que pagan adicionales por prestación.
      # Por ejemplo, la 'TMI 71'.
      if codigo_de_prestacion.match(/[ ]*\(.*\)/)
        prestacion = Prestacion.where("codigo = ?", codigo_de_prestacion.gsub(/[ ]*\(.*\)/, "").gsub(/[^[:alpha:][:digit:]]/,"")).first
      else
        prestacion = Prestacion.where("codigo = ?", codigo_de_prestacion.gsub(/[^[:alpha:][:digit:]]/,"")).first
      end
    rescue
    end
    if cadena && !cadena.empty? && !prestacion
      logger.warn "a_prestacion: ADVERTENCIA, no pude determinar el código de prestación desde la cadena '#{cadena}'."
    end
    return [(prestacion ? prestacion.id : nil), codigo_de_prestacion]
  end

  def a_control(cadena)
    # TODO: Agregar validaciones en el número de controles
    controles = nil
    concordancia = /.*?([[:digit:]]+).*?/i.match(cadena.strip)
    if cadena && !cadena.empty? && !concordancia
      logger.warn "a_control: ADVERTENCIA, no pude determinar el número de control desde la cadena '#{cadena}'."
    end
    return (concordancia ? concordancia[1].to_i : nil)
  end

  def a_peso(cadena)
    # TODO: Agregar validaciones para el peso (mín. y máx.)
    peso = cadena.strip.gsub(",", ".").to_f
    # Convertir a escala en kilogramos si evidentemente fue ingresado en gramos
    peso = peso / 1000.0 if peso >= 500.0
    if cadena && !cadena.empty? && !(peso >= 0.5 && peso < 100.0)
      logger.warn "a_peso: ADVERTENCIA, no pude determinar el peso desde la cadena '#{cadena}'."
    end
    return (peso >= 0.5 && peso < 100.0 ? peso : nil)
  end

  def a_peso_rn(cadena)
    # TODO: Agregar validaciones para el peso (mín. y máx.)
    peso = cadena.strip.gsub(",", ".").to_f
    # Convertir a escala en kilogramos si evidentemente fue ingresado en gramos
    peso = peso / 1000.0 if peso >= 500.0
    if cadena && !cadena.empty? && !(peso >= 0.5 && peso < 10.0)
      logger.warn "a_peso_rn: ADVERTENCIA, no pude determinar el peso del RN desde la cadena '#{cadena}'."
    end
    return (peso >= 0.5 && peso < 10.0 ? peso : nil)
  end

  def a_talla(cadena)
    # TODO: Agregar validaciones para la talla (mín. y máx.)
    talla = cadena.strip.gsub(",", ".").to_f
    # Convertir a escala en centímetros si evidentemente fue ingresado en metros
    talla = talla * 100.0 if talla > 0.0 && talla < 2.0
    if cadena && !cadena.empty? && !(talla > 10.0 && talla < 200.0)
      logger.warn "a_talla: ADVERTENCIA, no pude determinar la talla desde la cadena '#{cadena}'."
    end
    return (talla > 10.0 && talla < 200.0 ? talla.to_i : nil)
  end

  def a_perimetro(cadena)
    # TODO: Agregar validaciones para el perímetro cefálico (mín. y máx.)
    perimetro = cadena.strip.gsub(",", ".").to_f
    # Convertir a escala en centímetros si fue ingresado en milímetros
    perimetro = perimetro / 100.0 if perimetro > 100.0 && perimetro < 700.0
    if cadena && !cadena.empty? && !(perimetro > 10.0 && perimetro < 70.0)
      logger.warn "a_perimetro: ADVERTENCIA, no pude determinar el perímetro cefálico desde la cadena '#{cadena}'."
    end
    return (perimetro > 10.0 && perimetro < 70.0 ? perimetro.to_i : nil)
  end

  def a_percentil_pe(cadena)
    # TODO: Mejorar estos procesos. Incorporar curvas de la OMS.
    valor_pe = cadena.strip.upcase
    return nil if (valor_pe.empty? || valor_pe == "-")
    case
      when /.*desn.*/i.match(valor_pe) || /.*bp.*/i.match(valor_pe) || /.*?<.*?10.*/i.match(valor_pe) || (1..9) === ((valor_pe.split("-"))[0] ? (valor_pe.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i.abs : nil)
        return 1
      when /.*?10.*?90.*/i.match(valor_pe) || valor_pe == "N" || (10..90) === ((valor_pe.split("-"))[0] ? (valor_pe.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i.abs : nil)
        return 2
      when /.*obes.*/i.match(valor_pe) || /.*sobre.*/i.match(valor_pe) || /.*?>.*?90.*/i.match(valor_pe) || (91..100) === ((valor_pe.split("-"))[0] ? (valor_pe.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i.abs : nil)
        return 3
      else
        logger.warn "a_percentil_pe: ADVERTENCIA, no pude determinar el percentil P/E desde la cadena '#{cadena}'."
        return nil
    end
  end

  def a_percentil_te(cadena)
    # TODO: Mejorar estos procesos. Incorporar curvas de la OMS.
    valor_te = cadena.strip.upcase
    return nil if (valor_te.empty? || valor_te == "-")
    case
      when /.*desn.*/i.match(valor_te) || /.*bp.*/i.match(valor_te) || /.*-3.*/i.match(valor_te) || (1..2) === ((valor_te.split("-"))[0] ? (valor_te.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i.abs : nil)
        return 1
      when /.*?3.*?97.*/i.match(valor_te) || valor_te == "N" || (3..97) === ((valor_te.split("-"))[0] ? (valor_te.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i.abs : nil)
        return 2
      when /.*obes.*/i.match(valor_te) || /.*sobre.*/i.match(valor_te) || /.*?[>+].*?97.*/i.match(valor_te) || (98..100) === ((valor_te.split("-"))[0] ? (valor_te.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i.abs : nil)
        return 3
      else
        logger.warn "a_percentil_te: ADVERTENCIA, no pude determinar el percentil T/E desde la cadena '#{cadena}'."
        return nil
    end
  end

  def a_percentil_pce(cadena)
    # TODO: Mejorar estos procesos. Incorporar curvas de la OMS.
    valor_pce = cadena.strip.upcase
    return nil if (valor_pce.empty? || valor_pce == "-")
    case
      when /.*-.*?2.*?2.*/i.match(valor_pce) || valor_pce == "N" || (3..97) === ((valor_pce.split("-"))[0] ? (valor_pce.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i.abs : nil)
        return 2
      when /.*?-.*?2.*/i.match(valor_pce) || (1..2) === ((valor_pce.split("-"))[0] ? (valor_pce.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i.abs : nil)
        return 1
      when /.*2.*/i.match(valor_pce) || (98..100) === ((valor_pce.split("-"))[0] ? (valor_pce.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i.abs : nil)
        return 3
      else
        logger.warn "a_percentil_pce: ADVERTENCIA, no pude determinar el percentil PC/E desde la cadena '#{cadena}'."
        return nil
    end
  end

  def a_percentil_pt(cadena)
    # TODO: Mejorar estos procesos. Incorporar curvas de la OMS.
    valor_pt = cadena.strip.upcase
    return nil if (valor_pt.empty? || valor_pt == "-")
    case
      when /.*?-.*?10.*?+.*?10.*/i.match(valor_pt) || valor_pt == "N" || (1..10) === ((valor_pt.split("-"))[0] ? (valor_pt.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i : nil) || (-10..-1) === valor_pt.gsub(/[[:alpha:]]+/, "").to_i
        return 2
      when /.*desn.*/i.match(valor_pt) || /.*bp.*/i.match(valor_pt) || /.*?-.*?10.*/i.match(valor_pt) || valor_pt.gsub(/[^[:digit:]]+/, "").to_i < -10
        return 1
      when /.*obes.*/i.match(valor_pt) || /.*sobre.*/i.match(valor_pt) || /.*?10.*/i.match(valor_pt) || valor_pt.gsub(/[^[:digit:]]+/, "").to_i > 10
        return 3
      else
        logger.warn "a_percentil_pt: ADVERTENCIA, no pude determinar el percentil P/T desde la cadena '#{cadena}'."
        return nil
    end
  end

  def a_apgar(cadena)
    #TODO: Mejorar estos procesos.
    if (concordancia = cadena.match(/.*?[[:digit:]]+.*?[-\/,].*?([[:digit:]]+)/))
      apgar = concordancia[1].to_i
    else
      apgar = cadena.strip.to_i
    end
    if cadena && !cadena.empty? && !((1..10) === apgar)
      logger.warn "a_apgar: ADVERTENCIA, no pude determinar el Apgar de 5' desde la cadena '#{cadena}'."
    end
    return ((1..10) === apgar ? apgar : nil)
  end

  def a_si_no(cadena)
    case
      when cadena.strip.upcase.match(/S/) || cadena.strip.upcase == "VERDADERO" || cadena.strip.match(/\+/)
        return 1
      when cadena.strip.upcase.match(/N/) || cadena.strip.upcase == "FALSO" || cadena.strip.match(/-/)
        return 2
    end
    if cadena && !cadena.empty?
      logger.warn "a_si_no: ADVERTENCIA, no pude determinar el valor Sí/No desde la cadena '#{cadena}'."
    end
    return nil
  end

  def a_efector(cadena)
    efector_id = nil
    cuie = cadena.strip.upcase
    begin
      if cuie
        efector_id = (Efector.find_by_cuie(cuie)).id
      end
    rescue
    end
    if cadena && !cadena.empty? && !efector_id
      logger.warn "a_efector: ADVERTENCIA, no pude determinar el efector con el CUIE '#{cadena}'."
    end
    return efector_id
  end

  def a_precio(cadena)
    # TODO: Agregar validaciones
    precio = cadena.strip.gsub(",", ".").to_f
    if cadena && !cadena.empty? && !(precio > 0.0 && precio < 100000.0)
      logger.warn "a_precio: ADVERTENCIA, no pude determinar el precio desde la cadena '#{cadena}'."
    end
    return (precio > 0.0 && precio < 100000.0 ? precio : nil)
  end

end
