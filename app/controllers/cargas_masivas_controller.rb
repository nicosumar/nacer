class CargasMasivasController < ApplicationController
before_filter :authenticate_user!

def index
	# Verificar los permisos del usuario
    if cannot? :read, CargaMasiva
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

#Aplico los filtros que pasan por sistemas

   	if params[:estado_del_proceso_id].present?
		  @cargas_masivas = CargaMasiva.where("unidad_de_alta_de_datos_id = ? and estado_del_proceso_id = ?",@uad_actual.id,params[:estado_del_proceso_id])
	  else
  		@cargas_masivas = CargaMasiva.where("unidad_de_alta_de_datos_id = ?",@uad_actual.id)
	  end
      @estados_de_los_procesos = 
        [["En cualquier estado", nil]] +
        EstadoDelProceso.find(:all, :order => :id).collect{ |e| ["En estado '" + e.nombre + "'", e.id] }

end


def new

 # Verificar los permisos del usuario
    if cannot? :create, CargaMasiva
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

	@carga_masiva = CargaMasiva.new()

end



def create

	# Verificar los permisos del usuario
	if cannot? :create, CargaMasiva
	  redirect_to( root_url,
	    :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
	      :mensaje => "Se informará al administrador del sistema sobre este incidente."
	    }
	  )
	  return
	end
	
	# Verificar si la petición contiene los parámetros esperados
    if !params[:carga_masiva] 
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end


#CARGAR ARCHIVO DE PRESTACIONES MASIVAS


@carga_masiva = CargaMasiva.new()  

	if params[:carga_masiva][:archivo]
      @archivo = Archivo.new()
      @archivo.titulo = params[:carga_masiva][:archivo].original_filename
      @archivo.save
	

#CREAR CARGA MASIVA
  
    @carga_masiva.archivo_file_name = params[:carga_masiva][:archivo].original_filename
    @carga_masiva.archivo_content_type = params[:carga_masiva][:archivo].content_type
    @carga_masiva.archivo_file_size = params[:carga_masiva][:archivo].tempfile.size
    @carga_masiva.archivo_updated_at = Time.now
   	@carga_masiva.numero = CargaMasiva.last.nil? ? 1 : CargaMasiva.last.numero + 1
   	@carga_masiva.efector =  @uad_actual.efector
   	@carga_masiva.unidad_de_alta_de_datos =  @uad_actual
   	@carga_masiva.user =  User.find(current_user.id)
    @carga_masiva.archivo.assign(params[:carga_masiva][:archivo])
    @carga_masiva.archivo_id = @archivo.id
    @carga_masiva.estado_del_proceso = EstadoDelProceso.find(EstadosDelProceso::NO_INICIADO)
  
  end

  if @carga_masiva.valid?
		@carga_masiva.save
    	redirect_to(@carga_masiva,:flash => { :tipo => :ok, :titulo => 'La carga se creó correctamente.' })
	else
		# Si no pasa las validaciones, volver a mostrar el formulario con los errores
		render :action => "new"

	end

end

def show
	
	# Verificar los permisos del usuario
	if cannot? :view, CargaMasiva
	  redirect_to( root_url,
	    :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
	      :mensaje => "Se informará al administrador del sistema sobre este incidente."
	    }
	  )
	  return
	end

	begin
	# Obtener la carga masiva que se visualizará
	@carga_masiva = CargaMasiva.where("id = ?", params[:id]).first

    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
    return
    end

	# Verificar si la petición contiene los parámetros esperados
    if !@carga_masiva
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
end

def destroy

end

def edit
  # Verificar los permisos del usuario
    if cannot? :update, CargaMasiva
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

# Obtener la carga masiva que se actualizará y su convenio de gestión
    begin
		@carga_masiva   = CargaMasiva.where("id = ?", params[:id]).first
    @archivo = @carga_masiva.archivo

    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

end

def update
    # Verificar los permisos del usuario
    if cannot? :update, CargaMasiva
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:carga_masiva]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener la carga masiva que se actualizará y su convenio de gestión
    begin
    @carga_masiva = CargaMasiva.find(params[:id])

    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    #Verifico si ha un archivo nuevo cargado y remplazo el anterior por el nuevo. El viejo queda guardado

    if (!params[:carga_masiva][:archivo].nil?) && (params[:carga_masiva][:archivo] != @carga_masiva.archivo)
      
      @archivo = Archivo.find(@carga_masiva.archivo_id)
      @archivo.titulo = params[:carga_masiva][:archivo].original_filename
      @archivo.save
      
      @carga_masiva.archivo_file_name = params[:carga_masiva][:archivo].original_filename
      @carga_masiva.archivo_content_type = params[:carga_masiva][:archivo].content_type
      @carga_masiva.archivo_file_size = params[:carga_masiva][:archivo].tempfile.size
      @carga_masiva.archivo_updated_at = Time.now
      @carga_masiva.efector =  @uad_actual.efector
      @carga_masiva.unidad_de_alta_de_datos =  @uad_actual
      @carga_masiva.user =  User.find(current_user.id)
      @carga_masiva.archivo.assign(params[:carga_masiva][:archivo])
      

    end
    @carga_masiva.observaciones = params[:carga_masiva][:observaciones]


    if @carga_masiva.save
    	redirect_to(@carga_masiva, :flash => { :tipo => :ok, :titulo => 'Las modificaciones en la carga se guardaron correctamente.' }
      )

    else
    	render :action => "edit"

    end

end


end
