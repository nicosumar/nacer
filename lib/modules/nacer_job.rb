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

      tareasDeProcesamiento
      @proceso_de_sistema.estado_proceso_de_sistema_id = EstadosProcesoDeSistema::PROCESANDO
      @proceso_de_sistema.save
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
      sleep 2.minutes
      # @ls = LiquidacionSumar.find(@proceso_de_sistema.entidad_relacionada_id)
      # @ls.generar_snapshoot_de_liquidacion
    end  
  end 


  #Trabajo para generar las cuasifacturas de las liquidaciones
  class LiquidacionCuasiFacturaJob < GenericJob 
      def tareasDeEncolado
       @proceso_de_sistema.tipo_proceso_de_sistema_id = TiposProcesosDeSistemas::GENERAR_CUASIFACTURAS_LIQUIDACION_SUMAR
      end
      def tareasDeProcesamiento
      sleep 1.minutes
      raise "fuck error"
      # @ls = LiquidacionSumar.find(@proceso_de_sistema.entidad_relacionada_id)
      # @ls.@liquidacion_sumar.generar_documentos!
      end  

        #Maxima cantidad de intentos sobrescrita
        def max_attempts
         3
        end
  end
  

  #Trabajo para el registro masivo de prestaciones
  class RegistroMasivoPrestacionesJob < GenericJob 

    
      def tareasDeEncolado
       @proceso_de_sistema.tipo_proceso_de_sistema_id = TiposProcesosDeSistemas::REGISTO_MASIVO_DE_PRESTACIONES
      end

      def tareasDeProcesamiento
         rmp2 = RegistroMasivoDePrestaciones2.new
         if @parametros['archivo'] and @parametros['uad'] and @parametros['efe']
          rmp2.procesar(@parametros['archivo'],@parametros['uad'],@parametros['efe'])
         else
          raise 'Parametros Faltantes: '+ 'RegistroMasivoDePrestaciones2.procesar(archivo, uad, efe)'
         end
      end 
  end




end