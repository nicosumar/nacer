class ProcesosDeSistemasController < ApplicationController
  before_filter :authenticate_user!

  def index

#byebug
    if cannot? :read, ProcesoDeSistema
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end


  	@procesos_de_sistemas = ProcesoDeSistema.accessible_by(current_ability).paginate(:page => params[:page], :per_page => 20,
        :include => [:estado_proceso_de_sistema, :tipo_proceso_de_sistema, :delayed_job]
    ).order( 'procesos_de_sistemas.id DESC' )


  end

  def destroy
  	
  	# Verificar los permisos del usuario
    if cannot? :manage, ProcesoDeSistema
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    begin
	    @proceso_de_sistema = ProcesoDeSistema.find(params[:id])
	    
	    if @proceso_de_sistema.destroy
	    	     redirect_to(procesos_de_sistemas_path,
		        :flash => { :tipo => :ok, :titulo => "El proceso de sistema ha sido eliminado con éxito"
		     
		        }
	    		 )
	    else
	    	  redirect_to(procesos_de_sistemas_path,
		        :flash => { :tipo => :advertencia, :titulo => "No se ha podido eliminar el proceso de sistema",
		          :mensaje => "Verifique que no este asociado a un Job."
		        }
		        )
	    end

    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
    
    procesos_de_sistemas_path
    


  end







end
