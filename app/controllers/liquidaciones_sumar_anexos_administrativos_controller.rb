class LiquidacionesSumarAnexosAdministrativosController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :verificar_lectura

  # GET /liquidaciones_sumar_anexos_administrativos/1
  def show
    @liquidacion_sumar_anexo_administrativo = LiquidacionSumarAnexoAdministrativo.find(params[:id])

    condiciones = {}
    #condiciones.merge!({:liquidaciones_sumar => {concepto_de_facturacion_id: @concepto_de_facturacion_id}}) if @concepto_de_facturacion_id.to_i > 0
    #condiciones.merge!({:efectores => {id: @efector_id}}) if @efector_id.to_i > 0
    #condiciones.merge!({:liquidaciones_sumar_cuasifacturas => {id: @liquidacion_sumar_cuasifactura_id}}) if @liquidacion_sumar_cuasifactura_id.to_i > 0
    condiciones.merge!({liquidacion_sumar_anexo_administrativo_id: @liquidacion_sumar_anexo_administrativo.id}) if @estado_del_informe_id.to_i > 0

    # Crea la instancia del grid (o lleva los resultados del model al grid)
    @detalle_anexo = initialize_grid(
      AnexoAdministrativoPrestacion,
      include: [:prestacion_liquidada, :estado_de_la_prestacion],
      joins:  "join prestaciones_liquidadas on prestaciones_liquidadas.id = anexos_administrativos_prestaciones.prestacion_liquidada_id\n"+
              "join prestaciones_incluidas on prestaciones_incluidas.id = prestaciones_liquidadas.prestacion_incluida_id\n"+
              "join estados_de_las_prestaciones on estados_de_las_prestaciones.id = anexos_administrativos_prestaciones.estado_de_la_prestacion_id",
      conditions: condiciones
      )

    @estados_de_las_prestaciones = EstadoDeLaPrestacion.where(id: [5,6,7]).collect {|c| [c.nombre, c.id]}
    @motivos_de_rechazo = MotivoDeRechazo.where(categoria: "Administrativa").collect {|c| [c.nombre, c.id]}
  end

  # Cambia el estado del anexo a finalizado. El anexo en estado de finalizado bloquea las modificaciones
  def finalizar_anexo
    
  end

  private 

  def verificar_lectura
    if cannot? :read, LiquidacionSumarAnexoAdministrativo
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end
end
