# -*- encoding : utf-8 -*-
class ReporteCuatrimestralPriorizado
  
  def self.cuatrimestral_priorizado_facturacion(arg_nomenclador)
    
    resp = []
    cq = self.grupo_embarazadas(1, arg_nomenclador)

    cq.each do |n|
      resp << n
    end

    cq = self.grupo_0_a_6(2, arg_nomenclador)
    cq.each do |n|
      resp << n
    end

    cq = self.grupo_6_a_9(3, arg_nomenclador)
    cq.each do |n|
      resp << n
    end

    cq = self.grupo_10_a_19(4, arg_nomenclador)
    cq.each do |n|
      resp << n
    end

    cq = self.mujeres_20_a_64(5, arg_nomenclador)
    
    cq.each do |n|
      resp << n
    end

    return resp

  end

  def self.grupo_embarazadas(arg_grupo, arg_nomenclador)

    sql = ""
    filtro_prest = []
    
    # array con la primer dimension el id de la prestacion, la segunda un array de diagnosticos
    prestaciones_paquete_basico_diagnostico = [
      [[258],[45]], #CTC005W78
      [[259],[45]]  #CTC006W78
    ]
    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            filtro_prest << "( pi.prestacion_id = #{cod_prestacion} and p.diagnostico_id = #{cod_diagnostico} )"
        end # end diagnostico
      end # end prestaciones
    end # end resultado 

    sql = "select e.nombre \"Efector\", 'Embarazadas' \"Grupo\", pi.prestacion_codigo||'-'||pi.prestacion_nombre \"Prestación\", d.codigo \"Diagnóstico\", \n"+
          " peri.periodo, count(p.*) \"Cant.\", round(sum(p.monto),2) \"Total\"\n"+
          "from prestaciones_incluidas pi \n"+
          " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
          " join diagnosticos d on d.id = p.diagnostico_id \n"+
          " join migra_prestaciones mp on mp.id_subrrogada_foranea = pi.prestacion_id \n"+
          " join efectores e on e.id = p.efector_id  \n"+
          " join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
          " join liquidaciones_sumar_cuasifacturas cuasi on cuasi.id = det.liquidaciones_sumar_cuasifacturas_id\n"+
          " join liquidaciones_sumar liq on liq.id = cuasi.liquidacion_sumar_id\n"+
          " join periodos peri on peri.id = liq.periodo_id \n"+
          "where pi.nomenclador_id = ?\n"+
          "AND (\n"+ filtro_prest.join(" OR\n")  +
          "    )\n"+
          "AND mp.grupo = ? \n"+
          "AND e.alto_impacto\n"+
          "GROUP BY e.nombre, pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, peri.periodo "
          "ORDER BY e.nombre, peri.periodo"


    cq = CustomQuery.buscar (
    {
        sql: sql,
        values: [arg_nomenclador, arg_grupo]
    })

    return cq

  end # end metodo

  def self.grupo_0_a_6(arg_grupo, arg_nomenclador)

    sql = ""
    filtro_prest = []

    prestaciones_paquete_basico_diagnostico = [
      [[455],[9]], # CTC001A97
      [[456],[9]]  # CTC001A97
    ]

    # armo el array con los filtros
    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            filtro_prest << "( pi.prestacion_id = #{cod_prestacion} and p.diagnostico_id = #{cod_diagnostico} )"
        end # end diagnostico
      end # end prestaciones
    end # end resultado 

    sql = "select e.nombre \"Efector\",'Cero a Cinco' \"Grupo\", pi.prestacion_codigo||'-'||pi.prestacion_nombre \"Prestación\", d.codigo \"Diagnóstico\", \n"+
          "peri.periodo, count(p.*) \"Cant.\", round(sum(p.monto),2) \"Total\"\n"+
          "from prestaciones_incluidas pi \n"+
          " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
          " join diagnosticos d on d.id = p.diagnostico_id \n"+
          " join migra_prestaciones mp on mp.id_subrrogada_foranea = pi.prestacion_id \n"+
          " join efectores e on e.id = p.efector_id  \n"+
          " join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
          " join liquidaciones_sumar_cuasifacturas cuasi on cuasi.id = det.liquidaciones_sumar_cuasifacturas_id\n"+
          " join liquidaciones_sumar liq on liq.id = cuasi.liquidacion_sumar_id\n"+
          " join periodos peri on peri.id = liq.periodo_id \n"+
          "where pi.nomenclador_id = ?\n"+
          "AND (\n"+ filtro_prest.join(" OR\n")  +
          "    )\n"+
          "AND mp.grupo = ? \n"+
          "AND e.alto_impacto\n"+
          "GROUP BY e.nombre, pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, peri.periodo\n"+
          "ORDER BY e.nombre, peri.periodo"

    cq = CustomQuery.buscar (
    {
        sql: sql,
        values: [arg_nomenclador, arg_grupo]
    })

    return cq

  end # end metodo

  def self.grupo_6_a_9(arg_grupo, arg_nomenclador)
    
    sql = ""
    filtro_prest = []
    
    prestaciones_paquete_basico_diagnostico = [
      [[493],[9]],  # CTC001A97
      [[494],[9]],  # CTC009A97
      [[495],[9]],  # CTC010A97
      [[496],[9]],  # CTC011A97
      [[509],[30]], # CTC001R96
      [[510],[30]], # CTC002R96
      [[502],[10]], # IMV001A98
      [[501],[10]], # IMV002A98
      [[499],[10]], # IMV008A98
      [[765],[10]], # IMV011A98
      [[518],[33]], # CTC001T83
      [[519],[33]] # CTC002T83
    ]

    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            filtro_prest << "( pi.prestacion_id = #{cod_prestacion} and p.diagnostico_id = #{cod_diagnostico} )"
        end # end diagnostico
      end # end prestaciones
    end # end resultado 

    sql = "select e.nombre \"Efector\",'Seis a Nueve' \"Grupo\", pi.prestacion_codigo||'-'||pi.prestacion_nombre \"Prestación\", d.codigo \"Diagnóstico\",\n"+ 
          "peri.periodo, count(p.*) \"Cant.\", round(sum(p.monto),2) \"Total\"\n"+
          "from prestaciones_incluidas pi \n"+
          " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
          " join diagnosticos d on d.id = p.diagnostico_id \n"+
          " join migra_prestaciones mp on mp.id_subrrogada_foranea = pi.prestacion_id \n"+
          " join efectores e on e.id = p.efector_id  \n"+
          " join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
          " join liquidaciones_sumar_cuasifacturas cuasi on cuasi.id = det.liquidaciones_sumar_cuasifacturas_id\n"+
          " join liquidaciones_sumar liq on liq.id = cuasi.liquidacion_sumar_id\n"+
          " join periodos peri on peri.id = liq.periodo_id \n"+
          "where pi.nomenclador_id = ?\n"+
          "AND (\n"+ filtro_prest.join(" OR\n")  +
          "    )\n"+
          "AND mp.grupo = ? \n"+
          "AND e.alto_impacto\n"+
          "GROUP BY e.nombre, pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, peri.periodo\n"+
          "ORDER BY e.nombre, peri.periodo"


    cq = CustomQuery.buscar (
    {
        sql: sql,
        values: [arg_nomenclador, arg_grupo]
    })

    return cq
  end

  def self.grupo_10_a_19(arg_grupo, arg_nomenclador)

    sql = ""
    filtro_prest = []
    
    prestaciones_paquete_basico_diagnostico = [
      [[521],[9]],          # CTC001A97
      [[524],[9]],          # CTC010A97
      [[525],[9]],          # CTC011A97
      [[554],[31, 32]],     # CTC001T79 y T82
      [[555],[31, 32]],     # CTC002T79 y T82
      [[556],[33]],         # CTC001T83
      [[557],[33]],         # CTC002T83
      [[541],[30]],         # CTC001R96
      [[542],[30]],         # CTC002R96
      [[538],[13]],         # CTC001B80
      [[539],[13]],         # CTC002B80
      [[551],[22,23,24]],   # CTC001P20, P23 y P24
      [[552],[22,23,24]],   # CTC002P20, P23 y P24
      [[553],[25]],         # CTC001P98
      [[532],[10]],         # COT018A98
      [[534],[10]],         # COT015A98
      [[533],[10]],         # COT016A98
      [[535],[10]],         # CAW005A98
      [[536],[10]],         # CAW004A98
      [[592],[10]],         # ROX001A98
      [[593],[10]],         # ROX002A98
      [[558],[39]]          # PRP003W12
    ]
    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            filtro_prest << "( pi.prestacion_id = #{cod_prestacion} and p.diagnostico_id = #{cod_diagnostico} )"
        end # end diagnostico
      end # end prestaciones
    end # end resultado 

    sql = "select e.nombre \"Efector\", 'Diez a Diecinueve' \"Grupo\", pi.prestacion_codigo||'-'||pi.prestacion_nombre \"Prestación\", d.codigo \"Diagnóstico\", \n"+ 
          "peri.periodo, count(p.*) \"Cant.\", round(sum(p.monto),2) \"Total\"\n"+
          "from prestaciones_incluidas pi \n"+
          " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
          " join diagnosticos d on d.id = p.diagnostico_id \n"+
          " join migra_prestaciones mp on mp.id_subrrogada_foranea = pi.prestacion_id \n"+
          " join efectores e on e.id = p.efector_id  \n"+
          " join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
          " join liquidaciones_sumar_cuasifacturas cuasi on cuasi.id = det.liquidaciones_sumar_cuasifacturas_id\n"+
          " join liquidaciones_sumar liq on liq.id = cuasi.liquidacion_sumar_id\n"+
          " join periodos peri on peri.id = liq.periodo_id \n"+
          "where pi.nomenclador_id = ?\n"+
          "AND (\n"+ filtro_prest.join(" OR\n")  +
          "    )\n"+
          "AND mp.grupo = ? \n"+
          "AND e.alto_impacto\n"+
          "GROUP BY e.nombre, pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, peri.periodo\n"+
          "ORDER BY e.nombre, peri.periodo"


    cq = CustomQuery.buscar (
    {
        sql: sql,
        values: [arg_nomenclador, arg_grupo]
    })

    return cq
  end

  def self.mujeres_20_a_64(arg_grupo, arg_nomenclador)
    
    sql = ""
    filtro_prest = []
    
    prestaciones_paquete_basico_diagnostico = [
      [[560],[9]],  # CTC001A97
      [[522],[9]],  # CTC009A97
      [[523],[9]],  # CTC008A97
      [[558],[39]]  # PRP003W12
    ]

    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            filtro_prest << "( pi.prestacion_id = #{cod_prestacion} and p.diagnostico_id = #{cod_diagnostico} )"
        end # end diagnostico
      end # end prestaciones
    end # end resultado 

    sql = "select e.nombre \"Efector\", 'Veinte a Sesenta y cuatro' \"Grupo\", pi.prestacion_codigo||'-'||pi.prestacion_nombre \"Prestación\", d.codigo \"Diagnóstico\", \n"+ 
          "peri.periodo, count(p.*) \"Cant.\", round(sum(p.monto),2) \"Total\"\n"+
          "from prestaciones_incluidas pi \n"+
          " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
          " join diagnosticos d on d.id = p.diagnostico_id \n"+
          " join migra_prestaciones mp on mp.id_subrrogada_foranea = pi.prestacion_id \n"+
          " join efectores e on e.id = p.efector_id  \n"+
          " join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
          " join liquidaciones_sumar_cuasifacturas cuasi on cuasi.id = det.liquidaciones_sumar_cuasifacturas_id\n"+
          " join liquidaciones_sumar liq on liq.id = cuasi.liquidacion_sumar_id\n"+
          " join periodos peri on peri.id = liq.periodo_id \n"+
          "where pi.nomenclador_id = ?\n"+
          "AND (\n"+ filtro_prest.join(" OR\n")  +
          "    )\n"+
          "AND mp.grupo = ? \n"+
          "AND e.alto_impacto\n"+
          "GROUP BY e.nombre, pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo, peri.periodo\n"+
          "ORDER BY e.nombre, peri.periodo"


    cq = CustomQuery.buscar (
    {
        sql: sql,
        values: [arg_nomenclador, arg_grupo]
    })

    return cq
  end


end # end class


