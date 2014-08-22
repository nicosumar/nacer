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

    begin
      @liquidacion_sumar.vaciar_liquidacion
    rescue Exception => e
      redirect_to @liquidacion_sumar, :flash => { :tipo => :error, :titulo => "No fue posible vaciar la liquidacion. Si las cuasifacturas ya han sido generadas, la liquidación no se puede vaciar. Detalles: #{e.message}" }
      return
    end
    logger.warn "Tiempo para vaciar la liquidacion: #{Time.now - tiempo_proceso} segundos"
    redirect_to @liquidacion_sumar, :flash => { :tipo => :ok, :titulo => "La liquidacion se elimino correctamente" }


  end

  def procesar_liquidacion
    tiempo_proceso = Time.now

    @liquidacion_sumar = LiquidacionSumar.find(params[:id])

    if @liquidacion_sumar.prestaciones_liquidadas.count > 1
      redirect_to @liquidacion_sumar, :flash => { :tipo => :error, :titulo => "¡La liquidacion ya ha sido procesada! Vacie la liquidación si desea reprocesar." }
    else
      if @liquidacion_sumar.generar_snapshoot_de_liquidacion
        logger.warn "Tiempo para procesar: #{Time.now - tiempo_proceso} segundos"
        redirect_to @liquidacion_sumar, :flash => { :tipo => :ok, :titulo => "La liquidacion se realizo correctamente" }
      else
        redirect_to @liquidacion_sumar, :flash => { :tipo => :error, :titulo => "Hubieron problemas al realizar la liquidacion. Contacte con el departamento de sistemas." }
      end
    end
  end




  def generar_cuasifacturas
    tiempo_proceso = Time.now

     @liquidacion_sumar = LiquidacionSumar.find(params[:id])

    if @liquidacion_sumar.prestaciones_liquidadas.count == 0
      redirect_to @liquidacion_sumar, :flash => { :tipo => :error, :titulo => "¡La liquidacion esta vacia. Procese  y verifique la liquidacion previamente." }
    elsif @liquidacion_sumar.liquidaciones_sumar_cuasifacturas.count > 0
      redirect_to @liquidacion_sumar, :flash => { :tipo => :error, :titulo => "¡Las cuasifacturas ya han sido generadas." }
    end
      
=begin
      if @liquidacion_sumar.generar_cuasifacturas
        logger.warn "Tiempo para generar las cuasifacturas: #{Time.now - tiempo_proceso} segundos"
        redirect_to @liquidacion_sumar, :flash => { :tipo => :ok, :titulo => "Se generararon las cuasifacturas exitosamente" }
      else
        redirect_to @liquidacion_sumar, :flash => { :tipo => :error, :titulo => "Hubieron problemas al realizar la generacion. Contacte con el departamento de sistemas." }
      end
=end
    if @liquidacion_sumar.generar_documentos
      logger.warn "Tiempo para generar las cuasifacturas: #{Time.now - tiempo_proceso} segundos"
      redirect_to @liquidacion_sumar, :flash => { :tipo => :ok, :titulo => "Se generararon las cuasifacturas exitosamente" }
    else
      redirect_to @liquidacion_sumar, :flash => { :tipo => :error, :titulo => "Hubieron problemas al realizar la generacion. Contacte con el departamento de sistemas." }
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
        permitir_reporte = false if efector_actual != @efector or efector_actual.efectores_administrados.include? @efector 
      elsif efector_actual.es_autoadministrado?
        permitir_reporte = false if efector_actual != @efector 
      elsif efector_actual.es_administrado?
        # si es administrado y quiere consultar sobre un efector que no es o bien su administrador o alguno de sus administrados, lo redirijo
        permitir_reporte = false if efector_actual.administrador_sumar.efectores_administrados.include? @efector or efector_actual.administrador_sumar != @efector
      end
    elsif current_user.in_group? [:facturacion_uad] 
      if uad.efector.es_administrador? 
        permitir_reporte = false if efector_actual != @efector or efector_actual.efectores_administrados.include? @efector 
      elsif uad.efector.es_autoadministrado?
        permitir_reporte = false if efector_actual != @efector 
      elsif uad.efector.es_administrado? 
        permitir_reporte = false  if Efector.where("unidad_de_alta_de_datos_id = '?' OR id = '?'", uad.id, efector_actual.id).include? @efector or efector_actual.administrador_sumar != @efector
      end
    end

    unless permitir_reporte 
      redirect_to( root_url, 
          :flash => { :tipo => :error, 
                      :titulo => "No está autorizado para acceder a esta página", 
                      :mensaje => "Se informará al administrador del sistema sobre este incidente."
                    })
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

  def prueba_cont
    #raise 'llala'
    l = LiquidacionSumar.find(params[:id])
   
    res = {
      tipo: :ok,
      titulo: "Todo bien",
      mensaje: "Todo salio bien"
    }

    sleep 10

    respond_to do |format|
      format.json do
        render json: res.to_json
      end
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
