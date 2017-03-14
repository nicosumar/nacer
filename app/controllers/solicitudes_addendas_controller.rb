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
    
    @estados_solicitudes_addendas = EstadoSolicitudAddenda.all.collect {|p| [p.nombre, p.id]}
    
    
    
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
  
  
  # DELETE /solicitud_adddenda/1
  def destroy
    
    @solicitud_addenda = SolicitudAddenda.find(params[:id])
    @solicitud_addenda.destroy
    redirect_to solicitudes_addendas_url
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
          {:convenio_de_gestion_sumar => :efector}
        #  ,{:solicitudes_adddendas_prestaciones_principales => :prestacion_principal}
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
    @solicitud_addenda.estado_solicitud_addenda = EstadoSolicitudAddenda.find(1); #Estado Registrada
   
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
    
    # Actualizar los valores de los atributos no protegidos por asignación masiva
    @solicitud_addenda.attributes = params[:solicitud_addenda]

    # Verificar la validez del objeto
    if @solicitud_addenda.valid?
     
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
   
      # Registrar el usuario que realiza la modificación
#      @solicitud_addenda.updater_id = current_user.id

      # Guardar la nueva addenda y sus prestaciones asociadas
      if @solicitud_addenda.save
        # Modificar los registros dependientes en la tabla asociada si los parámetros pasaron todas las validaciones
        # TODO: cambiar este método ya que destruye previamente la información existente
#        @addenda.prestaciones_autorizadas_alta.destroy_all
#        @prestacion_autorizada_alta_ids.each do |prestacion_id|
#          prestacion_autorizada_alta = PrestacionAutorizada.new
#          prestacion_autorizada_alta.attributes = 
#            {
#              :efector_id => @convenio_de_gestion.efector_id,
#              :prestacion_id => prestacion_id,
#              :fecha_de_inicio => @addenda.fecha_de_inicio
#            }
#         @addenda.prestaciones_autorizadas_alta << prestacion_autorizada_alta
#        end
#        @addenda.prestaciones_autorizadas_baja.each do |p|
#          prestacion_autorizada = PrestacionAutorizada.find(p)
#          prestacion_autorizada.attributes = 
#            {
#              :fecha_de_finalizacion => nil,
#              :autorizante_de_la_baja_type => nil,
#              :autorizante_de_la_baja_id => nil
#            }
#          prestacion_autorizada.save
#        end
#        @prestacion_autorizada_baja_ids.each do |prestacion_autorizada_id|
#         prestacion_autorizada_baja = PrestacionAutorizada.find(prestacion_autorizada_id)
#          prestacion_autorizada_baja.attributes = {:fecha_de_finalizacion => @addenda.fecha_de_inicio}
#          @addenda.prestaciones_autorizadas_baja << prestacion_autorizada_baja
#        end
      end

      # Redirigir a la adenda modificada
      redirect_to(@solicitud_addenda,
        :flash => { :tipo => :ok, :titulo => 'Las modificaciones a la solicitud de adenda se guardaron correctamente.' }
      )
    else
      # Crear los objetos necesarios para regenerar la vista si hay algún error
      @prestaciones_alta =
        Prestacion.no_autorizadas_sumar_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
          [ g[0] + " - " + g[1], 
            (Prestacion.no_autorizadas_sumar_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).where("grupo = ?", g[0]).collect { |p|
              [p.codigo + " - " + p.nombre_corto, p.id]
            })
          ]
        }

      @prestaciones_baja =
        PrestacionAutorizada.autorizadas_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).map {|grup| [grup.grupo_id, grup.grupo]}.uniq.collect { |g|
          [ g[0] + " - " + g[1], 
            (PrestacionAutorizada..autorizadas_antes_del_dia(@convenio_de_gestion.efector.id, @addenda.fecha_de_inicio).where("grupo = ?", g[0]).collect { |p|
              [p.prestacion.codigo + " - " + p.prestacion.nombre_corto, p.id]
            })
          ]
        }
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "edit"
    end
  end
end
