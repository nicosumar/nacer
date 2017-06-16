class InformeDeRendicion < ActiveRecord::Base

	belongs_to :estado_del_proceso
	belongs_to :efector

	has_many :detalles_informe_de_rendicion, :autosave => true, :dependent => :destroy
  	
	attr_accessible :fecha_informe, :total, :efector_id, :estado_del_proceso_id
	
	accepts_nested_attributes_for :detalles_informe_de_rendicion, :reject_if => :all_blank, :allow_destroy => true

    def get_total

      if total == nil
        return 0
      else 
        return total
      end

    end

  	def get_total_servicios

  		total = 0

  		detalles_informe_de_rendicion.each do |detalle|

  			total += (detalle.tipo_de_importe_id == 1) ? detalle.importe : 0

  		end

  		return total

  	end

  	def get_total_obras

  		total = 0

  		detalles_informe_de_rendicion.each do |detalle|

  			total += (detalle.tipo_de_importe_id == 2) ? detalle.importe : 0

  		end

  		return total

  	end

  	def get_total_ctes

  		total = 0

  		detalles_informe_de_rendicion.each do |detalle|

  			total += (detalle.tipo_de_importe_id == 3) ? detalle.importe : 0

  		end

  		return total

  	end

  	def get_total_capital

  		total = 0

  		detalles_informe_de_rendicion.each do |detalle|

  			total += (detalle.tipo_de_importe_id == 4) ? detalle.importe : 0

  		end

  		return total

  	end
  	
end
