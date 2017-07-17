# -*- encoding : utf-8 -*-
class InicioController < ApplicationController

  def index

  	if @uad_actual != nil and @uad_actual.facturacion?

      fecha_notificacion = @uad_actual.fecha_ultimas_notificaciones
      @cantidad_total = PrestacionBrindada.con_advertencias_visibles.size

  		if fecha_notificacion == nil or (Time.now.year >= fecha_notificacion.year and Time.now.month > fecha_notificacion.month)
  			#si no tiene una fecha registrada o bien, si tiene una fecha pero es anterior a este año y mes, entonces
  			#tengo que crear las notificaciones de nuevo y asociarlas a la uad

  			create_new_notifications

  		else
  			
        @notificaciones = Notificacion.where(:unidad_de_alta_de_datos_id => @uad_actual.id).paginate(:page => params[:page], :per_page => 20, :order => "fecha_evento DESC")

  		end
  	end

    redirect_to(new_user_session_path, :flash => flash) unless user_signed_in?
  end

  def create_new_notifications

  	notificaciones = Notificacion.where(:unidad_de_alta_de_datos_id => @uad_actual.id)
  	
  	notificaciones.each do |notificacion|

  		notificacion.destroy

  	end

  	meses_check = 4
	  fecha_ref = Date.parse((Time.now - meses_check.month).to_s)

  	PrestacionBrindada.con_advertencias_visibles.each do |prestacion|

		#prestacion_id
		#fecha_de_la_prestacion

		if prestacion.fecha_de_la_prestacion >= fecha_ref

			notificacion = Notificacion.new

	  		notificacion.mensaje = "Prestación Brindada (#" + prestacion.id.to_s + ") tiene advertencias.\nRecuerda que estas deben ser corregidas para que se pueda facturar."

	  		notificacion.fecha_evento = prestacion.fecha_de_la_prestacion
	  		notificacion.enlace = prestaciones_brindadas_path + "/" + prestacion.id.to_s
	  		notificacion.unidad_de_alta_de_datos_id = @uad_actual.id
	  		notificacion.tiene_vista = true

	  		if notificacion.save!
	            
	        #TODO OKU, ENTONCES SIGO!

	        else

	    		redirect_to( root_url,
			        :flash => {:tipo => :error, :titulo => "Error al crear las notificaciones",
			          :mensaje => "Ocurrió un error en el proceso de creación de notificaciones. Por favor, recargue la página."
			        }
			      )
		    	return

	        end

	    end

  	end

  	@uad_actual.fecha_ultimas_notificaciones = Time.now
  	@uad_actual.save!

  	@notificaciones = Notificacion.where(:unidad_de_alta_de_datos_id => @uad_actual.id).paginate(:page => params[:page], :per_page => 20, :order => "fecha_evento DESC")

  end

end
