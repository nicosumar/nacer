class SolicitudesAddendasMailer < ActionMailer::Base
  default from: "from@example.com"

  def notificar_solicitud_addenda(solicitud_addenda)
    @solicitud_addenda = solicitud_addenda
    @User = User.find(@solicitud_addenda.user_creator_id)
   
    
    referente = @solicitud_addenda.convenio_de_gestion_sumar.efector.referente_al_dia(@solicitud_addenda.fecha_solicitud)
    
    if referente.present?
        email =  referente.contacto.email
            if !email.blank?
                mail(to: @User.email, subject: 'Solicitud Aprobada por el área técnica'+ @solicitud_addenda.convenio_de_gestion_sumar.numero)
            end 
    end

    mail(to: email, subject: 'Solicitud Aprobada por el área técnica'+ @solicitud_addenda.convenio_de_gestion_sumar.numero)
  end

  def notificar_solicitud_addenda_medica(solicitud_addenda)
    @solicitud_addenda = solicitud_addenda
    @User = User.find(@solicitud_addenda.user_creator_id)
    mail(to: 'tecnicanacer-salud@mendoza.gov.ar', subject: 'Solicitud de adenda pendiente convenio: '+ @solicitud_addenda.convenio_de_gestion_sumar.numero)

    
  end


end
