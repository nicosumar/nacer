module NacerJob

  class GenericJob < Struct.new(:proceso_de_sistema_id)
   
    def enqueue(job)
      job.proceso_de_sistema_id = proceso_de_sistema_id
      @proceso_de_sistema = ProcesoDeSistema.find(job.proceso_de_sistema_id)
      tareasDeEncolado
      @proceso_de_sistema.estado_proceso_de_sistema_id = EstadosProcesoDeSistema::EN_COLA_PARA_PROCESAR
      @proceso_de_sistema.save
      job.save!
    end

    def success(job)
      @proceso_de_sistema = ProcesoDeSistema.find(job.proceso_de_sistema_id)
      @proceso_de_sistema.fecha_completado = Time.now
      @proceso_de_sistema.descripcion_ultimo_error = "Sin Errores";
      @proceso_de_sistema.estado_proceso_de_sistema_id = EstadosProcesoDeSistema::COMPLETADO
      @proceso_de_sistema.save
    end

    def error(job, exception)
      @proceso_de_sistema = ProcesoDeSistema.find(job.proceso_de_sistema_id)
      @proceso_de_sistema.descripcion_ultimo_error = exception.to_s
      @proceso_de_sistema.estado_proceso_de_sistema_id = EstadosProcesoDeSistema::ERROR_DURANTE_EL_PROCESAMIENTO
      @proceso_de_sistema.save
    end
   
    def before(job)
      @proceso_de_sistema = ProcesoDeSistema.find(job.proceso_de_sistema_id)
      @parametros = JSON.load(@proceso_de_sistema.parametros_dinamicos)
    end

    def perform
      @proceso_de_sistema.estado_proceso_de_sistema_id = EstadosProcesoDeSistema::PROCESANDO
      @proceso_de_sistema.save
      tareasDeProcesamiento
     
    end


   
    def tareasDeProcesamiento
      raise 'must implement method: tareasDeProcesamiento'
    end  

    def tareasDeEncolado
      raise 'must implement method: tareasDeEncolado'
    end


  end



  #Trabajo para procesar las liquidaciones
  class LiquidacionJob < GenericJob  
    def tareasDeEncolado
      @proceso_de_sistema.tipo_proceso_de_sistema_id = TiposProcesosDeSistemas::PROCESAR_LIQUIDACION_SUMAR
    end
    def tareasDeProcesamiento
      @ls = LiquidacionSumar.find(@proceso_de_sistema.entidad_relacionada_id)
      if @ls.prestaciones_liquidadas.count > 1
        raise "¡La liquidacion" + @ls.descripcion + "ya ha sido procesada! Vacie la liquidación si desea reprocesar."
        
      end
      
      @ls.generar_snapshoot_de_liquidacion
      @ls.notificar_resultado_liquidacion

    end  
  end 


  #Trabajo para generar las cuasifacturas de las liquidaciones
  class LiquidacionCuasiFacturaJob < GenericJob 
    def tareasDeEncolado
      @proceso_de_sistema.tipo_proceso_de_sistema_id = TiposProcesosDeSistemas::GENERAR_CUASIFACTURAS_LIQUIDACION_SUMAR
    end
    def tareasDeProcesamiento
      @liquidacion_sumar = LiquidacionSumar.find(@proceso_de_sistema.entidad_relacionada_id)
      if @liquidacion_sumar.prestaciones_liquidadas.count == 0
        raise  "¡La liquidacion " + @liquidacion_sumar.descripcion + "esta vacia. Procese  y verifique la liquidacion previamente."
      elsif @liquidacion_sumar.liquidaciones_sumar_cuasifacturas.count > 0
        raise  "¡Las cuasifacturas de la liquidación "+  @liquidacion_sumar.descripcion +  "ya han sido generadas."
      end
      
      @liquidacion_sumar.generar_documentos!
      @liquidacion_sumar.notificar_resultado_cuasifactura
      
    end  

    #Maxima cantidad de intentos sobrescrita
    def max_attempts
      5
    end
  end
  

  #Trabajo para el registro masivo de prestaciones
  class RegistroMasivoPrestacionesJob < GenericJob 
    def tareasDeEncolado
      @proceso_de_sistema.tipo_proceso_de_sistema_id = TiposProcesosDeSistemas::REGISTO_MASIVO_DE_PRESTACIONES
    end

    def tareasDeProcesamiento
      #load 'lib/tasks/registro_masivo_de_prestaciones_v2.rb'
      rmp2 = RegistroMasivoDePrestacionesV3.new
     
      if @parametros['archivo'] and @parametros['uad'] and @parametros['efe']
        rmp2.procesar( @parametros['archivo'] , UnidadDeAltaDeDatos.find( @parametros['uad'] ), Efector.find( @parametros['efe']) )
      else
        raise 'Parametros Faltantes o inconsistentes: '+ 'RegistroMasivoDePrestacionesV2.procesar(archivo, uad, efe)'
      end
    end 
      
    def max_attempts
      1
    end
       
    def max_run_time
      20000.minutes
    end
  end



  #Masivo de Beneficiarios
  class RegistroMasivoBeneficiariosJob < GenericJob 
    def tareasDeEncolado
      @proceso_de_sistema.tipo_proceso_de_sistema_id = TiposProcesosDeSistemas::REGISTO_MASIVO_DE_BENEFICIARIOS
    end

    def tareasDeProcesamiento 
      load 'lib/tasks/inscripciones_masivas.rb'
      ins = InscripcionMasiva.new
      #ins.procesar(archivo, part, uad, ci, efe)
      if @parametros['archivo'] and @parametros['part'] and @parametros['uad'] and @parametros['ci'] and @parametros['efe']
        ins.procesar( @parametros['archivo'] ,@parametros['part'] , UnidadDeAltaDeDatos.find( @parametros['uad'] ),  CentroDeInscripcion.find(@parametros['ci']), Efector.find( @parametros['efe']) )
      else
        raise 'Parametros Faltantes o inconsistentes: '+ 'InscripcionMasiva.procesar(archivo, part, uad, ci, efe)'
      end
    end 

    def max_attempts
      1
    end
    
 
  end


  #Cierre de padron
  class CierreDePadronJob < GenericJob

    def tareasDeEncolado
      @proceso_de_sistema.tipo_proceso_de_sistema_id = TiposProcesosDeSistemas::CIERRE_DE_PADRON
    end

    def tareasDeProcesamiento 
      if @parametros['anio'] and @parametros['mes'] and @parametros['dia'] and @parametros['uads_a_procesar_keys'] and @parametros['directorio']
          directorio = @parametros['directorio']
          anio  = @parametros['anio']   
          mes =   @parametros['mes']   
          dia =  @parametros['dia']    
          primero_del_mes_siguiente = Date.new(anio.to_i, mes.to_i, dia.to_i)
          uads_a_procesar_keys = @parametros['uads_a_procesar_keys'] 
          uads_a_procesar = UnidadDeAltaDeDatos.where(:codigo => uads_a_procesar_keys)
          archivo_generado = NovedadDelAfiliado.generar_archivo_a_unico(uads_a_procesar, primero_del_mes_siguiente, directorio);
      else
        raise 'Parametros Faltantes o inconsistentes: '+ 'PadronesController.cierre - (dia,mes,anio,uads_a_procesar_keys,directorio)'
      end
    end 

  end
  
  
  #Actualizacion de las novedades
  class ActualizacionDeNovedadesJob < GenericJob

    def tareasDeEncolado
      @proceso_de_sistema.tipo_proceso_de_sistema_id = TiposProcesosDeSistemas::ACTUALIZACION_DE_LAS_NOVEDADES
    end

    def tareasDeProcesamiento 
      if @parametros['anio_y_mes']
         p = PadronesController.new
         p.actualizacion_de_novedades_X(@parametros['anio_y_mes']);
      else
        raise 'Parametros Faltantes o inconsistentes: '+ 'PadronesController.actualizacion_de_novedades - (anio_y_mes)'
      end
    end 

  end


    #Actualizacion de las novedades
  class ActualizacionDelPadronJob < GenericJob

    def tareasDeEncolado
      @proceso_de_sistema.tipo_proceso_de_sistema_id = TiposProcesosDeSistemas::ACTUALIZACION_DEL_PADRON
    end

    def tareasDeProcesamiento 
      if @parametros['anio_y_mes']
         p = PadronesController.new
         p.actualizacion_del_padron_X(@parametros['anio_y_mes']);
      else
        raise 'Parametros Faltantes o inconsistentes: '+ 'PadronesController.actualizacion_del_padron - (anio_y_mes)'
      end
    end 

  end
end