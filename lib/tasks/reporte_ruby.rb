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
      [['Veinte a Sesenta y cuatro', 5],[arg_nomenclador, arg_anio]]
    

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

  def self.cuatrimestral_priorizados
    resp = []
    filtro_prest = []
    sql = []

    # array dimensiones: 
    # 1: Array [Nombre del grupo, numero de grupo]
    # 2: Array 
    #         A - Array [ids de prestaciones, .. ]
    #         B - Array [ids de diagnosticos para esas prestaciones, .. ]
    # prestaciones_paquete_basico_diagnostico = [
    #   [['Embarazadas', 1],[ [258], [45]] ], #CTC005W78
    #   [['Embarazadas', 1], [259], [45]]  #CTC006W78
    # ]
    grupos_y_prestaciones = [
      [
        ['Embarazadas', 1], 
        [
            [[258], [45]],
            [[559], [45]],
            [[322], [96, 97, 98, 99, 100, 101, 102, 103, 104, 105]],
            [[296], [10]],
            [[401], [79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95]],
            [[323], [66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78]],
            [[267], [45]]
        ]
      ],
      [ 
        ['Cero a Cinco', 2],
        [
          [[455], [9]],
          [[456], [9]],
          # CTC002 R78  -> Nuevo nomenclador
          # CTC001 R87  -> Nuevo nomenclador
          [[457], [9]],
          [[467], [10]],
          [[487], [16]]
        ]
      ],
      [ 
        ['Seis a Nueve', 3],
        [
          [[493], [9]],
          [[494], [9]],
          [[495], [9]],
          [[496], [9]],
          [[509], [30]],
          [[510], [30]],
          [[518], [33]],
          [[519], [33]],
          [[507], [13]],
          [[508], [13]],
          [[484], [16]],
          [[497], [10]],
          [[498], [9]]
        ]
      ],
      [ 
        ['Diez a Diecinueve', 4],
        [
          [[523], [9]],
          [[521], [9]],
          [[525], [9]],
          [[554], [31, 32]],
          [[555], [31, 32]],
          [[556], [33]],
          [[557], [33]],
          [[541], [30]],
          [[542], [30]],
          [[538], [13]],
          [[539], [13]],
          [[551], [22, 23, 24]],
          [[552], [22, 23, 24]],
          [[553], [25]],
          [[532], [10]],
          [[534], [10]],
          [[533], [10]],
          [[524], [9]],
          [[537], [9, 31, 32, 33, 45, 46, 48, 50, 51]],
          [[535], [10]],
          [[536], [10]],
          [[592], [10]],
          [[531], [10]],
          [[593], [10]]
        ]
      ],
      [ 
        ['Veinte a Sesenta y cuatro', 5],
        [
          [[590], [9]],
          [[561], [9]],
          [[562], [9]],
          [[583], [10]],
          [[587], [10, 57, 61]],
          [[582], [10]],
          [[580], [57, 61]],
          [[586], [10, 57, 6]]
        ]
      ],
      [
        ['Comunitarias', -1],
        [
          [[596], [10]],
          [[595], [10]],
          [[594], [10]],
          [[597], [10]],
          [[600], [10]],
          [[599], [10]],
          [[601], [10]],
          [[602], [10]],
          [[598], [10]],
          [[603], [10]],
          [[604], [10]],
          [[605], [10]],
          [[606], [10]]
        ]
      ]
    ]
    
    grupos_y_prestaciones.each do |g| 
      grupo_nombre = g.first[0]
      grupo_numero = g.first[1]
      filtro_grupo_etario = ""

      case grupo_numero 
      when 1
        filtro_grupo_etario = "AND mp.grupo = '1' \n"
      when 2
        filtro_grupo_etario = "AND date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 0 and 5 --beneficiarios que tenian entre 0 y 5 al momento de la prestacion \n"
      when 3
        filtro_grupo_etario = "AND date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 6 and 9 --beneficiarios que tenian entre 6 y 9 al momento de la prestacion \n"
      when 4
        filtro_grupo_etario = "AND date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 10 and 19 --beneficiarios que tenian entre 10 y 19 al momento de la prestacion \n"  
      when 5 
        filtro_grupo_etario = "AND date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 20 and 64 --beneficiarios que tenian entre 10 y 19 al momento de la prestacion \n"  
      else 
        filtro_grupo_etario = ""
      end
      
      g.last.each do |pd|
        pd[0].each do |p|  #prestacion
          pd[1].each do |d|  #diagnostico
            cod_prestacion = p
            cod_diagnostico = d
              filtro_prest << "( pi.prestacion_id = #{cod_prestacion} and p.diagnostico_id = #{cod_diagnostico} )"
          end # end diagnostico
        end # end prestaciones

      end # end pd
      sql << <<-SQL
        select e.nombre "Efector", '#{grupo_nombre}' "Grupo", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación", d.codigo "Diagnóstico",
          peri.periodo, count(p.*) "Cant.", round(sum(p.monto),2) "Total"
        from prestaciones_incluidas pi
         INNER JOIN prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id
         LEFT  JOIN afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario
         INNER JOIN diagnosticos d on d.id = p.diagnostico_id
         INNER JOIN vista_migra_pss mp on mp.id_subrrogada_foranea = pi.prestacion_id
         INNER JOIN efectores e on e.id = p.efector_id
         INNER JOIN liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id
         INNER JOIN liquidaciones_sumar_cuasifacturas cuasi on cuasi.id = det.liquidaciones_sumar_cuasifacturas_id
         INNER JOIN liquidaciones_sumar liq on liq.id = cuasi.liquidacion_sumar_id
         INNER JOIN periodos peri on peri.id = liq.periodo_id
        where pi.nomenclador_id = 
          ( select id from nomencladores 
            where activo = 't' 
            and nomenclador_sumar = 't' 
            and (p.fecha_de_la_prestacion BETWEEN fecha_de_inicio and fecha_de_finalizacion
            or  
            (p.fecha_de_la_prestacion >= fecha_de_inicio and fecha_de_finalizacion is null) )
            limit 1
         )
        AND ( 
              #{filtro_prest.join(" OR\n")} 
            )
        #{ filtro_grupo_etario }
        AND e.id in (11, 306, 24, 12, 274, 37, 300, 299, 290,  54, 199,  62, 
                      1,  32, 33, 34,  57, 58, 105, 127,  45, 377, 397, 396, 
                    263,  27, 36, 98,   5, 42, 285, 361, 294,  73, 338,  53, 
                    197, 369, 166, 110, 77, 146)
        GROUP BY e.nombre, pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, peri.periodo
        
      SQL
      filtro_prest.clear
    end # end grupo y numero

    sql_text = sql.join("\n UNION \n")
    

    cq = CustomQuery.buscar (
    {
        sql: sql_text
    })
   
    return cq
  end # end 

end # end class


