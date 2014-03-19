class DocumentosElectronicosController < ApplicationController

	before_filter :authenticate_user!
  
  def index

    # Valores para los dropdown
    if current_user.in_group? [:administradores, :facturacion, :auditoria_medica, :coordinacion, :planificacion, :auditoria_control, :capacitacion],  
      @efectores = Efector.order("nombre desc").collect {|c| [c.nombre, c.id]}
    elsif current_user.in_group? [:facturacion_uad] 
      uad = UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual])
      if uad.efector.present? 
        if uad.efector.es_administrador?
          @efectores = [[uad.efector.nombre, uad.efector.id]]
          @efectores += uad.efector.efectores_administrados.order("nombre desc").collect {|c| [c.nombre, c.id]}
        else
          @efectores = Efector.where("unidad_de_alta_de_datos_id = '?' OR id = '?'", uad.id, uad.efector.id).order("nombre desc").collect {|c| [c.nombre, c.id]}
        end
      else
        @efectores = Efector.where("unidad_de_alta_de_datos_id = '?' ", uad.id).order("nombre desc").collect {|c| [c.nombre, c.id]}
      end
    end
    
    # Verifico si ya hizo el filtro o no
    if params[:efector_id].blank? 
      @efector_id = -1
      @efector = ""
    else
      @efector_id = params[:efector_id]
      # Verifico que el id del efector este entre los permitidos por su grupo (o sea, no cambio el ID de efector en la URL)

      # Si el id de efector NO esta entre los elegidos para su grupo
      unless @efectores.flatten.include? @efector_id.to_i
        @efector_id = -1
        @efector = ""
      else
        @efector = Efector.find(@efector_id)
      end
    end

    condiciones = {}
    condiciones.merge!({:e => {id: @efector_id}}) 

    
    # Crea la instancia del grid (o lleva los resultados del model al grid)
    @efector_documentos = initialize_grid(
      Periodo,
      joins:  "left join consolidados_sumar cs on (cs.periodo_id = periodos.id and cs.efector_id = #{@efector_id})\n"+
              " left join ( liquidaciones_sumar ls \n"+
              "             join liquidaciones_sumar_cuasifacturas lsc on (lsc.liquidacion_sumar_id = ls.id and  lsc.efector_id = #{@efector_id})) sub on periodos.id = sub.periodo_id",
      conditions: " sub.liquidacion_sumar_id is not null\n"+
                  " or cs.id is not null ",
      :order => 'periodos.periodo'
      )
    
    
  end
end
