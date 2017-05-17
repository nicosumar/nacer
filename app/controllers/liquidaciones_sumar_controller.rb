# -*- encoding : utf-8 -*-
class LiquidacionesSumarController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura
  before_filter :verificar_creacion, only: [:create, :new]

  # GET /liquidaciones_sumar
  def index
    @liquidaciones_sumar = LiquidacionSumar.all
  end

  # GET /liquidaciones_sumar/1
  def show
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])
  
    @procesos_relacionado_cerrarl =ProcesoDeSistema.where('entidad_relacionada_id = ? and tipo_proceso_de_sistema_id = ?', @liquidacion_sumar.id,TiposProcesosDeSistemas::PROCESAR_LIQUIDACION_SUMAR).includes(:estado_proceso_de_sistema).last

    @procesos_relacionado_cuasif =ProcesoDeSistema.where('entidad_relacionada_id = ? and tipo_proceso_de_sistema_id = ?', @liquidacion_sumar.id,TiposProcesosDeSistemas::GENERAR_CUASIFACTURAS_LIQUIDACION_SUMAR).includes(:estado_proceso_de_sistema).last

  end

  # GET /liquidaciones_sumar/new
  def new
    @liquidacion_sumar = LiquidacionSumar.new
    @grupo_de_efectores_liquidacion = GrupoDeEfectoresLiquidacion.all.collect {|g| [g.grupo, g.id]}

    # Traigo los conceptos de facturacion y los periodos. Agrego la vinculacion entre
    # el concepto y el periodo
    @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|cf| [cf.concepto, cf.id]}
    @periodos_liquidacion = Periodo.all.collect {|p| ["#{p.periodo} - #{p.tipo_periodo.descripcion}", p.id, {:class => p.concepto_de_facturacion.id}]}

    @plantillas_de_reglas = PlantillaDeReglas.all.collect { |p| [p.nombre, p.id] }

  end

  # GET /liquidaciones_sumar/1/edit
  def edit
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])
    @grupo_de_efectores_liquidacion = GrupoDeEfectoresLiquidacion.all.collect {|g| [g.grupo, g.id]}

    @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|cf| [cf.concepto, cf.id]}
    @periodos_liquidacion = Periodo.all.collect {|p| [p.periodo, p.id, {:class => p.concepto_de_facturacion.id}]}

    @plantillas_de_reglas = PlantillaDeReglas.all.collect { |p| [p.nombre, p.id] }
  end

  # POST /liquidaciones_sumar
  def create
    @liquidacion_sumar = LiquidacionSumar.new(params[:liquidacion_sumar])

    pl = crear_tabla_parametros(@liquidacion_sumar)

    if pl.save
      @liquidacion_sumar.parametro_liquidacion_sumar_id = pl.id

      if @liquidacion_sumar.save
        redirect_to @liquidacion_sumar, :flash => { :tipo => :ok, :titulo => "Se creó la liquidacion '#{@liquidacion_sumar.descripcion}' correctamente" }
      else
        @grupo_de_efectores_liquidacion = GrupoDeEfectoresLiquidacion.all.collect {|g| [g.grupo, g.id]}

        @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|cf| [cf.concepto, cf.id]}
        @periodos_liquidacion = Periodo.all.collect {|p| [p.periodo, p.id, {:class => p.concepto_de_facturacion.id}]}

        @plantillas_de_reglas = PlantillaDeReglas.all.collect { |p| [p.nombre, p.id] }
        render action: "new"
      end
    else
      if @liquidacion_sumar.save
        redirect_to @liquidacion_sumar, :flash => { :tipo => :ok, :titulo => "Se creó la liquidacion '#{@liquidacion_sumar.descripcion}' pero no se creo la tabla de parametros" }
      else
        @grupo_de_efectores_liquidacion = GrupoDeEfectoresLiquidacion.all.collect {|g| [g.grupo, g.id]}

        @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|cf| [cf.concepto, cf.id]}
        @periodos_liquidacion = Periodo.all.collect {|p| [p.periodo, p.id, {:class => p.concepto_de_facturacion.id}]}

        @plantillas_de_reglas = PlantillaDeReglas.all.collect { |p| [p.nombre, p.id] }
        render action: "new"
      end
    end
  end

  # PUT /liquidaciones_sumar/1
  def update
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])

    if @liquidacion_sumar.update_attributes(params[:liquidacion_sumar])
      redirect_to @liquidacion_sumar, :flash => { :tipo => :ok, :titulo => "Se actualizo la liquidacion '#{@liquidacion_sumar.descripcion}' correctamente" }
    else
      @grupo_de_efectores_liquidacion = GrupoDeEfectoresLiquidacion.all.collect {|g| [g.grupo, g.id]}

      @conceptos_de_facturacion = ConceptoDeFacturacion.all.collect {|cf| [cf.concepto, cf.id]}
      @periodos_liquidacion = Periodo.all.collect {|p| [p.periodo, p.id, {:class => p.concepto_de_facturacion.id}]}

      @plantillas_de_reglas = PlantillaDeReglas.all.collect { |p| [p.nombre, p.id] }

      render action: "edit"
    end
  end

  # DELETE /liquidaciones_sumar/1
  def destroy
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])
    @liquidacion_sumar.destroy

    redirect_to liquidaciones_sumar_url
  end

  def vaciar_liquidacion
    tiempo_proceso = Time.now

    @liquidacion_sumar = LiquidacionSumar.find(params[:id])
    respuesta = {}
    status = :ok

    begin
      @liquidacion_sumar.vaciar_liquidacion
      respuesta = { :tipo => :ok, :titulo => "La liquidacion se elimino correctamente - Tiempo para vaciar la liquidacion: #{Time.now - tiempo_proceso} segundos" }
    rescue Exception => e
      respuesta = { :tipo => :error, :titulo => "No fue posible vaciar la liquidacion", mensaje: "Si las cuasifacturas ya han sido generadas, la liquidación no se puede vaciar. Detalles: #{e.message}" }
      status =  :method_not_allowed
    end
    logger.warn "Tiempo para vaciar la liquidacion: #{Time.now - tiempo_proceso} segundos"
    
    respond_to do |format|
      format.html { redirect_to @liquidacion_sumar, flash: respuesta }
      format.json { render json: respuesta.to_json, status: status }
    end

  end

  def procesar_liquidacion
    tiempo_proceso = Time.now

    respuesta = {}
    status = :ok

    @liquidacion_sumar = LiquidacionSumar.find(params[:id])

    if @liquidacion_sumar.prestaciones_liquidadas.count > 1
      respuesta = { :tipo => :error, :titulo => "¡La liquidacion ya ha sido procesada! Vacie la liquidación si desea reprocesar." }
      status = :method_not_allowed
    else
      
      # if @liquidacion_sumar.generar_snapshoot_de_liquidacion
      #   logger.warn "Tiempo para procesar: #{Time.now - tiempo_proceso} segundos"
      #   respuesta = { :tipo => :ok, :titulo => "La liquidacion se realizo correctamente" }
      # else
      #   respuesta = { :tipo => :error, :titulo => "Hubieron problemas al realizar la liquidacion. Contacte con el departamento de sistemas." }
      #   status = :internal_server_error
      # end

      begin
      proceso_de_sistema = ProcesoDeSistema.new 
      proceso_de_sistema.entidad_relacionada_id = @liquidacion_sumar.id
      if proceso_de_sistema.save 
         Delayed::Job.enqueue NacerJob::LiquidacionJob.new(proceso_de_sistema.id)    
         respuesta = { :tipo => :ok, :titulo => "El procesamiento de la liquidación se encoló correctamente" }
      end
      rescue
        respuesta = { :tipo => :error, :titulo => "Hubieron problemas al realizar la liquidacion. Contacte con el departamento de sistemas." }
        status = :internal_server_error
      end

    end

    respond_to do |format|
      format.html { redirect_to @liquidacion_sumar, flash: respuesta }
      format.json { render json: respuesta.to_json, status: status }
    end
  end


  def generar_cuasifacturas
    tiempo_proceso = Time.now
    @liquidacion_sumar = LiquidacionSumar.find(params[:id])
    respuesta = {}
    status = :ok

     if @liquidacion_sumar.prestaciones_liquidadas.count == 0
       respuesta = { tipo: :error, titulo: "¡La liquidacion esta vacia. Procese  y verifique la liquidacion previamente." }
       status =  :method_not_allowed
     elsif @liquidacion_sumar.liquidaciones_sumar_cuasifacturas.count > 0
       respuesta = { :tipo => :error, :titulo => "¡Las cuasifacturas ya han sido generadas." }
       status =  :method_not_allowed
     end
      
    begin
      unless respuesta.present?

        proceso_de_sistema = ProcesoDeSistema.new 
        if proceso_de_sistema.save 
        Delayed::Job.enqueue NacerJob::LiquidacionCuasiFacturaJob.new(proceso_de_sistema.id)    
        end

        #@liquidacion_sumar.generar_documentos!
        #logger.warn "Tiempo para generar las cuasifacturas: #{Time.now - tiempo_proceso} segundos"
        respuesta = { :tipo => :ok, :titulo => "El procesamiento de la generación de las cuasifacturas se encoló correctamente" }
      end
    rescue Exception => e
      logger.warn e.inspect
      respuesta = { :tipo => :error, :titulo => "Hubieron problemas al realizar la generacion. Contacte con el departamento de sistemas.",
                     mensaje: e.message }
      status = :internal_server_error
    end
      
    respond_to do |format|
      format.json { render json: respuesta.to_json, status: status }
    end
  end

  def procesar_liquidaciones
    
    tiempo_proceso = Time.now
    respuesta = {}
    status = :ok

    
    @liquidaciones_sumar = LiquidacionSumar.all
    
   
    begin  
    liquidaciones_encoladas = ""  
    @liquidaciones_sumar.each  do |p|

         @liquidaciones_sumar = LiquidacionSumar.find(p.id)

         if not @liquidaciones_sumar.prestaciones_liquidadas.count > 1

              #Encolo la tarea de procesado.
              proceso_de_sistema = ProcesoDeSistema.new 
              proceso_de_sistema.entidad_relacionada_id = @liquidaciones_sumar.id

              proceso_de_sistema_gc = ProcesoDeSistema.new   
              proceso_de_sistema_gc.entidad_relacionada_id = @liquidaciones_sumar.id

            
            
                if proceso_de_sistema.save! and proceso_de_sistema_gc.save! 
                  liquidaciones_encoladas  << @liquidaciones_sumar.descripcion + "\n"
                  #Encolo la tarea de procesado.
                  Delayed::Job.enqueue NacerJob::LiquidacionJob.new(proceso_de_sistema.id)
                  #Encolo la tarea de generado de cuasifactura.
                  Delayed::Job.enqueue NacerJob::LiquidacionCuasiFacturaJob.new(proceso_de_sistema_gc.id)  

                end
            
         end
    end
    if liquidaciones_encoladas != ""
          redirect_to( liquidaciones_sumar_path, :flash => { :tipo => :ok, :titulo => "Se encolaron correctamentelas las liquidaciones.", :mensaje => liquidaciones_encoladas })
    else
          redirect_to( liquidaciones_sumar_path, :flash => { :tipo => :advertencia, :titulo => "Se encolaron correctamentelas las liquidaciones.", :mensaje => liquidaciones_encoladas })
    end

  #respuesta = { :tipo => :ok, :titulo => "Se encolaron correctamentelas las liquidaciones" }
    rescue

   # respuesta = { :tipo => :error, :titulo => "Ocurrio un error al encolar las liquidaciones."}
    redirect_to( liquidaciones_sumar_path, :flash => { :tipo => :error, :titulo => "Ocurrio un error al encolar las liquidaciones."})

    end
    
  end






  # GET /liquidaciones_sumar/1/efector/1.pdf
  def detalle_de_prestaciones_liquidadas_por_efector
        
    if params[:liquidacion_sumar_id].blank? or params[:id].blank?
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
    
    @liquidacion_sumar = LiquidacionSumar.find(params[:liquidacion_sumar_id])
    @efector = Efector.find(params[:id])

    uad = UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual])
    efector_actual = uad.efector

    permitir_reporte = true

    if current_user.in_group? [:administradores, :facturacion, :auditoria_medica, :coordinacion, :planificacion, :auditoria_control, :capacitacion]
      permitir_reporte = true
    elsif current_user.in_group? [:liquidacion_adm]
      if efector_actual.es_administrador? 
       # si es administrador y quiere consultar sobre un efector que no es o bien el mismo o alguno de los administrados, lo redirijo
        permitir_reporte = false unless efector_actual == @efector or efector_actual.efectores_administrados.include? @efector 
      elsif efector_actual.es_autoadministrado?
        permitir_reporte = false unless efector_actual == @efector 
      elsif efector_actual.es_administrado?
        # si es administrado y quiere consultar sobre un efector que no es o bien su administrador o alguno de sus administrados, lo redirijo
        permitir_reporte = false unless efector_actual.administrador_sumar.efectores_administrados.include? @efector or efector_actual.administrador_sumar == @efector
      end
    elsif current_user.in_group? [:facturacion_uad] 
      if efector_actual.es_administrador? 
        permitir_reporte = false unless efector_actual == @efector or efector_actual.efectores_administrados.include? @efector 
      elsif efector_actual.es_autoadministrado?
        permitir_reporte = false unless efector_actual == @efector 
      elsif efector_actual.es_administrado? 
        permitir_reporte = false unless Efector.where("unidad_de_alta_de_datos_id = '?' OR id = '?'", uad.id, efector_actual.id).include? @efector 
      end
    end

    unless permitir_reporte 
      redirect_to( root_url, 
          :flash => { :tipo => :error, 
                      :titulo => "No está autorizado para acceder a esta página", 
                      :mensaje => "Se informará al administrador del sistema sobre este incidente."
                    })
      return
    end

    respond_to do |format|
      format.pdf { send_data render_to_string, filename: "detalle_de_prestaciones_#{@periodo.periodo}_#{@efector.nombre}.pdf", 
      type: 'application/pdf', disposition: 'attachment'}

      format.xlsx {
        render xlsx: 'detalle_de_prestaciones_liquidadas_por_efector',
        filename:  "detalle_de_prestaciones_#{@liquidacion_sumar.periodo.periodo}_#{@liquidacion_sumar.concepto_de_facturacion.codigo}.xlsx"
      }
      
    end
  end

  private

  def verificar_lectura
    if cannot? :read, LiquidacionSumar
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

  def verificar_creacion
    if cannot? :create, LiquidacionSumar
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

  def crear_tabla_parametros(argLiquidacion)

    pl = ParametroLiquidacionSumar.new
   
    return pl
  end

end
