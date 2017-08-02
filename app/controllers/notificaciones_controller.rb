class NotificacionesController < ApplicationController
  def index
  end

  def new
  end

  def show
  end

  def edit
  end

  def update

  	notificacion = Notificacion.find(params[:id])

  	notificacion.fecha_lectura = Time.now

    pagina = (params[:page] == nil) ? 1 : params[:page]

  	if notificacion.save!
  		redirect_to( root_url + "?page=" + pagina.to_s,
        :flash => {:tipo => :ok, :titulo => "Operación realizada con éxito",
          :mensaje => "Se ocultó la notificación seleccionada."
        }
      )
      return
    else
    	redirect_to( root_url + "?page=" + pagina.to_s,
        :flash => {:tipo => :error, :titulo => "Error en la operación",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

  end
end
