class SolicitudesAddendasController < ApplicationController
  def index
    # Verificar los permisos del usuario
    if cannot? :read, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el listado de addendas
    @solicitudes_addendas =
      SolicitudAddenda.paginate(:page => params[:page], :per_page => 20, :include =>[:estado_solicitud_addenda,{:convenio_de_gestion_sumar => :efector}],
      :order => "updated_at DESC"
    )
  end

  def new
    
    # Verificar los permisos del usuario
    if cannot? :create, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
    
    
    
    @convenio_de_gestion = ConvenioDeGestionSumar.find(13)
    
    
    # Obtener el convenio de gestión asociado (ahora lo hardcodeo)
    #    begin
    #      @convenio_de_gestion = ConvenioDeGestionSumar.find(params[:convenio_de_gestion_sumar_id])
    #    rescue ActiveRecord::RecordNotFound
    #      redirect_to(
    #        root_url,
    #        :flash => {:tipo => :error, :titulo => "La petición no es válida",
    #          :mensaje => "Se informará al administrador del sistema sobre el incidente."
    #        }
    #      )
    #      return
    #    end
    
    # Crear los objetos necesarios para la vista
    @solicitud_addenda = SolicitudAddenda.new   
    @solicitudes_prestaciones_principales = []
    @solicitudes_prestaciones_principales_aptecnica = []
    @prestaciones_principales_autorizadas = PrestacionPrincipalAutorizada.efector_y_fecha(30)


  end
  
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la adenda
    begin
      @solicitud_addenda = SolicitudAddenda.find( params[:id],
        
        :include => [
          {:solicitudes_addendas_prestaciones_principales => :prestacion_principal},
          :estado_solicitud_addenda,
          {:convenio_de_gestion_sumar => :efector}
        ]
      )
      
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @convenio_de_gestion = @solicitud_addenda.convenio_de_gestion_sumar
    @efector = @convenio_de_gestion.efector

