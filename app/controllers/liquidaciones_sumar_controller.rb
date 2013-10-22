# -*- encoding : utf-8 -*-
class LiquidacionesSumarController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verificar_lectura

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
    @periodos_liquidacion = Periodo.all.collect {|p| [p.periodo, p.id, {:class => p.concepto_de_facturacion.id}]}

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
    else
      if @liquidacion_sumar.generar_cuasifacturas
        logger.warn "Tiempo para generar las cuasifacturas: #{Time.now - tiempo_proceso} segundos"
        redirect_to @liquidacion_sumar, :flash => { :tipo => :ok, :titulo => "Se generararon las cuasifacturas exitosamente" } 
      else
        redirect_to @liquidacion_sumar, :flash => { :tipo => :error, :titulo => "Hubieron problemas al realizar la generacion. Contacte con el departamento de sistemas." } 
      end 
    end
    
  end

  private

  def verificar_lectura
    if cannot? :read, LiquidacionSumar
      redirect_to( root_url, :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página", :mensaje => "Se informará al administrador del sistema sobre este incidente."})
    end
  end

  def crear_tabla_parametros(argLiquidacion)
    #obtengo el nomenclador mas cercano a la fecha
    n = Nomenclador.where("activo = true and fecha_de_inicio <= ?", argLiquidacion.periodo.fecha_cierre).order('fecha_de_inicio DESC').first
    #Obtengo la ultima formula creada
    f = Formula.where("activa = true and created_at <= ?", argLiquidacion.periodo.fecha_cierre).order('created_at DESC').first
    
    pl = ParametroLiquidacionSumar.new
    pl.formula = f

    return pl
  end

end
