class DocumentosElectronicosController < ApplicationController

	before_filter :authenticate_user!
  
  def index
  	
    # Valores para los dropdown
    @efectores = Efector.order("nombre desc").collect {|c| [c.nombre, c.id]}
    
    # Verifico si ya hizo el filtro o no
    if params[:efector_id].blank?
      @efector_id = -1
      @efector = ""
    else
      @efector_id = params[:efector_id]
      @efector = Efector.find(@efector_id)
    end

    condiciones = {}
    #condiciones.merge!({:e => {id: @efector_id}}) 
    condiciones.merge!({:e => {id: @efector_id}}) 

    # Crea la instancia del grid (o lleva los resultados del model al grid)
    @efector_documentos = initialize_grid(
      LiquidacionSumar,
      include: [:periodo, :concepto_de_facturacion],
      joins:  "join efectores e on e.grupo_de_efectores_id = liquidaciones_sumar.grupo_de_efectores_liquidacion_id\n"+
              "join grupos_de_efectores_liquidaciones gel on gel.id = e.grupo_de_efectores_id and liquidaciones_sumar.grupo_de_efectores_liquidacion_id = gel.id \n",
      #        " join conceptos_de_facturacion cf on cf.id = liquidaciones_sumar.concepto_de_facturacion_id\n"+
      #        " join periodos p on p.id = liquidaciones_sumar.periodo_id",
      conditions: condiciones
      )
    
    
  end
end
