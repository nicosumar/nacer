class BusquedaController < ApplicationController
  before_filter :authenticate_user!

  def index
    # Verificar que se pasaron los términos requeridos para la búsqueda
    if !params[:terminos] || params[:terminos].empty?
      redirect_to(root_url,
        :notice => "Debe ingresar algún término de búsqueda.")
    end

    # Preparar los resultados de la búsqueda en la vista temporal (no buscar afiliados)
    inicio = Time.now()
    Busqueda.busqueda_fts(params[:terminos], :excepto => :afiliados)

    # Eliminar los resultados a cuyos modelos el usuario no tiene acceso
    indices = []
    ObjetoEncontrado.find(:all).each do |o|
      if can? :read, eval(o.modelo_type)
        indices << o.id
      end
    end

    @registros_coincidentes = indices.size

    if @registros_coincidentes > 0
      @resultados_de_busqueda = ResultadoDeLaBusqueda.where('id IN (?)', indices).order('orden ASC').paginate(:page => params[:page], :per_page => 20)
    end
    fin = Time.now()
    @tiempo_de_busqueda = fin - inicio
  end

end
