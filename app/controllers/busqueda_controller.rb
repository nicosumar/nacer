class BusquedaController < ApplicationController
  before_filter :user_required

  def index
    # Verificar que se pasaron los términos requeridos para la búsqueda
    if !params[:terminos] || params[:terminos].empty?
      redirect_to(root_url,
        :notice => "Debe ingresar algún término de búsqueda."
    end

    indices = []
    Busqueda.busqueda_fts(params[:terminos]).each do |b|
      if can? :read, eval(b.modelo_type)
        indices << b.id
      end
    end
    @registros_coincidentes = indices.size
    if @registros_coincidentes > 0
      @resultados_de_busqueda = Busqueda.where('id IN (?)', indices).paginate(:page => params[:page], :per_page => 10)
    end
  end

end
