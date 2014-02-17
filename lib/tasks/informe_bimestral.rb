# -*- encoding : utf-8 -*-
require 'spreadsheet'
require 'csv'

class InformeBimestral
  attr_accessor :rutayarchivo
  attr_accessor :hoja
  attr_accessor :efector
  attr_accessor :convenio
  attr_accessor :book
  attr_accessor :sheet

  @@ruta_y_archivo = 'lib/tasks/datos/informes_bimestrales/2014-01/detalle_prestaciones_bimestrales.xls'
  #def initialize(template_ruta_y_archivo)
  #  @rutayarchivo = args
  #end

  def self.prestaciones_priorizadas(bimestre)
    efectores = PrestacionLiquidada.select("distinct (efector_id)").collect {|ef| ef.efector_id}
    res_emb = self.grupo_embarazadas(bimestre, 5)
  end

  def self.grupo_embarazadas(arg_bimestre, arg_nomenclador)

    meses = case arg_bimestre
      when 1 then [1,2].join(", ")
      when 2 then [3,4].join(", ")
      when 3 then [5,6].join(", ")
      when 4 then [7,8].join(", ")
      when 5 then [9,10].join(", ")
      when 6 then [11, 12].join(", ")
      else return false
    end
    
    arr_sql = []
    arr_sql_resto = ""
    
    # array con la primer dimension el id de la prestacion, la segunda un array de diagnosticos
    prestaciones_paquete_basico_diagnostico = [
      [[258],[45]], #CTC005W78
      [[259],[45]], #CTC006W78
      [[260],[45]], #CTC010W78
      [[596],[10]], #TAT001A98
      [[313],[50]], #ITQ001W90
      [[313],[51]], #ITQ001W91
      [[314],[48]], #ITQ002W88
      [[314],[49]], #ITQ002W89
      [[304],[36]], #ITQ005W06
      [[306],[37]], #ITQ006W07
      [[308],[38]], #ITQ007W08
      [[323],[73, 78, 77, 76, 75, 74, 72, 71, 70, 69, 68, 67, 66]] #NTN006 - todos los diagnosticos
    ]
    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            
            arr_sql << "select pi.prestacion_codigo, d.codigo diagnostico, count(*) cantidad_total, round(sum(p.monto),2) total \n"+
                  " from prestaciones_incluidas pi\n"+
                  " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id \n"+
                  " join diagnosticos d on d.id = p.diagnostico_id \n"+
                  " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario \n"+
                  " join periodos_de_embarazo pe on pe.afiliado_id = a.afiliado_id  \n"+
                  " join efectores e on e.id = p.efector_id \n"+
                  " join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id  \n"+
                  " where pi.nomenclador_id = #{arg_nomenclador} \n"+
                  " and pi.prestacion_id  = #{cod_prestacion} \n"+
                  " and p.diagnostico_id  = #{cod_diagnostico} \n"+
                  " and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada \n"+
                  " and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
                  "GROUP BY pi.prestacion_codigo, d.codigo "
        end # end diagnostico
      end # end prestaciones
    end # end resultado 

    arr_sql_resto <<  "select pi.prestacion_codigo, d.codigo diagnostico, count(*) cantidad_total, round(sum(p.monto),2) total\n"+
                      " from prestaciones_incluidas pi\n"+
                      " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id \n"+
                      " join diagnosticos d on d.id = p.diagnostico_id \n"+
                      " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario \n"+
                      " join periodos_de_embarazo pe on pe.afiliado_id = a.afiliado_id  \n"+
                      " join efectores e on e.id = p.efector_id \n"+
                      " join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id  \n"+
                      " where pi.nomenclador_id = #{arg_nomenclador} \n"+
                      " and pi.prestacion_id in ( select p.id \n"+
                      "                           from migra_prestaciones mp\n"+
                      "                             join prestaciones p on p.id = mp.id_subrrogada_foranea\n"+
                      "                           where mp.grupo = 1\n"+                      # Solo prestaciones del grupo 1, embarazadas
                      "                           and p.concepto_de_facturacion_id = 1)\n"+   # Solo prestaciones del paquete basico 
                      " and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada \n"+
                      " and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
                      "GROUP BY pi.prestacion_codigo, d.codigo \n"+
                      "EXCEPT"
    arr_sql_resto += "(" + arr_sql.join("\n UNION \n") + ")"

    cq = CustomQuery.buscar (
      {
        sql: arr_sql.join("\n UNION \n")
      }
    )

    resp = []
    cq.each do |n|
      resp << n
    end

    cq = CustomQuery.buscar (
    {
          sql: arr_sql_resto
    })

    cq.each do |n|
      resp << n
    end

    return resp

  end # end metodo

  def self.grupo_0_a_6(arg_bimestre, arg_nomenclador)

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

    sql = "select pi.prestacion_codigo||'-'||pi.prestacion_nombre prestacion_codigo, d.codigo diagnostico, count(*) cantidad_total, round(sum(p.monto),2) total\n"+
          "from prestaciones_incluidas pi \n"+
          " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
          " join diagnosticos d on d.id = p.diagnostico_id \n"+
          " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario\n"+
          " join efectores e on e.id = p.efector_id --and e.area_de_prestacion_id = ap.area_de_prestacion_id \n"+
          "  join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
          "where pi.nomenclador_id = #{arg_nomenclador}\n"+
          "and  date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 0 and 5 --beneficiarios que tenian entre 0 y 5 al momento de la prestacion \n"+
          "AND (\n"+ filtro_prest.join(" OR\n")  +
          "    )\n"+
          "and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
          "and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
          "GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo"

    sql_resto = "select pi.prestacion_codigo||'-'||pi.prestacion_nombre prestacion_codigo, d.codigo diagnostico, count(*) cantidad_total, round(sum(p.monto),2) total\n"+
                  "from prestaciones_incluidas pi \n"+
                  " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
                  " join diagnosticos d on d.id = p.diagnostico_id \n"+
                  " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario\n"+
                  " join efectores e on e.id = p.efector_id --and e.area_de_prestacion_id = ap.area_de_prestacion_id \n"+
                  "  join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
                  "where pi.nomenclador_id = #{arg_nomenclador}\n"+
                  "and  date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 0 and 5 --beneficiarios que tenian entre 0 y 5 al momento de la prestacion \n"+
                  "and pi.prestacion_id in ( select p.id \n"+
                  "                           from migra_prestaciones mp\n"+
                  "                             join prestaciones p on p.id = mp.id_subrrogada_foranea\n"+
                  "                           where mp.grupo = 2\n"+                      # Solo prestaciones del grupo 2, niños de 0 a 6
                  "                           and p.concepto_de_facturacion_id = 1)\n"+   # Solo prestaciones del paquete basico 
                  "AND NOT (\n"+ filtro_prest.join(" OR\n")  +
                  "        )\n"+
                  "and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
                  "and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
                  "GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo\n"

    cq = CustomQuery.buscar (
    {
        sql: sql
    })

    cq.each do |n|
      resp << c
    end

    cq = CustomQuery.buscar (
    {
        sql: sql_resto
    })
    
    cq.each do |n|
      resp << n
    end

    return resp

  end # end metodo

  def self.grupo_6_a_9(arg_bimestre, arg_nomenclador)
    
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
      [[493],[9]],  # CTC001A97
      [[502],[10]],  # IMV001A98
      [[557],[33]]   # CTC002T83
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

    sql = "select pi.prestacion_codigo||'-'||pi.prestacion_nombre prestacion_codigo, d.codigo diagnostico, count(*) cantidad_total, round(sum(p.monto),2) total\n"+
          "from prestaciones_incluidas pi \n"+
          " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
          " join diagnosticos d on d.id = p.diagnostico_id \n"+
          " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario\n"+
          " join efectores e on e.id = p.efector_id --and e.area_de_prestacion_id = ap.area_de_prestacion_id \n"+
          "  join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
          "where pi.nomenclador_id = #{arg_nomenclador}\n"+
          "and  date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 6 and 9 --beneficiarios que tenian entre 6 y 9 al momento de la prestacion \n"+
          "AND (\n"+ filtro_prest.join(" OR\n")  +
          "    )\n"+
          "and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
          "and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
          "GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo"

    sql_resto = "select pi.prestacion_codigo||'-'||pi.prestacion_nombre prestacion_codigo, d.codigo diagnostico, count(*) cantidad_total, round(sum(p.monto),2) total\n"+
                "from prestaciones_incluidas pi \n"+
                " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
                " join diagnosticos d on d.id = p.diagnostico_id \n"+
                " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario\n"+
                " join efectores e on e.id = p.efector_id --and e.area_de_prestacion_id = ap.area_de_prestacion_id \n"+
                "  join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
                "where pi.nomenclador_id = #{arg_nomenclador}\n"+
                "and  date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 6 and 9 --beneficiarios que tenian entre 6 y 9 al momento de la prestacion \n"+
                "and pi.prestacion_id in ( select p.id \n"+
                "                           from migra_prestaciones mp\n"+
                "                             join prestaciones p on p.id = mp.id_subrrogada_foranea\n"+
                "                           where mp.grupo = 3\n"+                      # Solo prestaciones del grupo 3, niños de 6 a 9
                "                           and p.concepto_de_facturacion_id = 1)\n"+   # Solo prestaciones del paquete basico 
                "AND NOT (\n"+ filtro_prest.join(" OR\n")  +
                "        )\n"+
                "and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
                "and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
                "GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo"


    cq = CustomQuery.buscar (
    {
        sql: sql
    })

    cq.each do |n|
      resp << n
    end

    cq = CustomQuery.buscar (
    {
        sql: sql_resto
    })

    cq.each do |n|
      resp << n
    end

    return resp
  end

  def self.grupo_10_a_19(arg_bimestre, arg_nomenclador)

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
      [[521],[9]], # CTC001A97
      [[598],[10]], # TAT010A98
      [[600],[10]], # TAT005A98
      [[599],[10]], # TAT007A98
      [[601],[10]], # TAT008A98
      [[602],[10]], # TAT009A98
      [[603],[10]], # TAT011A98
      [[604],[10]], # TAT012A98
      [[605],[10]], # TAT013A98
      [[606],[10]] # TAT014A98
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

    sql = "select pi.prestacion_codigo||'-'||pi.prestacion_nombre prestacion_codigo, d.codigo diagnostico, count(*) cantidad_total, round(sum(p.monto),2) total\n"+
          "from prestaciones_incluidas pi \n"+
          " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
          " join diagnosticos d on d.id = p.diagnostico_id \n"+
          " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario\n"+
          " join efectores e on e.id = p.efector_id --and e.area_de_prestacion_id = ap.area_de_prestacion_id \n"+
          "  join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
          "where pi.nomenclador_id = #{arg_nomenclador}\n"+
          "and  date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 10 and 19 --beneficiarios que tenian entre 10 y 19 al momento de la prestacion \n"+
          "AND (\n"+ filtro_prest.join(" OR\n")  +
          "    )\n"+
          "and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
          "and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
          "GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo"

    sql_resto = "select pi.prestacion_codigo||'-'||pi.prestacion_nombre prestacion_codigo, d.codigo diagnostico, count(*) cantidad_total, round(sum(p.monto),2) total\n"+
                "from prestaciones_incluidas pi \n"+
                " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
                " join diagnosticos d on d.id = p.diagnostico_id \n"+
                " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario\n"+
                " join efectores e on e.id = p.efector_id --and e.area_de_prestacion_id = ap.area_de_prestacion_id \n"+
                "  join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
                "where pi.nomenclador_id = #{arg_nomenclador}\n"+
                "and  date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 10 and 19 --beneficiarios que tenian entre 10 y 19 al momento de la prestacion \n"+
                "AND NOT (\n"+ filtro_prest.join(" OR\n")  +
                "        )\n"+
                "and pi.prestacion_id in ( select p.id \n"+
                "                           from migra_prestaciones mp\n"+
                "                             join prestaciones p on p.id = mp.id_subrrogada_foranea\n"+
                "                           where mp.grupo = 4\n"+                      # Solo prestaciones del grupo 4,  de 10 a 19
                "                           and p.concepto_de_facturacion_id = 1)\n"+   # Solo prestaciones del paquete basico 
                "and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
                "and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
                "GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo"

    cq = CustomQuery.buscar (
    {
        sql: sql
    })

    cq.each do |n|
      resp << n
    end

    cq = CustomQuery.buscar (
    {
        sql: sql_resto
    })

    cq.each do |n|
      resp << n
    end

    return resp
  end

  def self.mujeres_20_a_64(arg_bimestre, arg_nomenclador)
    
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
      [[560],[9]],  # CTC001A97
      [[523],[9]],  # CTC008A97
      [[599],[10]],  # TAT007A98
      [[505],[10]],  # TAT013A98
      [[582],[10]],  # PRP018A98
      [[583],[10]],  # IGR014A98
      [[585],[58]],  # APA002X76
      [[586],[10]],  # APA002A98
      [[586],[57]],  # APA002X75
      [[586],[60]],  # APA002X80
      [[587],[10]],  # APA001A98
      [[587],[61]],  # APA001X86
      [[587],[57]],  # APA001X75
      [[590],[57]]   # NTN002X75
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

    sql = "select pi.prestacion_codigo||'-'||pi.prestacion_nombre prestacion_codigo, d.codigo diagnostico, count(*) cantidad_total, round(sum(p.monto),2) total\n"+
          "from prestaciones_incluidas pi \n"+
          " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
          " join diagnosticos d on d.id = p.diagnostico_id \n"+
          " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario\n"+
          " join efectores e on e.id = p.efector_id --and e.area_de_prestacion_id = ap.area_de_prestacion_id \n"+
          "  join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
          "where pi.nomenclador_id = #{arg_nomenclador}\n"+
          "and  date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 20 and 64 --beneficiarios que tenian entre 10 y 19 al momento de la prestacion \n"+
          "AND (\n"+ filtro_prest.join(" OR\n")  +
          "    )\n"+
          "and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
          "and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
          "AND a.sexo_id = 1\n"+
          "GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo"

    sql_resto = "select pi.prestacion_codigo||'-'||pi.prestacion_nombre prestacion_codigo, d.codigo diagnostico, count(*) cantidad_total, round(sum(p.monto),2) total\n"+
                "from prestaciones_incluidas pi \n"+
                " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
                " join diagnosticos d on d.id = p.diagnostico_id \n"+
                " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario\n"+
                " join efectores e on e.id = p.efector_id --and e.area_de_prestacion_id = ap.area_de_prestacion_id \n"+
                "  join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
                "where pi.nomenclador_id = #{arg_nomenclador}\n"+
                "and  date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 20 and 64 --beneficiarios que tenian entre 10 y 19 al momento de la prestacion \n"+
                "AND NOT (\n"+ filtro_prest.join(" OR\n")  +
                "        )\n"+
                "and pi.prestacion_id in ( select p.id \n"+
                "                           from migra_prestaciones mp\n"+
                "                             join prestaciones p on p.id = mp.id_subrrogada_foranea\n"+
                "                           where mp.grupo = 5\n"+                      # Solo prestaciones del grupo 5,  de 20 a 64
                "                           and p.concepto_de_facturacion_id = 1)\n"+   # Solo prestaciones del paquete basico 
                "and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
                "and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
                "AND a.sexo_id = 1\n"+
                "GROUP BY pi.prestacion_codigo||'-'||pi.prestacion_nombre, d.codigo"

    cq = CustomQuery.buscar (
    {
        sql: sql
    })

    cq.each do |n|
      resp << n
    end

    cq = CustomQuery.buscar (
    {
        sql: sql_resto
    })

    cq.each do |n|
      resp << n
    end

    return resp

  end

  def self.migrar_nacer(ruta='', archivos=[])

    ruta = 'lib/tasks/datos/informes_bimestrales/2014-01/crudo-nacer' if ruta.blank?

    # archivos = Dir.glob("lib/tasks/datos/informes_bimestrales/2014-01/crudo-nacer/**/*") if archivos.blank?

    archivos = Dir.glob("#{ruta}/**/*").delete_if { |a| a.count('.') == 0 } if archivos.blank?
              

    ActiveRecord::Base.connection.schema_search_path = "public"
    
    archivos.each do |ra|
      # @rutayarchivo = ruta + ra

      @rutayarchivo = ra
      puts "archivo: #{@rutayarchivo}"
      ActiveRecord::Base.transaction do

        begin
          # Trato de abrirlo con spreedsheet
          book = Spreadsheet.open @rutayarchivo
          sheet = book.worksheet 0

          sheet.each 2 do |row|

            break if row[0].blank?
            
            # Busco el efector
            e = Efector.where("cuie = trim('#{row[0]}')")
            # Busco el beneficiario

            a = Afiliado.where("clave_de_beneficiario = trim('#{row[11]}')")
            # Busco la prestación
            p = Prestacion.where("codigo = trim('#{row[8]}')")

            efector_id = (e.size == 1 ? e.first.id : "NULL")
            afiliado_id = (a.size == 1 ? a.first.id : "NULL")
            prestacion_id = (p.size == 1 ? p.first.id : "NULL")

            ActiveRecord::Base.connection.execute "INSERT INTO  public . migra_prestaciones_liquidadas_nacer  \n"+
                  "( efector_id ,  prestacion_id ,  afiliado_id ,  monto ,  fecha_de_la_prestacion ) \n"+
                  "VALUES \n"+ 
                  "( #{efector_id}, #{prestacion_id}, #{afiliado_id}, #{row[9]}, date('#{row[3]}') );"
          end
          
        rescue Exception => e
          
          CSV.foreach(@rutayarchivo, :headers => false, :encoding => 'ISO-8859-1', :col_sep => "\t", :quote_char => "~") do |row|
            #row = fila[0].split(/\t/)
            
            break if row[0].blank?

            if row[0][0] == "M" # es un CUIE

              # Busco el efector
              e = Efector.where("cuie = trim('#{row[0]}')")
              # Busco el beneficiario

              a = Afiliado.where("clave_de_beneficiario = trim('#{row[11]}')")
              # puts "afiliado:#{row[11]}"
              # Busco la prestación
              p = Prestacion.where("codigo = trim('#{row[8]}')")

              efector_id = (e.size == 1 ? e.first.id : "NULL")
              afiliado_id = (a.size == 1 ? a.first.id : "NULL")
              prestacion_id = (p.size == 1 ? p.first.id : "NULL")

              ActiveRecord::Base.connection.execute "INSERT INTO  public . migra_prestaciones_liquidadas_nacer  \n"+
                    "( efector_id ,  prestacion_id ,  afiliado_id ,  monto ,  fecha_de_la_prestacion ) \n"+
                    "VALUES \n"+ 
                    "( #{efector_id}, #{prestacion_id}, #{afiliado_id}, #{row[9].gsub(',','.')}, date('#{row[3]}') );"
            end #end es un CUIE
          end #end itera CSV
        end #End rescue
      end
    end
  end

end # end class


