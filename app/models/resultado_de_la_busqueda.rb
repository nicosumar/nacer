# -*- encoding : utf-8 -*-
class ResultadoDeLaBusqueda < ActiveRecord::Base
  # Este modelo está asociado a una vista temporaria que se crea cuando
  # se realizan búsquedas de texto completo (FTS).
  
  attr_accessor :instancia
  
  def instancia
  	case modelo_type.strip

  	when "Afiliado"
  		Afiliado.where("afiliado_id = #{modelo_id}").first

  	when "Prestacion"
  		Prestacion.where("id = #{modelo_id}").first
  	end

  	
  end

end
