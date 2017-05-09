module NacerJobs

  class GenericJob < Struct.new(:proceso_de_sistema_id)
   
    def enqueue(job)
      @procesos_de_sistema = ProcesoDeSistema.find(job.procesos_de_sistema_id)
      @proceso_de_sistema.estado_proceso_sistema_id = EstadosProcesoDeSistema::EN_COLA_PARA_PROCESAR
      @procesos_de_sistema.save
      job.proceso_de_sistema_id = proceso_de_sistema_id
      job.save!
    end

    def success(job)
      @procesos_de_sistema = ProcesoDeSistema.find(job.procesos_de_sistema_id)
      @proceso_de_sistema.fecha_completado = Time.now
      @proceso_de_sistema.estado_proceso_sistema_id = EstadosProcesoDeSistema::COMPLETADO
      @procesos_de_sistema.save
    end

    def error(job, exception)
      @procesos_de_sistema = ProcesoDeSistema.find(job.procesos_de_sistema_id)
      @proceso_de_sistema.descripcion_ultimo_error = exception.to_s
      @proceso_de_sistema.estado_proceso_sistema_id = EstadosProcesoDeSistema::ERROR_DURANTE_EL_PROCESAMIENTO
      @procesos_de_sistema.save
    end
   
    def perform
      #video = VideoSteamer::Video.find video_id
      #raise StandardError.new("Failed to process video with id: #{video.id}") unless video.process?
      @procesos_de_sistema = ProcesoDeSistema.find(job.procesos_de_sistema_id)
      begin
      tareasDeProcesamiento
      @proceso_de_sistema.estado_proceso_sistema_id = EstadosProcesoDeSistema::PROCESANDO
      @procesos_de_sistema.save
      rescue
        raise StandardError.new("Fallo al procesar el JOB") 
      end
  
    end


   
    def tareasDeProcesamiento
      raise 'must implement method: tareasDeProcesamiento'
    end  


  end




  class LiquidacionJob < NacerJob  
    
    def tareasDeProcesamiento
       logger.warn "Iniciando Liquidacion SUmar En Segundo Plano"
       Sleep 3.minutes
       logger.warn "Terminando Procesamiento"
       #@ls = LiquidacionSumar.find(@procesos_de_sistema.entidad_relacionada_id)
       #@ls.generar_snapshoot_de_liquidacion
    end  

  end 




end