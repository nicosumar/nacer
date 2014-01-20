require 'spreadsheet'

class InformeBimestral
  attr_accessor :rutayarchivo
  attr_accessor :hoja
  attr_accessor :efector
  attr_accessor :convenio
  attr_accessor :book
  attr_accessor :sheet

  #def initialize(template_ruta_y_archivo)
  #  @rutayarchivo = args
  #end

  def self.prestaciones_priorizadas(ruta_y_archivo)
    
    self.
    efectores = PrestacionLiquidada.select("distinct (efector_id)").collect {|ef| ef.efector_id}

    res_emb = self.grupo_embarazadas(efectores, [8,9], 5)
     
  end

  def self.grupo_embarazadas(arg_efectores, arg_meses, arg_nomenclador)
    
    meses = arg_meses.join(", ")
    esquemas = UnidadDeAltaDeDatos.joins(:efectores).merge(Efector.where(id: arg_efectores))
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
            puts "Codigo de prestacion: #{cod_prestacion}"
            puts "Codigo de diagnostico: #{cod_diagnostico}"
            
            arr_sql << "select pi.prestacion_codigo, d.codigo diagnostico, count(*) cantidad_total, sum(p.monto) total \n"+
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

    arr_sql_resto <<  "select pi.prestacion_codigo, d.codigo diagnostico, count(*) cantidad_total, sum(p.monto) total\n"+
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
                #esquemas: esquemas,
                sql: arr_sql.join("\n UNION \n") #,
                #values: [cod_prestacion,cod_diagnostico ]
              })

    cq.each do |n|
      puts "prestacion: #{n.prestacion_codigo} - diag: #{n.diagnostico} - Cant: #{n.cantidad_total} - Total: #{n.total}"
    end

    puts "----------------------------------------------------------------------------------------------------------------"
    puts "                                              RESTO                                                             "
    puts "----------------------------------------------------------------------------------------------------------------"

    cq = CustomQuery.buscar (
              {
                #esquemas: esquemas,
                sql: arr_sql_resto
              })

    cq.each do |n|
      puts "prestacion: #{n.prestacion_codigo} - diag: #{n.diagnostico} - Cant: #{n.cantidad_total} - Total: #{n.total}"
    end

  end # end metodo

  def self.grupo_0_a_5(arg_efectores, arg_meses, arg_nomenclador)
    
    meses = arg_meses.join(", ")
    arr_cq = []
    prestaciones_paquete_basico_diagnostico = [
      [[455],[9]], # CTC001A97
      [[456],[9]]  # CTC001A97
    ]
    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            puts "Codigo de prestacion: #{cod_prestacion}"
            puts "Codigo de diagnostico: #{cod_diagnostico}"
            
            sql = "select pi.prestacion_codigo, d.codigo, count(*)\n"+
                  "from prestaciones_incluidas pi \n"+
                  " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
                  " join diagnosticos d on d.id = p.diagnostico_id \n"+
                  " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario\n"+
                  " join efectores e on e.id = p.efector_id --and e.area_de_prestacion_id = ap.area_de_prestacion_id \n"+
                  "  join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
                  "where pi.nomenclador_id = #{arg_nomenclador}\n"+
                  "and  date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 0 and 5 --beneficiarios que tenian entre 0 y 5 al momento de la prestacion \n"+
                  "and pi.prestacion_id = ?\n"+
                  "and p.diagnostico_id = ? \n"+
                  "and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
                  "and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
                  "GROUP BY pi.prestacion_codigo, d.codigo"
            cq = CustomQuery.buscar (
              {
                sql: sql,
                values: [cod_prestacion,cod_diagnostico ]
              })
            arr_cq << cq
           
        end # end diagnostico
      end # end prestaciones
    end # end resultado 
  end # end metodo

  def self.grupo_6_a_9(arg_efectores, arg_meses, arg_nomenclador)
    
    meses = arg_meses.join(", ")
    arr_cq = []
    
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
            puts "Codigo de prestacion: #{cod_prestacion}"
            puts "Codigo de diagnostico: #{cod_diagnostico}"
            
            sql = "select pi.prestacion_codigo, d.codigo, count(*)\n"+
                  "from prestaciones_incluidas pi \n"+
                  " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
                  " join diagnosticos d on d.id = p.diagnostico_id \n"+
                  " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario\n"+
                  " join efectores e on e.id = p.efector_id --and e.area_de_prestacion_id = ap.area_de_prestacion_id \n"+
                  "  join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
                  "where pi.nomenclador_id = #{arg_nomenclador}\n"+
                  "and  date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 6 and 9 --beneficiarios que tenian entre 6 y 9 al momento de la prestacion \n"+
                  "and pi.prestacion_id = ?\n"+
                  "and p.diagnostico_id = ? \n"+
                  "and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
                  "and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
                  "GROUP BY pi.prestacion_codigo, d.codigo"
            cq = CustomQuery.buscar (
              {
                sql: sql,
                values: [cod_prestacion,cod_diagnostico ]
              })
            arr_cq << cq
           
        end # end diagnostico
      end # end prestaciones
    end # end resultado 
  end

  def self.grupo_10_a_19

    meses = arg_meses.join(", ")
    arr_cq = []
    
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
            puts "Codigo de prestacion: #{cod_prestacion}"
            puts "Codigo de diagnostico: #{cod_diagnostico}"
            
            sql = "select pi.prestacion_codigo, d.codigo, count(*)\n"+
                  "from prestaciones_incluidas pi \n"+
                  " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
                  " join diagnosticos d on d.id = p.diagnostico_id \n"+
                  " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario\n"+
                  " join efectores e on e.id = p.efector_id --and e.area_de_prestacion_id = ap.area_de_prestacion_id \n"+
                  "  join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
                  "where pi.nomenclador_id = #{arg_nomenclador}\n"+
                  "and  date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 10 and 19 --beneficiarios que tenian entre 10 y 19 al momento de la prestacion \n"+
                  "and pi.prestacion_id = ?\n"+
                  "and p.diagnostico_id = ? \n"+
                  "and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
                  "and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
                  "GROUP BY pi.prestacion_codigo, d.codigo"
            cq = CustomQuery.buscar (
              {
                sql: sql,
                values: [cod_prestacion,cod_diagnostico ]
              })
            arr_cq << cq
           
        end # end diagnostico
      end # end prestaciones
    end # end resultado 
  end

  def self.mujeres_20_a_64
    meses = arg_meses.join(", ")
    arr_cq = []
    
    prestaciones_paquete_basico_diagnostico = [
      [[560][9]],  # CTC001A97
      [[523][9]],  # CTC008A97
      [[599][10]],  # TAT007A98
      [[505][10]],  # TAT013A98
      [[582][10]],  # PRP018A98
      [[583][10]],  # IGR014A98
      [[585][58]],  # APA002X76
      [[586][10]],  # APA002A98
      [[586][57]],  # APA002X75
      [[586][60]],  # APA002X80
      [[587][10]],  # APA001A98
      [[587][61]],  # APA001X86
      [[587][57]],  # APA001X75
      [[590][57]] # NTN002X75
    ]

    prestaciones_paquete_basico_diagnostico.each do |r| 
      r[0].each do |p|  #prestacion
        r[1].each do |d|  #diagnostico
          cod_prestacion = p
          cod_diagnostico = d
            puts "Codigo de prestacion: #{cod_prestacion}"
            puts "Codigo de diagnostico: #{cod_diagnostico}"
            
            sql = "select pi.prestacion_codigo, d.codigo, count(*)\n"+
                  "from prestaciones_incluidas pi \n"+
                  " join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id\n"+
                  " join diagnosticos d on d.id = p.diagnostico_id \n"+
                  " join afiliados a on a.clave_de_beneficiario = p.clave_de_beneficiario\n"+
                  " join efectores e on e.id = p.efector_id --and e.area_de_prestacion_id = ap.area_de_prestacion_id \n"+
                  "  join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = p.id \n"+
                  "where pi.nomenclador_id = #{arg_nomenclador}\n"+
                  "and  date_part('year',age(p.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 20 and 64 --beneficiarios que tenian entre 10 y 19 al momento de la prestacion \n"+
                  "and pi.prestacion_id = ?\n"+
                  "and p.diagnostico_id = ? \n"+
                  "and p.estado_de_la_prestacion_liquidada_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
                  "and extract(month from p.fecha_de_la_prestacion )  in (#{meses})\n"+
                  "AND a.sexo_id = 1\n"+
                  "GROUP BY pi.prestacion_codigo, d.codigo"
            cq = CustomQuery.buscar (
              {
                sql: sql,
                values: [cod_prestacion,cod_diagnostico ]
              })
            arr_cq << cq
           
        end # end diagnostico
      end # end prestaciones
    end # end resultado 
  end

end # end class


