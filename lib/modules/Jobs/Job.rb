module Job

  class ProcessVideoJob < Struct.new(:proceso_de_sistema_id, :user_id)
   
    def enqueue(job)
      job.proceso_de_sistema_id   = proceso_de_sistema_id
      job.user_id = user_id
      job.save!
    end

    def success(job)
      update_status('success')
      procesos_de_sistema = ProcesoDeSistema.find(job.procesos_de_sistema_id)
      proceso_de_sistema.fecha_completado = Time.now
      proceso_de_sistema.
    end

    def error(job, exception)
      update_status('temp_error')
      # Send email notification / alert / alarm
    end

    
    private

    def update_status(status)
      video = VideoStreamer::Video.find video_id
      video.status = status
      video.save!
    end



  end

end