class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  helper_method :user_required, :admin_required, :current_user

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def user_required
    unless current_user
      store_location
      redirect_to root_url, :notice => "Debe iniciar la sesión antes de intentar acceder a esta página."
      return false
    end
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
    puts request.inspect
    session[:return_to] = request.url
  end

  def redirect_to_stored(notice)
    redirect_to (session[:return_to] || root_url), :notice => notice
    session[:return_to] = nil
  end

private
 
  def parametro_fecha(hash, clave)
    atributo = clave.to_s
    return Date.new(hash[atributo + '(1i)'].to_i, hash[atributo + '(2i)'].to_i, hash[atributo + '(3i)'].to_i)   
  end

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
    return fecha
  end

  def a_clase(cadena)
    clase_de_documento = nil
    begin
      clase_de_documento = ClaseDeDocumento.where("codigo_para_prestaciones = ?", cadena.strip.upcase).first
    rescue
    end
    return (clase_de_documento ? clase_de_documento.id : nil)
  end

  def a_tipo(cadena)
    tipo_de_documento = nil
    begin
      tipo_de_documento = TipoDeDocumento.where("codigo = ?", cadena.strip.upcase.gsub(".", "")).first
    rescue
    end
    return (tipo_de_documento ? tipo_de_documento.id : nil)
  end

  def a_documento(cadena)
    # Intentar encontrar una concordancia con el formato de número de documento
    concordancia = /.*?([[:digit:]]+).*/i.match(cadena.strip.gsub(".", ""))
    return (concordancia ? concordancia[1].to_i : nil)
  end

  def a_cantidad(cadena)
    # Intentar encontrar una concordancia con el formato de la cantidad
    cantidad = cadena.strip.to_i.abs
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
    codigo_de_prestacion = cadena.strip.upcase.gsub("-", " ").gsub(/[ ]+/, " ").gsub(/([[:alpha:]]+)([[:digit:]]+)/i,
      '\1 \2').gsub(/([[:digit:]]+)([[:alpha:]]+)/i, '\1 \2')
      begin
        if codigo_de_prestacion.match(/[ ]*\(.*\)/)
          prestacion = Prestacion.where("codigo = ?", codigo_de_prestacion.gsub(/[ ]*\(.*\)/, "")).first
        else
          prestacion = Prestacion.where("codigo = ?", codigo_de_prestacion).first
        end
      rescue
      end
    return [(prestacion ? prestacion.id : nil), codigo_de_prestacion]
  end

  def a_control(cadena)
    # TODO: Agregar validaciones en el número de controles
    controles = nil
    concordancia = /.*?([[:digit:]]+).*?/i.match(cadena.strip)
    return (concordancia ? concordancia[1].to_i : nil)
  end

  def a_peso(cadena)
    # TODO: Agregar validaciones para el peso (mín. y máx.)
    peso = cadena.strip.gsub(",", ".").to_f

    # Convertir a escala en kilogramos si evidentemente fue ingresado en gramos
    peso = peso / 1000.0 if peso >= 500.0

    return (peso >= 0.5 && peso < 100.0 ? peso : nil)
  end

  def a_peso_rn(cadena)
    # TODO: Agregar validaciones para el peso (mín. y máx.)
    peso = cadena.strip.gsub(",", ".").to_f

    # Convertir a escala en kilogramos si evidentemente fue ingresado en gramos
    peso = peso / 1000.0 if peso >= 500.0

    return (peso >= 0.5 && peso < 10.0 ? peso : nil)
  end

  def a_talla(cadena)
    # TODO: Agregar validaciones para la talla (mín. y máx.)
    talla = cadena.strip.gsub(",", ".").to_f

    # Convertir a escala en centímetros si evidentemente fue ingresado en metros
    talla = talla * 100.0 if talla > 0.0 && talla < 2.0

    return (talla > 10.0 && talla < 200.0 ? talla.to_i : nil)
  end

  def a_perimetro(cadena)
    # TODO: Agregar validaciones para el perímetro cefálico (mín. y máx.)
    perimetro = cadena.strip.gsub(",", ".").to_f

    # Convertir a escala en centímetros si fue ingresado en milímetros
    perimetro = perimetro / 100.0 if perimetro > 100.0 && perimetro < 700.0

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
        return nil
    end
  end

  def a_percentil_pce(cadena)
    # TODO: Mejorar estos procesos. Incorporar curvas de la OMS.
    valor_pce = cadena.strip.upcase
    return nil if (valor_pce.empty? || valor_pce == "-")

    case
      when /.*-.*?2.*?DS.*?+.*?2.*?DS.*/i.match(valor_pce) || valor_pce == "N" || (3..97) === ((valor_pce.split("-"))[0] ? (valor_pce.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i.abs : nil)
        return 2
      when /.*?-.*?2.*?DS.*/i.match(valor_pce) || (1..2) === ((valor_pce.split("-"))[0] ? (valor_pce.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i.abs : nil)
        return 1
      when /.*?+.*?2.*?DS.*/i.match(valor_pce) || (98..100) === ((valor_pce.split("-"))[0] ? (valor_pce.split("-"))[0].gsub(/[^[:digit:]]+/, "").to_i.abs : nil)
        return 3
      else
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

    return ((1..10) === apgar ? apgar : nil)
  end

  def a_si_no(cadena)
    case
      when cadena.strip.upcase.match(/S/) || cadena.strip.upcase == "VERDADERO"
        return 1
      when cadena.strip.upcase.match(/N/) || cadena.strip.upcase == "FALSO"
        return 2
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
    return efector_id
  end

  def a_precio(cadena)
    # TODO: Agregar validaciones
    precio = cadena.strip.gsub(",", ".").to_f

    return (precio > 0 && precio < 100000.0 ? precio : nil)
  end

end