#    #Determino a que estado puede cambiarse la addenda.
#    if @solicitud_addenda.new_record?
#      @estados_solicitudes_addendas = EstadoSolicitudAddenda.all.select {|esa| esa.id = EstadosSolicitudAddenda::GENERADA}
#    else 
# 
#      estados_ids = []
#      #En teoria no se deberian superponer los permisos
#      if current_user.in_group?:gestion_addendas_uad
#        estados_ids = [EstadosSolicitudAddenda::GENERADA,EstadosSolicitudAddenda::ANULACION_EFECTOR]
#      end
#      if current_user.in_group?:auditoria_medica  
#        estados_ids =estados_ids +  [EstadosSolicitudAddenda::EN_REVISION_TECNICA,EstadosSolicitudAddenda::APROBACION_TECNICA,EstadosSolicitudAddenda::ANULACION_TECNICA]
#      end
#      #Seria como un admin?
#      if current_user.in_group?:auditoria_control
#        estados_ids = estados_ids + [EstadosSolicitudAddenda::EN_REVISION_LEGAL,EstadosSolicitudAddenda::APROBACION_LEGAL]
#      end
#    
#      filtro = []
#      #Ahora saco los estados segun el actual tipo maquina de estados
#      case @solicitud_addenda.estado_solicitud_addenda_id 
#      when 1 
#        #En estado registrada solo puede quedarse registrada, anularse o pasar a revision tecnica
#        then filtro = [EstadosSolicitudAddenda::GENERADA,EstadosSolicitudAddenda::EN_REVISION_TECNICA,EstadosSolicitudAddenda::ANULACION_EFECTOR]
#      when  2
#        #En estado revision tecnica solo puede quedarse en revision tecnica,anularse, o enviada a efector
#        then  filtro = [EstadosSolicitudAddenda::EN_REVISION_TECNICA,EstadosSolicitudAddenda::APROBACION_TECNICA,EstadosSolicitudAddenda::ANULACION_TECNICA]
#      when 3
#        #En estado enviada al efector solo puede quedarse en enviada al efector o en revision legal
#        then filtro = [EstadosSolicitudAddenda::APROBACION_TECNICA,EstadosSolicitudAddenda::EN_REVISION_LEGAL]
#      when 4 
#        #En estado revision legal solo puede quedarse en revision legal o pasar a aprobada
#        then filtro =[EstadosSolicitudAddenda::EN_REVISION_LEGAL,EstadosSolicitudAddenda::APROBACION_LEGAL]
#      when 5
#        #En estado aprobada solo puede quedarse en aprobada
#        then filtro =[EstadosSolicitudAddenda::APROBACION_LEGAL]
#      else
#      end
#
#      #Valido alguna situacion consistente 
#      estados_ids = estados_ids & filtro
#      @estados_solicitudes_addendas = EstadoSolicitudAddenda.where("id in #{estados_ids.to_s.gsub('[','(').gsub(']',')')}").collect {|p| [p.nombre, p.id]}
#       
#      if @estados_solicitudes_addendas.empty?
#        redirect_to( root_url,
#          :flash => { :tipo => :error, :titulo => "La petición no es válida",
#            :mensaje => "Se informará al administrador del sistema sobre el incidente."
#          }
#        )
#        return
#      end
#    end
  

    @solicitudes_prestaciones_principales = @solicitud_addenda.solicitudes_addendas_prestaciones_principales.collect{|p| [p.prestacion_principal_id.to_s,( p.es_autorizacion ? p.prestacion_principal_id.to_s : '' )] }
    @solicitudes_prestaciones_principales_aptecnica = @solicitud_addenda.solicitudes_addendas_prestaciones_principales.collect{|p| [p.prestacion_principal_id.to_s,( p.aprobado_por_medica ? p.prestacion_principal_id.to_s : '' )] }
    
    @prestaciones_principales_autorizadas = PrestacionPrincipalAutorizada.efector_y_fecha(30)
    # 
    
  end
  

  def show
    # Verificar los permisos del usuario
    if cannot? :read, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la adenda solicitada
    begin

      @solicitud_addenda =
        SolicitudAddenda.find( params[:id],
        :include => [ {:convenio_de_gestion_sumar => :efector}]
      )
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La solicitud de adenda solicitada no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
    end
    
   
    @convenio_de_gestion_sumar = @solicitud_addenda.convenio_de_gestion_sumar
   

  end
  
  
  def create
    # Verificar los permisos del usuario
    if cannot? :create, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:solicitud_addenda] || !params[:solicitud_addenda][:convenio_de_gestion_sumar_id]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
    
    #obtengo las prestaciones principales a autorizar o desautorizar...
    @solicitudes_prestaciones_principales = (params[:solicitud_addenda][:prestacion_principal_id])
   
    # Obtener el convenio de gestión asociado
    begin
      @convenio_de_gestion = ConvenioDeGestionSumar.find(params[:solicitud_addenda][:convenio_de_gestion_sumar_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
    
    fecha_actual = Time.now
   
    @solicitud_addenda = SolicitudAddenda.new()
    @solicitud_addenda.convenio_de_gestion_sumar = @convenio_de_gestion
    @solicitud_addenda.fecha_solicitud = fecha_actual
    @solicitud_addenda.observaciones = params[:solicitud_addenda][:observaciones]
    @solicitud_addenda.estado_solicitud_addenda = EstadoSolicitudAddenda.find(1); #Estado Registrada
   
    numero =
      ActiveRecord::Base.connection.exec_query(
    
      " SELECT 
  
      COALESCE(max(id + 1),1) 
     
     from solicitudes_addendas"
    ).rows[0].collect{ |v| v.to_i}
    
    
    
    @solicitud_addenda.numero =  @convenio_de_gestion.numero+ '-SA-' +  numero[0].to_s
    
    
    
    
    #if  @solicitud_addenda.save     
    @solicitudes_prestaciones_principales.each do |pres|  
      #pres[0] es la key
      #pres[1] es el value
      #tambien podria ocupar |key,value|
        
      @solicitud_addenda_prestacion_principal =  SolicitudAddendaPrestacionPrincipal.new do |sapp|
          
        sapp.es_autorizacion = pres[1].length  > 0 
        sapp.prestacion_principal_id =  pres[0].to_i
        # sapp.solicitud_addenda = @solicitud_addenda
        @solicitud_addenda.solicitudes_addendas_prestaciones_principales << sapp
        # sapp.save
      end
    end
    @solicitud_addenda.save
    
    redirect_to(@solicitud_addenda,
        
      :flash => { :tipo => :ok, :titulo => "La solicitud de adenda #{@solicitud_addenda.numero} se creó correctamente." }
         
    )
    return
   
    #end

  end
  
  
  def update
    # Verificar los permisos del usuario
    if cannot? :update, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:solicitud_addenda]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener la solicitud que se actualizará y su convenio de gestión
    begin
      @solicitud_addenda = SolicitudAddenda.find(params[:id], :include => [{:convenio_de_gestion_sumar => :efector}])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
    
    @convenio_de_gestion = @solicitud_addenda.convenio_de_gestion_sumar
    
    # Actualizar los valores 
    @solicitud_addenda.observaciones = params[:solicitud_addenda][:obsevaciones]
    @solicitud_addenda.estado_solicitud_addenda_id= params[:solicitud_addenda][:estado_solicitud_addenda_id]
    
    
    
    @solicitud_addenda.firmante = params[:solicitud_addenda][:firmante]
    @solicitud_addenda.numero_addenda = params[:solicitud_addenda][:numero_addenda]
    @solicitud_addenda.fecha_de_inicio =  parametro_fecha(params[:solicitud_addenda], :fecha_de_inicio)
    @solicitud_addenda.fecha_de_suscripcion =  parametro_fecha(params[:solicitud_addenda], :fecha_de_suscripcion)
 
  
    @solicitudes_prestaciones_principales = params[:solicitud_addenda][:prestacion_principal_id]

    #Casos de la anulación de la solicitud
    if @solicitud_addenda.estado_solicitud_addenda_id > 5
 
      #Anulada por efector
      if @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::ANULACION_EFECTOR
        @solicitud_addenda.destroy
        redirect_to solicitudes_addendas_url,:flash => { :tipo => :ok, :titulo => 'Las solicitud de adenda se anuló correctamente.' }
      end
      #Anulada por Sumar
      if @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::ANULACION_TECNICA
        @solicitud_addenda.save
        redirect_to solicitudes_addendas_url,:flash => { :tipo => :ok, :titulo => 'Las solicitud de adenda se anuló correctamente.' }
      end
      return
    end
    
    
    #byebug
    # solo manejo los estados de la aprobacion tecnica si la solicitud en revision tecnica o enviada al efector
    if (@solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::EN_REVISION_TECNICA   ||@solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::APROBACION_TECNICA  )
      @solicitudes_prestaciones_principales_aptecnica = params[:solicitud_addenda][:prestacion_principal_tecnica_id]
      #byebug
      #Actualizo los atributos de la aprobacion medica
      @solicitudes_prestaciones_principales_aptecnica.each do |presat|  
        #me fijo si no existe el detalle sino lo creo. 
        existe = false
        @solicitud_addenda.solicitudes_addendas_prestaciones_principales.each  do |sapp| 
          if sapp.prestacion_principal_id.to_s == presat[0]
            existe = true           
            sapp.aprobado_por_medica = presat[1].length  > 0             
            break
          end
        end
        unless existe
          @solicitud_addenda_prestacion_principal =  SolicitudAddendaPrestacionPrincipal.new do |sapp|  
            sapp.es_autorizacion = presat[1].length  > 0 
            sapp.aprobado_por_medica = presat[1].length  > 0   
            sapp.prestacion_principal_id =  presat[0].to_i
            @solicitud_addenda.solicitudes_addendas_prestaciones_principales << sapp
          end
        end
      end
    end
     
     
    

    #Actualizo los atributos de la es_autorizacion de la solicitud
    @solicitudes_prestaciones_principales.each do |pres|  
      existe = false
      @solicitud_addenda.solicitudes_addendas_prestaciones_principales.each  do |sapp| 
        if sapp.prestacion_principal_id.to_s == pres[0]
          existe = true
          sapp.es_autorizacion = pres[1].length  > 0        
          break
        end
      end
        
      unless existe
        @solicitud_addenda_prestacion_principal =  SolicitudAddendaPrestacionPrincipal.new do |sapp|
          sapp.es_autorizacion = pres[1].length  > 0 
          sapp.prestacion_principal_id =  pres[0].to_i
          @solicitud_addenda.solicitudes_addendas_prestaciones_principales << sapp
              
        end
      end
    end
    
    
    
    
    
    corresponde_generar_addenda = false
    corresponde_notificar_efector = false
    
      #genero la adenda si es la primera vez que se guarda la solicitud en estado aprobada.
      if @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::APROBACION_LEGAL && @solicitud_addenda.fecha_revision_legal.nil?      
        corresponde_generar_addenda = true
      end
    
      #genero la adenda si es la primera vez que se guarda la solicitud en estado aprobada por medica/tecnica.
      if @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::APROBACION_TECNICA && @solicitud_addenda.fecha_revision_legal.nil?      
        corresponde_notificar_efector = true 
      end
    
    
      #Actualizo las fechas 
      actualiza_fechas_por_cambio_de_estado
      
      
      if  @solicitud_addenda.save
        
      if corresponde_generar_addenda  
        generar_addenda 
      end
        
      if corresponde_notificar_efector  
          notificar_efector 
      end
      
      # Redirigir a la adenda modificada
      
        redirect_to(@solicitud_addenda,
          :flash => { :tipo => :ok, :titulo => 'Las modificaciones a la solicitud de adenda se guardaron correctamente.' }
        )
      end
    
   
   
    
    
  
    
    
    
  end
    
  def confirmar_solicitud
    
    # Verificar los permisos del usuario
    if cannot? :update, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la adenda solicitada
    begin

      @solicitud_addenda =
        SolicitudAddenda.find( params[:id], :include => :estado_solicitud_addenda)
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La solicitud de adenda solicitada no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
    
    
    #valido el cambio de estado 
    if @soliciutd_addenda.estado_solicitud_id == EstadosSolicitudAddenda::GENERADA
      
       @soliciutd_addenda.estado_solicitud_id  = EstadosSolicitudAddenda::EN_REVISION_TECNICA
       if  @solicitud_addenda.save
      
          redirect_to(@solicitud_addenda,
          :flash => { :tipo => :ok, :titulo => 'Las modificaciones a la solicitud de adenda se guardaron correctamente.' }
       )
       
       else
           redirect_to(@solicitud_addenda,
          :flash => { :tipo => :error, :titulo => 'Ocurrio un error al modificar la solicitud de adenda.' })
       end
   
      
    else 
     redirect_to( root_url,
      :flash => { :tipo => :error, :titulo => "La solicitud de adenda es incorrecta",
      :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
   
    end
  end
  private
    
  def actualiza_fechas_por_cambio_de_estado 
    fecha_actual = Time.now
    if @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::GENERADA && @solicitud_addenda.fecha_solicitud.nil? 
      @solicitud_addenda.fecha_solicitud = fecha_actual
    elsif @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::APROBACION_TECNICA && @solicitud_addenda.fecha_envio_efector.nil? 
      @solicitud_addenda.fecha_revision_medica = fecha_actual
    elsif @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::APROBACION_LEGAL && @solicitud_addenda.fecha_revision_legal.nil? 

      @solicitud_addenda.fecha_revision_legal = fecha_actual
    else
    end
  end
   

  def generar_adenda 
    
    
    fecha_actual = Time.now
    @addenda = AddendaSumar.new
    @addenda.creator_id = current_user.id
    @addenda.updater_id = current_user.id
    @addenda.convenio_de_gestion_sumar_id = @solicitud_addenda.convenio_de_gestion_sumar_id
   
    #datos del firmante y fechas
    @addenda.firmante = @solicitud_addenda.firmante
    @addenda.fecha_de_suscripcion = @solicitud_addenda.fecha_de_suscripcion
    @addenda.fecha_de_inicio = @solicitud_addenda.fecha_de_inicio
    @addenda.observaciones = @solicitud_addenda.observaciones 
    @addenda.numero = @solicitud_addenda.numero_addenda
   
    if @addenda.save
      #Por cada 
      @solicitud_addenda.solicitudes_addendas_prestaciones_principales.each  do |sapp| 
     
      
      
      
      
        # Obtener la adenda
        begin
          @prestacion_principal = PrestacionPrincipal.find(sapp.prestacion_principal_id ,:include =>[ {:prestaciones => :prestaciones_pdss}])
    
      
        rescue ActiveRecord::RecordNotFound
          redirect_to( root_url,
            :flash => { :tipo => :error, :titulo => "La petición no es válida",
              :mensaje => "Se informará al administrador del sistema sobre el incidente."
            }
          )
          return
        end
      
      
      
        @prestacion_principal.prestaciones_pdss.each do |p|
          actual = PrestacionPdssAutorizada.pres_autorizadas(@solicitud_addenda.convenio_de_gestion_sumar.efector_id, fecha_actual, p.id.to_s)
              
    
       
          if not actual.first
            #no se encontro la prestacion por lo que el efector no la tiene autorizada
            #hacemos un insert de la prestacion nueva siempre que se encuentre seleccionada
          
          
            if  sapp.aprobado_por_medica?
              CustomQuery.ejecutar(
                {
                  sql: " 
                                          INSERT INTO prestaciones_pdss_autorizadas
                                          (efector_id, prestacion_pdss_id, fecha_de_inicio, autorizante_al_alta_type, autorizante_al_alta_id)
                                          VALUES
                                          (#{@solicitud_addenda.convenio_de_gestion_sumar.efector_id}, #{p.id.to_s}, '#{ @addenda.fecha_de_inicio.strftime('%Y-%m-%d')}', 'AddendaSumar', #{ @addenda.id })",

                }) 
            end
            
          else   
             
            #si esta y esta deseleccionada es que la da de baja
            if not sapp.aprobado_por_medica?
              #la doy de baja
              CustomQuery.ejecutar(
                {
                  sql: "
                        UPDATE  prestaciones_pdss_autorizadas SET fecha_de_finalizacion = '#{ @addenda.fecha_de_inicio.strftime('%Y-%m-%d')}',
                                                                            autorizante_de_la_baja_type= 'AddendaSumar' 
                                                                            , autorizante_de_la_baja_id=  #{ @addenda.id }
                                                                        WHERE efector_id = #{@solicitud_addenda.convenio_de_gestion_sumar.efector_id} AND
                                                                              prestacion_pdss_id = #{actual.first["prestacion_pdss_id"]}",
                                 
                }) 
              #unless guardado
              #    raise ActiveRecord::Rollback, "Call tech support!"
              #    return false 
              #  end
            
            end
            #si esta y esta seleccionada no hacemos nada
        
        
        
          end
  
        end
    
    
    
      end
      
    end
    
   
  end
    
  def notificar_efector
      
  end
    
end
