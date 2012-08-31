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

end
