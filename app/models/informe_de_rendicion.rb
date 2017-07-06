class InformeDeRendicion < ActiveRecord::Base

	belongs_to :estado_del_proceso
	belongs_to :efector

	has_many :detalles_informe_de_rendicion, :autosave => true, :dependent => :destroy
  	
	attr_accessible :fecha_informe, :total, :efector_id, :estado_del_proceso_id, :codigo
	
	accepts_nested_attributes_for :detalles_informe_de_rendicion, :reject_if => :all_blank, :allow_destroy => true

    def get_nombre_efector

      efector.nombre

    end

    def get_cuie_efector

      efector.cuie

    end

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
  	
    def get_total_1

      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 1) ? detalle.importe : 0

      end

      return total

    end 
    def get_total_11

      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 1 && detalle.tipo_de_gasto.numero == "1") ? detalle.importe : 0

      end

      return total

    end 
    def get_total_12
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 1 && detalle.tipo_de_gasto.numero == "2") ? detalle.importe : 0

      end

      return total
    end 
    def get_total_13
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 1 && detalle.tipo_de_gasto.numero == "3") ? detalle.importe : 0

      end

      return total
    end 

    def get_total_2

      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 2) ? detalle.importe : 0

      end

      return total

    end 
    def get_total_21
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 2 && detalle.tipo_de_gasto.numero == "1") ? detalle.importe : 0

      end

      return total
    end 
    def get_total_22
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 2 && detalle.tipo_de_gasto.numero == "2") ? detalle.importe : 0

      end

      return total
    end 
    def get_total_23
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 2 && detalle.tipo_de_gasto.numero == "3") ? detalle.importe : 0

      end

      return total
    end 

    def get_total_3

      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 3) ? detalle.importe : 0

      end

      return total

    end 
    def get_total_31
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 3 && detalle.tipo_de_gasto.numero == "1") ? detalle.importe : 0

      end

      return total
    end 
    def get_total_32
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 3 && detalle.tipo_de_gasto.numero == "2") ? detalle.importe : 0

      end

      return total
    end 

    def get_total_4

      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 4) ? detalle.importe : 0

      end

      return total

    end 
    def get_total_41
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 4 && detalle.tipo_de_gasto.numero == "1") ? detalle.importe : 0

      end

      return total
    end 
    def get_total_42
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 4 && detalle.tipo_de_gasto.numero == "2") ? detalle.importe : 0

      end

      return total
    end 
    def get_total_43
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 4 && detalle.tipo_de_gasto.numero == "3") ? detalle.importe : 0

      end

      return total
    end 

    def get_total_5

      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 5) ? detalle.importe : 0

      end

      return total

    end 
    def get_total_51
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 5 && detalle.tipo_de_gasto.numero == "1") ? detalle.importe : 0

      end

      return total
    end 
    def get_total_52
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 5 && detalle.tipo_de_gasto.numero == "2") ? detalle.importe : 0

      end

      return total
    end 
    def get_total_53
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 5 && detalle.tipo_de_gasto.numero == "3") ? detalle.importe : 0

      end

      return total
    end 

    def get_total_6

      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 6) ? detalle.importe : 0

      end

      return total

    end 
    def get_total_61
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 6 && detalle.tipo_de_gasto.numero == "1") ? detalle.importe : 0

      end

      return total
    end 
    def get_total_62
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 6 && detalle.tipo_de_gasto.numero == "2") ? detalle.importe : 0

      end

      return total
    end 
    def get_total_63
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 6 && detalle.tipo_de_gasto.numero == "3") ? detalle.importe : 0

      end

      return total
    end 

    def get_total_7

      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 7) ? detalle.importe : 0

      end

      return total

    end 
    def get_total_71
      total = 0

      detalles_informe_de_rendicion.each do |detalle|

        total += (detalle.tipo_de_gasto.clase_de_gasto_id == 7 && detalle.tipo_de_gasto.numero == "1") ? detalle.importe : 0

      end

      return total
    end 

end
