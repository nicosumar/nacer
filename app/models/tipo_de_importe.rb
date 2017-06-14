class TipoDeImporte < ActiveRecord::Base

	has_many :detalles_informe_de_rendicion

  	attr_accessible :nombre

end
