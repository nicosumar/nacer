class PrestacionService    
  
  class << self
               
    def popular_a_plan_de_salud prestaciones
      secciones_pdss = []
      secciones_grupo_pdss = []
      linea_de_cuidado = { }
      
      prestaciones.each do |prestacion|
        if prestacion.prestaciones_pdss.present? and (prestacion.prestaciones_pdss.first.persisted?)
          prestacion.prestaciones_pdss.each do |prestacion_pdss|
            seccion_pdss_id = prestacion_pdss.grupo_pdss.seccion_pdss.id
            grupo_pdss_id = prestacion_pdss.grupo_pdss.id
            linea_de_cuidado_id = prestacion_pdss.linea_de_cuidado.present? ? prestacion_pdss.linea_de_cuidado.id : 0
            
            seccion_pdss_array = secciones_pdss.select {|seccion_pdss| seccion_pdss[:seccion_pdss_id] == seccion_pdss_id }
            seccion_pdss = seccion_pdss_array.first

            if seccion_pdss == nil
              seccion_pdss = { :seccion_pdss_id => 0, :nombre => "Sin especificar", :secciones_grupo_pdss =>  [], :prestaciones_count => 0 }
              seccion_pdss[:seccion_pdss_id] = prestacion_pdss.grupo_pdss.seccion_pdss.id
              seccion_pdss[:nombre] = prestacion_pdss.grupo_pdss.seccion_pdss.nombre
              seccion_pdss[:secciones_grupo_pdss] = []
              secciones_pdss << seccion_pdss
            end

            seccion_grupo_pdss_array = seccion_pdss[:secciones_grupo_pdss].select {|seccion_grupo_pdss| seccion_grupo_pdss[:seccion_pdss_id] == seccion_pdss_id && seccion_grupo_pdss[:grupo_pdss_id] == grupo_pdss_id }

            seccion_grupo_pdss = seccion_grupo_pdss_array.first
            if seccion_grupo_pdss == nil
              seccion_grupo_pdss = { :seccion_pdss_id => 0, :grupo_pdss_id => 0, :nombre => "Sin especificar", :lineas_de_cuidado =>  [], :prestaciones_count => 0 }
              seccion_grupo_pdss[:seccion_pdss_id] = prestacion_pdss.grupo_pdss.seccion_pdss.id
              seccion_grupo_pdss[:grupo_pdss_id] = prestacion_pdss.grupo_pdss.id
              seccion_grupo_pdss[:nombre] = prestacion_pdss.grupo_pdss.nombre
              seccion_grupo_pdss[:lineas_de_cuidado] =  []
              seccion_pdss[:secciones_grupo_pdss] << seccion_grupo_pdss
            end

            lineas_de_cuidado_array = seccion_grupo_pdss[:lineas_de_cuidado].select {|linea_de_cuidado| linea_de_cuidado[:id] == linea_de_cuidado_id }
            linea_de_cuidado = lineas_de_cuidado_array.first
            if linea_de_cuidado == nil
              linea_de_cuidado = { :id => 0, :nombre => "Sin especificar", :prestaciones =>  [] }
              linea_de_cuidado[:id] = linea_de_cuidado_id
              linea_de_cuidado[:nombre] = prestacion_pdss.linea_de_cuidado.nombre if prestacion_pdss.linea_de_cuidado.present?
              linea_de_cuidado[:prestaciones] = []
              seccion_grupo_pdss[:lineas_de_cuidado] << linea_de_cuidado
            end
            
            prestaciones_array = linea_de_cuidado[:prestaciones].select {|p| p[:id] == prestacion.id }
            if prestaciones_array.blank?
              linea_de_cuidado[:prestaciones] << prestacion 
              seccion_grupo_pdss[:prestaciones_count] += 1
              seccion_pdss[:prestaciones_count] += 1
            end
          end
        end
      end   
      
      return secciones_pdss
    end
  
  end
end
