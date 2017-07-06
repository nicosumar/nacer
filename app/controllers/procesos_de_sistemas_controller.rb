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

    @tipos_proceso_de_sistema = TipoProcesoDeSistema.all.collect{ |p| [ p.nombre,p.id]}
    @tipos_proceso_de_sistema << [ "TODOS",0]
    @filtro_tipo = params[:tipo_proceso_de_sistema_id] ?  params[:tipo_proceso_de_sistema_id] : 0

    @estados_proceso_de_sistema = EstadoProcesoDeSistema.all.collect{ |p| [ p.nombre,p.id]}
    @estados_proceso_de_sistema << [ "TODOS",0]
    @filtro_estado = params[:estado_proceso_de_sistema_id] ?  params[:estado_proceso_de_sistema_id] : 0


  	@procesos_de_sistemas = ProcesoDeSistema.accessible_by(current_ability).where(" ( 0 = ? or estado_proceso_de_sistema_id = ?) and (0 = ? or tipo_proceso_de_sistema_id = ?) " ,@filtro_estado,@filtro_estado,@filtro_tipo,@filtro_tipo ).paginate(:page => params[:page], :per_page => 20,
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
	    @jobs = Delayed::Job.where("proceso_de_sistema_id = ?",@proceso_de_sistema.id )
     
      if   @jobs.empty?
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
