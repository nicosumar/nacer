class TipoNotificacion < ActiveRecord::Base
  	
  has_many :notificaciones

  attr_accessible :nombre
end
