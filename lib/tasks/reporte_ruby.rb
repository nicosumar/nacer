# -*- encoding : utf-8 -*-
class ReporteRuby
  
  def self.mensual_de_prestaciones_brindadas_por_grupo(arg_nomenclador, arg_anio)
    
    resp = []
    filtros = []
    sql = []

    # array dimensiones: 
    # 1: Array [Nombre del grupo, numero de grupo]
    # 2: Array [ids de prestaciones, .. ]
    # 3: Array [ids de diagnosticos para esas prestaciones, .. ]
    # prestaciones_paquete_basico_diagnostico = [
    #   [['Embarazadas', 1], [258], [45]], #CTC005W78
    #   [['Embarazadas', 1], [259], [45]]  #CTC006W78
    # ]
    grupos_y_filtros = [['Embarazadas', 1],[arg_nomenclador, arg_anio]],
      [['Cero a Cinco', 2],[arg_nomenclador, arg_anio]],
      [['Seis a Nueve', 3],[arg_nomenclador, arg_anio]],
      [['Diez a Diecinueve', 4],[arg_nomenclador, arg_anio]],
      [['Veinte a Sesenta y cuatro', 6],[arg_nomenclador, arg_anio]]
    

    grupos_y_filtros.each do |g|
      sql <<  <<-SQL
        select '#{g.first.first}' "Grupo", 
                pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación", d.codigo "Diagnóstico", 
                e.nombre "Efector", e.cuie "CUIE",
                extract(month from p.fecha_de_la_prestacion ) "Mes de Prestación", extract(year from p.fecha_de_la_prestacion ) "Año de Prestación",
                count(*) "Cant.", round(sum(p.monto),2) "Total"
         from prestaciones_incluidas pi
           join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id 
           join diagnosticos d on d.id = p.diagnostico_id 
           join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario 
           join efectores e on e.id = p.efector_id 
           join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id
         where pi.prestacion_id in ( select p.id 
                                   from migra_prestaciones mp
                                     join prestaciones p on p.id = mp.id_subrrogada_foranea
                                   where mp.grupo = #{g.first.last}        -- Solo prestaciones del grupo que corresponda
                                   and p.concepto_de_facturacion_id = 1)   -- Solo prestaciones del paquete basico 
         and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada 
         and pi.nomenclador_id = ?
         and extract(year from p.fecha_de_la_prestacion ) = ? 
         GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, 
                  e.nombre, e.cuie, 
                  extract(month from p.fecha_de_la_prestacion ), extract(year from p.fecha_de_la_prestacion )
      SQL
      filtros << g.last
    end

    sql <<  <<-SQL
      select 'Comunitaria' "Grupo", 
              pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación", d.codigo "Diagnóstico", 
              e.nombre "Efector", e.cuie "CUIE",
              extract(month from p.fecha_de_la_prestacion ) "Mes de Prestación", extract(year from p.fecha_de_la_prestacion ) "Año de Prestación",
              count(*) "Cant.", round(sum(p.monto),2) "Total"
       from prestaciones_incluidas pi
         join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id 
         join diagnosticos d on d.id = p.diagnostico_id 
         join efectores e on e.id = p.efector_id 
         join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id
       where p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada 
       and pi.prestacion_comunitaria                           -- solo prestaciones comunitarias
       and pi.nomenclador_id = ?
       and extract(year from p.fecha_de_la_prestacion ) = ? 
       GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, 
                e.nombre, e.cuie, 
                extract(month from p.fecha_de_la_prestacion ), extract(year from p.fecha_de_la_prestacion )
    SQL
    filtros << [arg_nomenclador, arg_anio]

    filtros.flatten!
    sql_text = sql.join("\n UNION \n")
    sql_text += "ORDER BY 1, 4,6,5 \n"
    
    cq = CustomQuery.buscar (
    {
        sql: sql_text,
        values: filtros
    })
    return cq

  end # end mensual_de_prestaciones_brindadas_por_grupo


end # end class


