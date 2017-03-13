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
      SolicitudAddenda.paginate(:page => params[:page], :per_page => 20, :include =>{:convenio_de_gestion_sumar => :efector} ,
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
    @solicitudes_prestaciones_princpales = []
    

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
          :estado_solicitud_addenda,
          {:convenio_de_gestion_sumar => :efector},
          {:solicitudes_adddendas_prestaciones_principales => :prestacion_principal}
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
    @efector = @solicitud_addenda.efector
    
    @convenio_de_gestion = @addenda.convenio_de_gestion
    
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
    @solicitud_addenda.firmante = params[:solicitud_addenda][:firmante]
    @solicitud_addenda.fecha_solicitud = fecha_actual
    @solicitud_addenda.observaciones = params[:solicitud_addenda][:observaciones]

    numero =
     ActiveRecord::Base.connection.exec_query(
    
      " SELECT 
  
      COALESCE(max(id + 1),1) 
     
     from solicitudes_addendas"
    ).rows[0].collect{ |v| v.to_i}
    
    
    
    @solicitud_addenda.numero =  @convenio_de_gestion.nombre[ 0,7]+ '-' +  numero[0].to_s
    
    
    
    
    if @solicitud_addenda.save    

      redirect_to(@solicitud_addenda,
        
         :flash => { :tipo => :ok, :titulo => "La solicitud de adenda #{@solicitud_addenda.numero} se creó correctamente." }
         
      )
      return
   
    end
    
    render :action => "new"
    return
  end
end
