module NacerJob

  class GenericJob < Struct.new(:proceso_de_sistema_id)
   
    def enqueue(job)
      job.proceso_de_sistema_id = proceso_de_sistema_id
      @proceso_de_sistema = ProcesoDeSistema.find(job.proceso_de_sistema_id)
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
    end

    def perform
     
     
      tareasDeProcesamiento
      @proceso_de_sistema.estado_proceso_de_sistema_id = EstadosProcesoDeSistema::PROCESANDO
      @proceso_de_sistema.save
    
  
    end


   
    def tareasDeProcesamiento
      raise 'must implement method: tareasDeProcesamiento'
    end  


  end




  class LiquidacionJob < GenericJob  
    
    def tareasDeProcesamiento
    #   logger.warn "Iniciando Liquidacion SUmar En Segundo Plano"
       sleep 3.minutes
      # logger.warn "Terminando Procesamiento"
       #@ls = LiquidacionSumar.find(@proceso_de_sistema.entidad_relacionada_id)
       #@ls.generar_snapshoot_de_liquidacion
    end  

  end 




end