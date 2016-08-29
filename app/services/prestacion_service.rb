class PrestacionService    
  
  class << self
               
    def popular_a_plan_de_salud prestaciones
      secciones_grupo_pdss = []
      linea_de_cuidado = { }
      
      prestaciones.each do |prestacion|
        prestacion.prestaciones_pdss.each do |prestacion_pdss|
          seccion_pdss_id = prestacion_pdss.grupo_pdss.seccion_pdss.id
          grupo_pdss_id = prestacion_pdss.grupo_pdss.id
          linea_de_cuidado_id = prestacion_pdss.linea_de_cuidado.id

          seccion_grupo_pdss_array = secciones_grupo_pdss.select {|seccion_grupo_pdss| seccion_grupo_pdss[:seccion_pdss_id] == seccion_pdss_id && seccion_grupo_pdss[:grupo_pdss_id] == grupo_pdss_id }

          seccion_grupo_pdss = seccion_grupo_pdss_array.first
          if seccion_grupo_pdss == nil
            seccion_grupo_pdss = { :seccion_pdss_id => 0, :grupo_pdss_id => 0, :nombre => "", :lineas_de_cuidado =>  [], :prestaciones_count => 0 }
            seccion_grupo_pdss[:seccion_pdss_id] = prestacion_pdss.grupo_pdss.seccion_pdss.id
            seccion_grupo_pdss[:grupo_pdss_id] = prestacion_pdss.grupo_pdss.id
            seccion_grupo_pdss[:nombre] = prestacion_pdss.grupo_pdss.seccion_pdss.nombre + " / " + prestacion_pdss.grupo_pdss.nombre
            seccion_grupo_pdss[:lineas_de_cuidado] =  []
            secciones_grupo_pdss << seccion_grupo_pdss
          end

          lineas_de_cuidado_array = seccion_grupo_pdss[:lineas_de_cuidado].select {|linea_de_cuidado| linea_de_cuidado[:id] == linea_de_cuidado_id }
          linea_de_cuidado = lineas_de_cuidado_array.first
          if linea_de_cuidado == nil
            linea_de_cuidado = { :id => 0, :nombre => "", :prestaciones =>  [] }
            linea_de_cuidado[:id] = linea_de_cuidado_id
            linea_de_cuidado[:nombre] = prestacion_pdss.linea_de_cuidado.nombre
            linea_de_cuidado[:prestaciones] = []
            seccion_grupo_pdss[:lineas_de_cuidado] << linea_de_cuidado
          end

          prestaciones_array = linea_de_cuidado[:prestaciones].select {|prestacion| prestacion[:id] == prestacion.id }
          if prestaciones_array.blank?
            linea_de_cuidado[:prestaciones] << prestacion 
            seccion_grupo_pdss[:prestaciones_count] += 1
          end
        end
      end   
      
      return secciones_grupo_pdss
    end
  
  end
end