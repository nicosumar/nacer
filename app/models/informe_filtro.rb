class InformeFiltro < ActiveRecord::Base
  
  #Relaciones
  belongs_to :informe_filtro_validador_ui
  belongs_to :informe
  
  #"sexy" validations
  validates :nombre, presence: true
  validates :valor_por_defecto, presence: true
  
  #Atributos
  attr_accessible :nombre, :valor_por_defecto, :informe_filtro_validador_ui_id, :posicion

  def valor_por_defecto

    if informe_filtro_validador_ui.tipo == "LOV"
      resp = []
    	cq = CustomQuery.buscar({
    		sql: self[:valor_por_defecto]
    	})

      cq.each do |n|
        resp << n.valor
        resp << n.texto
      end
      
      return resp
    else
      return self[:valor_por_defecto]
    end
  	
  end

end
