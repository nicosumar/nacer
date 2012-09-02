class AfiliadosController < ApplicationController
  before_filter :user_required

  def index
    # Verificar si el usuario tiene el acceso permitido
    if cannot? :read, Afiliado
      redirect_to root_url,
        :notice => "No está autorizado para realizar esta operación. Se ha notificado al administrador del sistema." 
      return
    end

    # Verificar si ya se envió algún patrón de búsqueda de beneficiario
    if params[:commit]
      @patron_de_busqueda = params[:patron_de_busqueda]
      if !@patron_de_busqueda || @patron_de_busqueda.strip.empty?
        @patron_de_busqueda = nil
        @afiliados_encontrados = nil
        render :action => "index", :notice => "Debe ingresar algún criterio de búsqueda."
      else
        # Preparar los resultados de la búsqueda en la vista temporal (buscar únicamente afiliados)
        inicio = Time.now()
        Busqueda.busqueda_fts(@patron_de_busqueda, :solo => :afiliados)
        @afiliados_encontrados = ResultadoDeLaBusqueda.count
        if @afiliados_encontrados > 0
          @afiliados = ResultadoDeLaBusqueda.order('orden ASC').paginate(:page => params[:page], :per_page => 20)
        end
        fin = Time.now()
        @tiempo_de_busqueda = fin - inicio
      end
    else
      @patron_de_busqueda = nil
      @afiliados_encontrados = nil
      @afiliados = nil
    end
  end

  def show
    # Verificar los permisos del usuario
    if cannot? :read, Afiliado
      redirect_to(root_url,
        :notice => "No está autorizado para realizar esta operación. El incidente será reportado al administrador del sistema.")
      return
    end

    # Obtener el beneficiario solicitado
    begin
      @afiliado = Afiliado.find(params[:id], :include => [:clase_de_documento, :tipo_de_documento, :sexo,
        :pais_de_nacimiento, :lengua_originaria, :tribu_originaria, :alfabetizacion_del_beneficiario,
        :domicilio_departamento, :domicilio_distrito, :lugar_de_atencion_habitual, :tipo_de_documento_de_la_madre,
        :alfabetizacion_de_la_madre, :tipo_de_documento_del_padre, :alfabetizacion_del_padre,
        :tipo_de_documento_del_tutor, :alfabetizacion_del_tutor, :discapacidad, :centro_de_inscripcion])
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :notice => "El beneficiario solicitado no existe. El incidente será reportado al administrador del sistema.")
      return
    end

  end

end
