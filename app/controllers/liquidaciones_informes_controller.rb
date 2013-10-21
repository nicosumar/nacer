# -*- encoding : utf-8 -*-
class LiquidacionesInformesController < ApplicationController

  # GET /liquidaciones_informes
  def index
    if params[:concepto_de_facturacion_id].blank?
      @concepto_de_facturacion_id = @efector_id = @liquidacion_sumar_cuasifactura_id = @estado_del_informe_id = -1
    else
      @concepto_de_facturacion_id = params[:concepto_de_facturacion_id]
      @efector_id = params[:efector_id]
      @liquidacion_sumar_cuasifactura_id = params[:liquidacion_sumar_cuasifactura_id]
      @estado_del_informe_id = params[:estado_del_informe_id]
    end

    condiciones = {}
    condiciones.merge!({:liquidaciones_sumar => {concepto_de_facturacion_id: @concepto_de_facturacion_id}}) if @concepto_de_facturacion_id.to_i > 0
    condiciones.merge!({:efectores => {id: @efector_id}}) if @efector_id.to_i > 0
    condiciones.merge!({:liquidaciones_sumar_cuasifacturas => {id: @liquidacion_sumar_cuasifactura_id}}) if @liquidacion_sumar_cuasifactura_id.to_i > 0
    condiciones.merge!({estado_del_proceso_id: @estado_del_informe_id}) if @estado_del_informe_id.to_i > 0
    

    # Crea la instancia del grid (o lleva los resultados del model al grid)
    @liquidaciones_informes = initialize_grid(
      LiquidacionInforme,
      include: [:estado_del_proceso, :liquidacion_sumar_cuasifactura, :liquidacion_sumar, :efector],
      joins:  "join liquidaciones_sumar on liquidaciones_sumar.id = liquidaciones_informes.liquidacion_Sumar_id\n"+
              "join liquidaciones_sumar_cuasifacturas on liquidaciones_sumar_cuasifacturas.liquidacion_sumar_id = liquidaciones_sumar.\"id\" and liquidaciones_informes.liquidacion_sumar_cuasifactura_id = liquidaciones_sumar_cuasifacturas.id\n"+
              "join efectores  on efectores.id = liquidaciones_sumar_cuasifacturas.efector_id ",
      conditions: condiciones
      )
    
    # Llena los selects
    @conceptos_de_facturacion = ConceptoDeFacturacion.order("id asc").collect {|c| [c.concepto, c.id]}
    @conceptos_de_facturacion << ['Todos', -1]
    @efectores = Efector.order("nombre desc").collect {|c| [c.nombre, c.id]}
    @efectores << ['Todos', -1]
    @numeros_de_cuasifactura = LiquidacionSumarCuasifactura.order("numero_cuasifactura desc").collect {|c| [c.numero_cuasifactura, c.id]}
    @numeros_de_cuasifactura << ["Todas", -1]
    @estados_de_los_informes = EstadoDelProceso.order("id desc").collect {|c| [c.nombre, c.id]}
    @estados_de_los_informes << ["Todos", -1]


  end

  # GET /liquidaciones_informes/1
  # GET /liquidaciones_informes/1.json
  def show
    @liquidacion_informe = LiquidacionInforme.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @liquidacion_informe }
    end
  end

  # GET /liquidaciones_informes/new
  # GET /liquidaciones_informes/new.json
  def new
    @liquidacion_informe = LiquidacionInforme.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @liquidacion_informe }
    end
  end

  # GET /liquidaciones_informes/1/edit
  def edit
    @liquidacion_informe = LiquidacionInforme.find(params[:id])
  end

  # POST /liquidaciones_informes
  # POST /liquidaciones_informes.json
  def create
    @liquidacion_informe = LiquidacionInforme.new(params[:liquidacion_informe])

    respond_to do |format|
      if @liquidacion_informe.save
        format.html { redirect_to @liquidacion_informe, notice: 'Liquidacion informe was successfully created.' }
        format.json { render json: @liquidacion_informe, status: :created, location: @liquidacion_informe }
      else
        format.html { render action: "new" }
        format.json { render json: @liquidacion_informe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /liquidaciones_informes/1
  def update
    @liquidacion_informe = LiquidacionInforme.find(params[:id])

    # Si se aprueba la cuasifactura, los anexos administrativos pasan a estado "En Curso"
    # de otra manera, ambos se cierran y las prestaciones se devuelven para refacturar
    
    if @liquidacion_informe.update_attributes(params[:liquidacion_informe])

      if params[:aprobar] == 'true'
        @liquidacion_informe.estado_del_proceso = EstadoDelProceso.where(codigo: "C").first
        @liquidacion_informe.save
        LiquidacionSumarAnexoAdministrativo.generar_anexo_administrativo(@liquidacion_informe.id)
        LiquidacionSumarAnexoMedico.generar_anexo_medico(@liquidacion_informe)
      else
        @liquidacion_informe.estado_del_proceso = EstadoDelProceso.where(codigo: "B").first
        @liquidacion_informe.save
        LiquidacionSumarAnexoAdministrativo.generar_anexo_para_devolucion(@liquidacion_informe.id)
        LiquidacionSumarAnexoMedico.generar_anexo_para_devolucion(@liquidacion_informe.id)
      end
      redirect_to @liquidacion_informe, :flash => { :tipo => :ok, :titulo => "El informe fue generado correctamente" } 
    else
      render action: "edit" 
    end
    
  end

  # DELETE /liquidaciones_informes/1
  # DELETE /liquidaciones_informes/1.json
  def destroy
    @liquidacion_informe = LiquidacionInforme.find(params[:id])
    @liquidacion_informe.destroy

    respond_to do |format|
      format.html { redirect_to liquidaciones_informes_url }
      format.json { head :no_content }
    end
  end
end
