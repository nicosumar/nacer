class DocumentosElectronicosController < ApplicationController

	before_filter :authenticate_user!
  
  def index

    if current_user.in_group? [:administradores, :facturacion] 
      # Valores para los dropdown
      @efectores = Efector.order("nombre desc").collect {|c| [c.nombre, c.id]}
    elsif current_user.in_group? [:facturacion_uad] and UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual]).facturacion 
      uad = UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual])
      @efectores = Efector.where(unidad_de_alta_de_datos_id: uad.id).order("nombre desc").collect {|c| [c.nombre, c.id]}
    end
    
    
    # Verifico si ya hizo el filtro o no
    if params[:efector_id].blank?
      @efector_id = -1
      @efector = ""
    else
      @efector_id = params[:efector_id]
      @efector = Efector.find(@efector_id)
    end

    condiciones = {}
    condiciones.merge!({:e => {id: @efector_id}}) 

    # Crea la instancia del grid (o lleva los resultados del model al grid)
    @efector_documentos = initialize_grid(
      LiquidacionSumar,
      include: [:periodo, :concepto_de_facturacion],
      joins:  "join efectores e on e.grupo_de_efectores_liquidacion_id = liquidaciones_sumar.grupo_de_efectores_liquidacion_id\n"+
              "join grupos_de_efectores_liquidaciones gel on gel.id = e.grupo_de_efectores_liquidacion_id and liquidaciones_sumar.grupo_de_efectores_liquidacion_id = gel.id \n",
      conditions: condiciones
      )
    
    
  end
end
