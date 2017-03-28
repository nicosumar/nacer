class SolicitudesAddendasMailer < ActionMailer::Base
  default from: "from@example.com"

  def notificar_solicitud_addenda(solicitud_addenda)
    @solicitud_addenda = solicitud_addenda
    @User = User.find(@solicitud_addenda.user_creator_id)
   
    
    referente = @solicitud_addenda.convenio_de_gestion_sumar.efector.referente_al_dia(@solicitud_addenda.fecha_solicitud)
    
    if referente.present?
      
      email =  referente.contacto.email
      if email.blank?
        mail(to: @User.email, subject: 'Solicitud Aprobada por el área técnica')
      else
        mail(to: @User.email, cc: email , subject: 'Solicitud Aprobada por el área técnica')
      end
    end

  end
end
