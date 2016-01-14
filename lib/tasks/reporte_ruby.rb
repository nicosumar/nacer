# -*- encoding : utf-8 -*-
class ReporteRuby
  
  def self.mensual_de_prestaciones_brindadas_por_grupo(arg_anio)
    
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
    # grupos_y_filtros = [['Embarazadas', 1],[arg_nomenclador, arg_anio]],
    #   [['Cero a Cinco', 2],[arg_nomenclador, arg_anio]],
    #   [['Seis a Nueve', 3],[arg_nomenclador, arg_anio]],
    #   [['Diez a Diecinueve', 4],[arg_nomenclador, arg_anio]],
    #   [['Veinte a Sesenta y cuatro', 5],[arg_nomenclador, arg_anio]]
    

    # grupos_y_filtros.each do |g|
    #   sql <<  <<-SQL
    #     SELECT spdss.nombre "Grupo", 
    #            pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación", d.codigo "Diagnóstico", 
    #            e.nombre "Efector", e.cuie "CUIE",
    #            extract(month FROM p.fecha_de_la_prestacion ) "Mes de Prestación", extract(year FROM p.fecha_de_la_prestacion ) "Año de Prestación",
    #             count(*) "Cant.", round(sum(p.monto),2) "Total"
    #     FROM prestaciones_incluidas pi
    #       INNER JOIN prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id 
    #       INNER JOIN diagnosticos d on d.id = p.diagnostico_id 
    #       INNER JOIN prestaciones_prestaciones_pdss pppdss ON pppdss.prestacion_id = pi.prestacion_id 
    #       INNER JOIN prestaciones_pdss pdss ON pdss.id = pppdss.prestacion_pdss_id
    #       INNER JOIN grupos_pdss gpdss ON gpdss.id = pdss.grupo_pdss_id
    #       INNER JOIN secciones_pdss spdss ON spdss.id = gpdss.seccion_pdss_id
    #       INNER JOIN efectores e on e.id = p.efector_id 
    #       INNER JOIN liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id
    #     AND p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada 
    #     AND extract(year FROM p.fecha_de_la_prestacion ) = ?
    #     and NOT pi.prestacion_comunitaria
    #     GROUP BY spdss.nombre, pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, 
    #              e.nombre, e.cuie, 
    #              extract(month FROM p.fecha_de_la_prestacion ), extract(year FROM p.fecha_de_la_prestacion )



    #     select '#{g.first.first}' "Grupo", 
    #             pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación", d.codigo "Diagnóstico", 
    #             e.nombre "Efector", e.cuie "CUIE",
    #             extract(month from p.fecha_de_la_prestacion ) "Mes de Prestación", extract(year from p.fecha_de_la_prestacion ) "Año de Prestación",
    #             count(*) "Cant.", round(sum(p.monto),2) "Total"
    #      from prestaciones_incluidas pi
    #        join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id 
    #        join diagnosticos d on d.id = p.diagnostico_id 
    #        join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario 
    #        join efectores e on e.id = p.efector_id 
    #        join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id
    #      where pi.prestacion_id in ( select p.id 
    #                                from migra_prestaciones mp
    #                                  join prestaciones p on p.id = mp.id_subrrogada_foranea
    #                                where mp.grupo = #{g.first.last}        -- Solo prestaciones del grupo que corresponda
    #                                and p.concepto_de_facturacion_id = 1)   -- Solo prestaciones del paquete basico 
    #      and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada 
    #      and pi.nomenclador_id = ?

    #      and extract(year from p.fecha_de_la_prestacion ) = ? 
    #      GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, 
    #               e.nombre, e.cuie, 
    #               extract(month from p.fecha_de_la_prestacion ), extract(year from p.fecha_de_la_prestacion )
    #   SQL
    #   filtros << g.last
    # end

    # sql <<  <<-SQL
    #   select 'Comunitaria' "Grupo", 
    #           pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación", d.codigo "Diagnóstico", 
    #           e.nombre "Efector", e.cuie "CUIE",
    #           extract(month from p.fecha_de_la_prestacion ) "Mes de Prestación", extract(year from p.fecha_de_la_prestacion ) "Año de Prestación",
    #           count(*) "Cant.", round(sum(p.monto),2) "Total"
    #    from prestaciones_incluidas pi
    #      join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id 
    #      join diagnosticos d on d.id = p.diagnostico_id 
    #      join efectores e on e.id = p.efector_id 
    #      join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id
    #    where p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada 
    #    and pi.prestacion_comunitaria                           -- solo prestaciones comunitarias
    #    and pi.nomenclador_id = ?
    #    and extract(year from p.fecha_de_la_prestacion ) = ? 
    #    GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, 
    #             e.nombre, e.cuie, 
    #             extract(month from p.fecha_de_la_prestacion ), extract(year from p.fecha_de_la_prestacion )
    # SQL
    # filtros << [arg_nomenclador, arg_anio]

    # filtros.flatten!
    # sql_text = sql.join("\n UNION \n")
    # sql_text += "ORDER BY 1, 4,6,5 \n"
    
    # cq = CustomQuery.buscar (
    # {
    #     sql: sql_text,
    #     values: filtros
    # })
    # return cq

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
          [['CTC005'], ['W78']],
          [['CTC006'], ['W78' ]],
          [['NTN004'], ['Z35.0', 'Z35.1', 'Z35.2', 'Z35.3', 'Z35.4', 'Z35.5', 'Z35.6', 'Z35.7', 'Z35.8', 'Z35.9']],
          [['CAW001'], ['A98']]
        ]
      ],
      [ 
        ['Niños de Cero a Cinco años', 2],
        [
          [['CTC001'], ['A97']],
          [['CTC001'], ['R78']],
          [['CTC002'], ['R78']],
          [['CTC010'], ['A97']],
          [['CAW003'], ['A98']],
          [['PRP026'], ['D60']]
        ]
      ],
      [ 
        ['Niños de seis a nueve años', 3],
        [
          [['CTC001'], ['A97']],
          [['CTC009'], ['A97']],
          [['CTC010'], ['A97']],
          [['CTC011'], ['A97']],
          [['CTC001'], ['R96']],
          [['CTC002'], ['R96']],
          [['CTC001'], ['T83']],
          [['CTC002'], ['T83']],
          [['CTC001'], ['B80']],
          [['CTC002'], ['B80']],
          [['PRP026'], ['D60']],
          [['CAW003'], ['A98']],
          [['CAW006'], ['A97']]
        ]
      ],
      [ 
        ['Adolecentes Diez a Diecinueve años', 4],
        [
          [['CTC001'], ['A97']],
          [['CTC008'], ['A97']],
          [['CTC011'], ['A97']],
          [['CTC001'], ['T79', 'T82']],
          [['CTC002'], ['T79', 'T82']],
          [['CTC001'], ['T83']],
          [['CTC002'], ['T83']],
          [['CTC001'], ['R96']],
          [['CTC002'], ['R96']],
          [['CTC001'], ['B80']],
          [['CTC002'], ['B80']],
          [['CTC001'], ['P20', 'P23', 'P24']],
          [['CTC002'], ['P20', 'P23', 'P24']],
          [['CTC001'], ['P98']],
          [['COT018'], ['A98']],
          [['COT015'], ['A98']],
          [['COT016'], ['A98']],
          [['CAW006'], ['A97', 'A75', 'B72', 'B73', 'B80', 'B78', 'B81', 'B82', 'D96', 'D61', 'D62', 'D72', 'B90', 'K73', 'K96', 'K83', 'K86', 'T79', 'T82', 'T83', 'T89', 'T90', 'Y70']],
          [['IMV014'], ['A98' ]]
        ]
      ],
      [ 
        ['Mujeres de veinte a sesenta y cuatro', 5],
        [
          [['CTC001'], ['A97']],
          [['CTC009'], ['A97']],
          [['CTC008'], ['A97']],
          [['PRP018'], ['A98']],
          [['PRP003'], ['W12']]
        ]
      ],
      [
        ['Comunitarias', -1],
        [
          [['CAW005'], ['A98']],
          [['CAW004'], ['A98']],
          [['ROX001'], ['A98']],
          [['ROX002'], ['A98']],
          [['TAT001'], ['A98']],
          [['TAT007'], ['A98']],
          [['TAT008'], ['A98']],
          [['TAT013'], ['A98']],
          [['TAT014'], ['A98']]
        ]
      ]
    ]
    
    grupos_y_prestaciones.each do |g| 
      grupo_nombre = g.first[0]
      grupo_numero = g.first[1]
      filtro_grupo_etario = ""

      
      g.last.each do |pd|
        pd[0].each do |p|  #prestacion
          pd[1].each do |d|  #diagnostico
            cod_prestacion = p
            cod_diagnostico = d
              filtro_prest << "( p.codigo = '#{cod_prestacion}' and d.codigo = '#{cod_diagnostico}' )"
          end # end diagnostico
        end # end prestaciones
      end # end pd
      
      unless grupo_numero == -1
        sql << <<-SQL
          SELECT e.nombre "Efector", spdss.nombre "Sección", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación", d.codigo "Diagnóstico",
            peri.periodo, count(pdss.*) "Cant.", round(sum(pl.monto),2) "Total"
          FROM prestaciones_incluidas pi 
            INNER JOIN  prestaciones_liquidadas pl ON pl.prestacion_incluida_id = pi.id 
            INNER JOIN  efectores e ON e.id = pl.efector_id
            INNER JOIN  liquidaciones_sumar_cuasifacturas_detalles det ON det.prestacion_liquidada_id = pl.id
            INNER JOIN  liquidaciones_sumar_cuasifacturas cuasi ON cuasi.id = det.liquidaciones_sumar_cuasifacturas_id
            INNER JOIN  liquidaciones_sumar liq ON liq.id = cuasi.liquidacion_sumar_id
            INNER JOIN  periodos peri ON peri.id = liq.periodo_id
            INNER JOIN  prestaciones p ON p.id = pi.prestacion_id
            INNER JOIN  prestaciones_prestaciones_pdss pppdss ON pppdss.prestacion_id = p.id 
            INNER JOIN  prestaciones_pdss pdss ON pdss.id = pppdss.prestacion_pdss_id
            INNER JOIN  grupos_pdss gpdss ON gpdss.id = pdss.grupo_pdss_id
            INNER JOIN  secciones_pdss spdss ON spdss.id = gpdss.seccion_pdss_id
            INNER JOIN  diagnosticos_prestaciones dp ON dp.prestacion_id = p.id
            INNER JOIN  diagnosticos d ON d.id = dp.diagnostico_id and d.id = pl.diagnostico_id
          WHERE (  
            #{filtro_prest.join(" OR\n")}  
            )
          AND spdss.id = #{grupo_numero}
          AND e.id in (11, 306, 24, 12, 274, 37, 300, 299, 290,  54, 199,  62, 
                        1,  32, 33, 34,  57, 58, 105, 127,  45, 377, 397, 396, 
                      263,  27, 36, 98,   5, 42, 285, 361, 294,  73, 338,  53, 
                      197, 369, 166, 110, 77, 146, 149, 210)
          GROUP BY e.nombre ,spdss.nombre, pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, peri.periodo
        SQL
        
      else
        sql << <<-SQL
          SELECT e.nombre "Efector", '#{grupo_nombre}' "Sección", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación", d.codigo "Diagnóstico",
                 peri.periodo, count(p.*) "Cant.", round(sum(pl.monto),2) "Total"
          FROM prestaciones_incluidas pi 
            INNER JOIN  prestaciones_liquidadas pl ON pl.prestacion_incluida_id = pi.id 
            INNER JOIN  efectores e ON e.id = pl.efector_id
            INNER JOIN  liquidaciones_sumar_cuasifacturas_detalles det ON det.prestacion_liquidada_id = pl.id
            INNER JOIN  liquidaciones_sumar_cuasifacturas cuasi ON cuasi.id = det.liquidaciones_sumar_cuasifacturas_id
            INNER JOIN  liquidaciones_sumar liq ON liq.id = cuasi.liquidacion_sumar_id
            INNER JOIN  periodos peri ON peri.id = liq.periodo_id
            INNER JOIN  prestaciones p ON p.id = pi.prestacion_id
            INNER JOIN  prestaciones_prestaciones_pdss pppdss ON pppdss.prestacion_id = p.id 
            INNER JOIN  diagnosticos_prestaciones dp ON dp.prestacion_id = p.id
            INNER JOIN  diagnosticos d ON d.id = dp.diagnostico_id and d.id = pl.diagnostico_id
          WHERE (  
            #{filtro_prest.join(" OR\n")}  
            )
          AND e.id in (11, 306, 24, 12, 274, 37, 300, 299, 290,  54, 199,  62, 
                        1,  32, 33, 34,  57, 58, 105, 127,  45, 377, 397, 396, 
                      263,  27, 36, 98,   5, 42, 285, 361, 294,  73, 338,  53, 
                      197, 369, 166, 110, 77, 146, 149, 210)
          GROUP BY e.nombre , pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, peri.periodo
        SQL
      
      end
        
      filtro_prest.clear
    end # end grupo y numero


    sql_text = sql.join("\n UNION \n")
    puts sql_text

    cq = CustomQuery.buscar (
    {
        sql: sql_text
    })
   
    return cq
  end # end 

  def self.bimestral(arg_grupo, arg_bimestre, arg_nomenclador, arg_anio)
    
    if arg_bimestre.to_i < 1 and arg_bimestre > 6
      return []
    end

    case arg_grupo
    when 1 then return self.grupo_embarazadas(arg_bimestre, arg_nomenclador, arg_anio)
    when 2 then return self.grupo_0_a_6(arg_bimestre, arg_nomenclador, arg_anio)
    when 3 then return self.grupo_6_a_9(arg_bimestre, arg_nomenclador, arg_anio)
    when 4 then return self.grupo_10_a_19(arg_bimestre, arg_nomenclador, arg_anio)
    when 5 then return self.mujeres_20_a_64(arg_bimestre, arg_nomenclador, arg_anio)
    else return []
    end

  end
  
  def self.grupo_embarazadas(arg_bimestre, arg_nomenclador, arg_anio)

    meses = case arg_bimestre
      when 1 then [1,2].join(", ")
      when 2 then [3,4].join(", ")
      when 3 then [5,6].join(", ")
      when 4 then [7,8].join(", ")
      when 5 then [9,10].join(", ")
      when 6 then [11, 12].join(", ")
      else return false
    end
    sql = ""
    sql_resto = ""
    resp = []
    filtro_prest = []
    
    # array con la primer dimension el id de la prestacion, la segunda un array de diagnosticos
    prestaciones_paquete_basico_diagnostico = [
      [["CTC005"],["W78"]], #CTC005W78
      [["CTC006"],["W78"]], #CTC006W78
      [["CTC010"],["W78"]], #CTC010W78
      [["TAT001"],["A98"]], #TAT001A98
      [["ITQ001"],["W90"]], #ITQ001W90
      [["ITQ001"],["W91"]], #ITQ001W91
      [["ITQ002"],["W88"]], #ITQ002W88
      [["ITQ002"],["W89"]], #ITQ002W89
      [["ITQ005"],["W06"]], #ITQ005W06
      [["ITQ006"],["W07"]], #ITQ006W07
      [["ITQ007"],["W08"]], #ITQ007W08
      [["NTN006"],["O10.0", "O10.4", "O11", "O14", "O15", "O16", 
                   "O24.4", "P05", "O47", "O72", "O72.1", "O72.2", 
                   "O98.4", "Q39.0", "Q39.1", "Q39.2", "Q79.3", "Q41", 
                   "Q42", "Q43.3", "Q43.4", "Q42.0", "Q42.1", "Q42.2", 
                   "Q42.3", "Q03", "Q05", "Q43.1"]] #NTN006 - todos los diagnosticos
    ]

    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            filtro_prest << "( pi.prestacion_codigo = '#{cod_prestacion}' and d.codigo = '#{cod_diagnostico}' )"
        end # end diagnostico
      end # end prestaciones
    end # end resultado 

    sql_b = <<-SQL 
      FROM prestaciones_incluidas pi
        INNER JOIN prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id 
        INNER JOIN  prestaciones_prestaciones_pdss pppdss ON pppdss.prestacion_id = pi.prestacion_id 
        INNER JOIN  prestaciones_pdss pdss ON pdss.id = pppdss.prestacion_pdss_id
        INNER JOIN  grupos_pdss gpdss ON gpdss.id = pdss.grupo_pdss_id
        INNER JOIN  secciones_pdss spdss ON spdss.id = gpdss.seccion_pdss_id
        INNER JOIN diagnosticos d on d.id = p.diagnostico_id 
        INNER JOIN efectores e on e.id = p.efector_id 
        INNER JOIN liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id  
        INNER JOIN nomencladores n on n.id = pi.nomenclador_id 
      WHERE p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada 
      AND ( 
            (p.fecha_de_la_prestacion >= n.fecha_de_inicio AND n.fecha_de_finalizacion IS NULL) OR 
            (p.fecha_de_la_prestacion >= n.fecha_de_inicio AND p.fecha_de_la_prestacion < n.fecha_de_finalizacion )   
          )
      AND extract(month from p.fecha_de_la_prestacion )  in (#{meses} )
      AND extract(year from p.fecha_de_la_prestacion ) = ? 
      AND spdss.id = 1
    SQL

    sql = <<-SQL
      SELECT 'Embarazadas' "Grupo", 'Priorizadas' "Tipo", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación",
             d.codigo "Diagnóstico", count(*) "Cant.", round(sum(p.monto),2) "Total"
      #{sql_b}
      AND ( #{filtro_prest.join(" OR ")} )
      GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo 

      UNION

      SELECT 'Embarazadas' "Grupo", 'Resto' "Tipo", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación",
             d.codigo "Diagnóstico", count(*) "Cant.", round(sum(p.monto),2) "Total"
      #{sql_b}
      AND NOT( #{filtro_prest.join(" OR ")} )
      GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo 
    SQL


    cq = CustomQuery.buscar (
    {
      sql: sql,
      values: [arg_anio, arg_anio]
    })

    return cq

  end # end metodo

  def self.grupo_0_a_6(arg_bimestre, arg_nomenclador, arg_anio)

    meses = case arg_bimestre
      when 1 then [1,2].join(", ")
      when 2 then [3,4].join(", ")
      when 3 then [5,6].join(", ")
      when 4 then [7,8].join(", ")
      when 5 then [9,10].join(", ")
      when 6 then [11, 12].join(", ")
      else return false
    end
    sql = ""
    sql_resto = ""
    resp = []
    filtro_prest = []

    prestaciones_paquete_basico_diagnostico = [
      [["CTC001"],["A97"]], #CTC001A97
      [["CTC001"],["A97"]]  #CTC001A97
    ]

    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            filtro_prest << "( pi.prestacion_codigo = '#{cod_prestacion}' and d.codigo = '#{cod_diagnostico}' )"
        end # end diagnostico
      end # end prestaciones
    end # end resultado 

    sql_b = <<-SQL 
      FROM prestaciones_incluidas pi
        INNER JOIN prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id 
        INNER JOIN  prestaciones_prestaciones_pdss pppdss ON pppdss.prestacion_id = pi.prestacion_id 
        INNER JOIN  prestaciones_pdss pdss ON pdss.id = pppdss.prestacion_pdss_id
        INNER JOIN  grupos_pdss gpdss ON gpdss.id = pdss.grupo_pdss_id
        INNER JOIN  secciones_pdss spdss ON spdss.id = gpdss.seccion_pdss_id
        INNER JOIN diagnosticos d on d.id = p.diagnostico_id 
        INNER JOIN efectores e on e.id = p.efector_id 
        INNER JOIN liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id  
        INNER JOIN nomencladores n on n.id = pi.nomenclador_id 
      WHERE p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada 
      AND ( 
            (p.fecha_de_la_prestacion >= n.fecha_de_inicio AND n.fecha_de_finalizacion IS NULL) OR 
            (p.fecha_de_la_prestacion >= n.fecha_de_inicio AND p.fecha_de_la_prestacion < n.fecha_de_finalizacion )   
          )
      AND extract(month from p.fecha_de_la_prestacion )  in (#{meses} )
      AND extract(year from p.fecha_de_la_prestacion ) = ? 
      AND spdss.id = 2
    SQL

    sql = <<-SQL
      SELECT 'Cero a Cinco' "Grupo", 'Priorizadas' "Tipo", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación",
             d.codigo "Diagnóstico", count(*) "Cant.", round(sum(p.monto),2) "Total"
      #{sql_b}
      AND ( #{filtro_prest.join(" OR ")} )
      GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo 

      UNION

      SELECT 'Cero a Cinco' "Grupo", 'Resto' "Tipo", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación",
             d.codigo "Diagnóstico", count(*) "Cant.", round(sum(p.monto),2) "Total"
      #{sql_b}
      AND NOT( #{filtro_prest.join(" OR ")} )
      GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo 
    SQL


    cq = CustomQuery.buscar (
    {
      sql: sql,
      values: [arg_anio, arg_anio]
    })
    return cq

  end # end metodo

  def self.grupo_6_a_9(arg_bimestre, arg_nomenclador, arg_anio)
    
    meses = case arg_bimestre
      when 1 then [1,2].join(", ")
      when 2 then [3,4].join(", ")
      when 3 then [5,6].join(", ")
      when 4 then [7,8].join(", ")
      when 5 then [9,10].join(", ")
      when 6 then [11, 12].join(", ")
      else return false
    end
    
    sql = ""
    sql_resto = ""
    resp = []
    filtro_prest = []
    
    prestaciones_paquete_basico_diagnostico = [
      [["CTC001"],["A97"]],  #CTC001A97
      [["IMV001"],["A98"]],  #IMV001A98
      [["CTC002"],["T83"]]   #CTC002T83
    ]

    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            filtro_prest << "( pi.prestacion_codigo = '#{cod_prestacion}' and d.codigo = '#{cod_diagnostico}' )"
        end # end diagnostico
      end # end prestaciones
    end # end resultado 

    sql_b = <<-SQL 
      FROM prestaciones_incluidas pi
        INNER JOIN prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id 
        INNER JOIN  prestaciones_prestaciones_pdss pppdss ON pppdss.prestacion_id = pi.prestacion_id 
        INNER JOIN  prestaciones_pdss pdss ON pdss.id = pppdss.prestacion_pdss_id
        INNER JOIN  grupos_pdss gpdss ON gpdss.id = pdss.grupo_pdss_id
        INNER JOIN  secciones_pdss spdss ON spdss.id = gpdss.seccion_pdss_id
        INNER JOIN diagnosticos d on d.id = p.diagnostico_id 
        INNER JOIN efectores e on e.id = p.efector_id 
        INNER JOIN liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id  
        INNER JOIN nomencladores n on n.id = pi.nomenclador_id 
      WHERE p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada 
      AND ( 
            (p.fecha_de_la_prestacion >= n.fecha_de_inicio AND n.fecha_de_finalizacion IS NULL) OR 
            (p.fecha_de_la_prestacion >= n.fecha_de_inicio AND p.fecha_de_la_prestacion < n.fecha_de_finalizacion )   
          )
      AND extract(month from p.fecha_de_la_prestacion )  in (#{meses} )
      AND extract(year from p.fecha_de_la_prestacion ) = ? 
      AND spdss.id = 3
    SQL

    sql = <<-SQL
      SELECT 'Seis a Nueve' "Grupo", 'Priorizadas' "Tipo", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación",
             d.codigo "Diagnóstico", count(*) "Cant.", round(sum(p.monto),2) "Total"
      #{sql_b}
      AND ( #{filtro_prest.join(" OR ")} )
      GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo 

      UNION

      SELECT 'Seis a Nueve' "Grupo", 'Resto' "Tipo", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación",
             d.codigo "Diagnóstico", count(*) "Cant.", round(sum(p.monto),2) "Total"
      #{sql_b}
      AND NOT( #{filtro_prest.join(" OR ")} )
      GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo 
    SQL

    cq = CustomQuery.buscar (
    {
      sql: sql,
      values: [arg_anio, arg_anio]
    })
    return cq

  end #end method

  def self.grupo_10_a_19(arg_bimestre, arg_nomenclador, arg_anio)
    
    meses = case arg_bimestre
      when 1 then [1,2].join(", ")
      when 2 then [3,4].join(", ")
      when 3 then [5,6].join(", ")
      when 4 then [7,8].join(", ")
      when 5 then [9,10].join(", ")
      when 6 then [11, 12].join(", ")
      else return false
    end
    
    sql = ""
    sql_resto = ""
    resp = []
    filtro_prest = []
    
    prestaciones_paquete_basico_diagnostico = [
      [["CTC001"],["A97"]], #CTC001A97
      [["IMV001"],["A98"]], #CTC001A97
      [["TAT010"],["A98"]], #TAT010A98
      [["TAT005"],["A98"]], #TAT005A98
      [["TAT007"],["A98"]], #TAT007A98
      [["TAT008"],["A98"]], #TAT008A98
      [["TAT009"],["A98"]], #TAT009A98
      [["TAT011"],["A98"]], #TAT011A98
      [["TAT012"],["A98"]], #TAT012A98
      [["TAT013"],["A98"]], #TAT013A98
      [["TAT014"],["A98"]]  #TAT014A98
    ]

    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            filtro_prest << "( pi.prestacion_codigo = '#{cod_prestacion}' and d.codigo = '#{cod_diagnostico}' )"
        end # end diagnostico
      end # end prestaciones
    end # end resultado 

    sql_b = <<-SQL 
      FROM prestaciones_incluidas pi
        INNER JOIN prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id 
        INNER JOIN  prestaciones_prestaciones_pdss pppdss ON pppdss.prestacion_id = pi.prestacion_id 
        INNER JOIN  prestaciones_pdss pdss ON pdss.id = pppdss.prestacion_pdss_id
        INNER JOIN  grupos_pdss gpdss ON gpdss.id = pdss.grupo_pdss_id
        INNER JOIN  secciones_pdss spdss ON spdss.id = gpdss.seccion_pdss_id
        INNER JOIN diagnosticos d on d.id = p.diagnostico_id 
        INNER JOIN efectores e on e.id = p.efector_id 
        INNER JOIN liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id  
        INNER JOIN nomencladores n on n.id = pi.nomenclador_id 
      WHERE p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada 
      AND ( 
            (p.fecha_de_la_prestacion >= n.fecha_de_inicio AND n.fecha_de_finalizacion IS NULL) OR 
            (p.fecha_de_la_prestacion >= n.fecha_de_inicio AND p.fecha_de_la_prestacion < n.fecha_de_finalizacion )   
          )
      AND extract(month from p.fecha_de_la_prestacion )  in (#{meses} )
      AND extract(year from p.fecha_de_la_prestacion ) = ? 
      AND spdss.id = 4
    SQL

    sql = <<-SQL
      SELECT 'Diez a Diecinueve' "Grupo", 'Priorizadas' "Tipo", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación",
             d.codigo "Diagnóstico", count(*) "Cant.", round(sum(p.monto),2) "Total"
      #{sql_b}
      AND ( #{filtro_prest.join(" OR ")} )
      GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo 

      UNION

      SELECT 'Diez a Diecinueve' "Grupo", 'Resto' "Tipo", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación",
             d.codigo "Diagnóstico", count(*) "Cant.", round(sum(p.monto),2) "Total"
      #{sql_b}
      AND NOT( #{filtro_prest.join(" OR ")} )
      GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo 
    SQL


    cq = CustomQuery.buscar (
    {
      sql: sql,
      values: [arg_anio, arg_anio]
    })
    return cq

  end #end method

  def self.mujeres_20_a_64(arg_bimestre, arg_nomenclador, arg_anio)
    
    meses = case arg_bimestre
      when 1 then [1,2].join(", ")
      when 2 then [3,4].join(", ")
      when 3 then [5,6].join(", ")
      when 4 then [7,8].join(", ")
      when 5 then [9,10].join(", ")
      when 6 then [11, 12].join(", ")
      else return false
    end
    
    sql = ""
    sql_resto = ""
    resp = []
    filtro_prest = []
    
    prestaciones_paquete_basico_diagnostico = [
      [["CTC001"],["A97"]],   #CTC001A97
      [["CTC008"],["A97"]],   #CTC008A97
      [["TAT007"],["A98"]],  #TAT007A98
      [["TAT013"],["A98"]],  #TAT013A98
      [["PRP018"],["A98"]],  #PRP018A98
      [["IGR014"],["A98"]],  #IGR014A98
      [["APA002"],["X76"]],  #APA002X76
      [["APA002"],["A98"]],  #APA002A98
      [["APA002"],["X75"]],  #APA002X75
      [["APA002"],["X80"]],  #APA002X80
      [["APA001"],["A98"]],  #APA001A98
      [["APA001"],["X86"]],  #APA001X86
      [["APA001"],["X75"]],  #APA001X75
      [["NTN002"],["X75"]]   #NTN002X75
    ]

    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            filtro_prest << "( pi.prestacion_codigo = '#{cod_prestacion}' and d.codigo = '#{cod_diagnostico}' )"
        end # end diagnostico
      end # end prestaciones
    end # end resultado 

    sql_b = <<-SQL 
      FROM prestaciones_incluidas pi
        INNER JOIN prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id 
        INNER JOIN  prestaciones_prestaciones_pdss pppdss ON pppdss.prestacion_id = pi.prestacion_id 
        INNER JOIN  prestaciones_pdss pdss ON pdss.id = pppdss.prestacion_pdss_id
        INNER JOIN  grupos_pdss gpdss ON gpdss.id = pdss.grupo_pdss_id
        INNER JOIN  secciones_pdss spdss ON spdss.id = gpdss.seccion_pdss_id
        INNER JOIN diagnosticos d on d.id = p.diagnostico_id 
        INNER JOIN efectores e on e.id = p.efector_id 
        INNER JOIN liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id  
        INNER JOIN nomencladores n on n.id = pi.nomenclador_id 
      WHERE p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada 
      AND ( 
            (p.fecha_de_la_prestacion >= n.fecha_de_inicio AND n.fecha_de_finalizacion IS NULL) OR 
            (p.fecha_de_la_prestacion >= n.fecha_de_inicio AND p.fecha_de_la_prestacion < n.fecha_de_finalizacion )   
          )
      AND extract(month from p.fecha_de_la_prestacion )  in (#{meses} )
      AND extract(year from p.fecha_de_la_prestacion ) = ? 
      AND spdss.id = 5
    SQL

    sql = <<-SQL
      SELECT 'Veinte a Sesenta y cuatro' "Grupo", 'Priorizadas' "Tipo", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación",
             d.codigo "Diagnóstico", count(*) "Cant.", round(sum(p.monto),2) "Total"
      #{sql_b}
      AND ( #{filtro_prest.join(" OR ")} )
      GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo 

      UNION

      SELECT 'Veinte a Sesenta y cuatro' "Grupo", 'Resto' "Tipo", pi.prestacion_codigo||'-'||pi.prestacion_nombre "Prestación",
             d.codigo "Diagnóstico", count(*) "Cant.", round(sum(p.monto),2) "Total"
      #{sql_b}
      AND NOT( #{filtro_prest.join(" OR ")} )
      GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo 
    SQL


    cq = CustomQuery.buscar (
    {
      sql: sql,
      values: [arg_anio, arg_anio]
    })
    return cq

  end

end # end class


