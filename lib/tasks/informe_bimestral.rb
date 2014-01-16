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

  def self.prestaciones_priorizadas
    
    efectores = PrestacionLiquidada.select("distinct (efector_id)").collect {|ef| ef.efector_id}
    esquemas = UnidadDeAltaDeDatos.joins(:efectores).merge(Efector.where(id: efectores))
    
    cod_embarazadas = ["CTC005W78", "CTC006W78", "CTC010W78","TAT001A98", "ITQ001W90", "ITQ001W91", "ITQ002W88", "ITQ002W89", "ITQ005W06", "ITQ006W07", "ITQ007W08", "NTN006", "ITE007O10.0", "ITE007O10.4", "ITE007O11", "ITE007O14", "ITE007O15", "ITE008P05", "ITE008O47", "ITQ004O72.1", "ITQ004O72.2", "ITQ008O72.1", "ITQ008O72.2", "ITE009O24.4", "ITE009O24.4"]

    arr_cq = []


    cod_embarazadas.each do |cod|
      
      cod_prestacion = cod[0..5]
      cod_diagnostico = cod[6, cod.length]

    
      puts "Resultado del query #{cq.inspect}"
      
    end
    return arr_cq
    

    select *
from prestaciones
where codigo in ('CTC001', 'CTC001')
;
select pi.*
from prestaciones_incluidas pi 
  join prestaciones_liquidadas p on p.prestacion_incluida_id = pi.id 
where prestacion_codigo in(  'ITQ012','ITQ013','ITQ014','ITQ009','ITQ010','ITQ011','ITE013','ITE014','CTC021','ITK001','ITK002','ITK003','ITK004','ITK005','ITK006','ITK007','ITK008','ITK009','ITK010','ITK011','ITK012','ITK013','ITK014','ITK015','ITK016','ITK017')
limit 10
;
set search_path to uad_009, public; 
select p.nombre, a.afiliado_id,a.clave_de_beneficiario, p.codigo, d.codigo codigo_diagnostico--pe.fecha_de_inicio, pe.fecha_de_finalizacion, pe.fecha_de_la_ultima_menstruacion, pe.fecha_efectiva_de_parto, pe.fecha_probable_de_parto, 
from prestaciones p
 join asignaciones_de_precios ap on ap.prestacion_id = p.id 
 join nomencladores n on n.id = ap.nomenclador_id
 left join diagnosticos_prestaciones dp on dp.prestacion_id = p.id
 left join diagnosticos d on d.id = dp.diagnostico_id
 join prestaciones_brindadas pb on p.id = pb.prestacion_id 
 join afiliados a on a.clave_de_beneficiario = pb.clave_de_beneficiario
 join efectores e on e.id = pb.efector_id and e.area_de_prestacion_id = ap.area_de_prestacion_id and e.id = pb.efector_id
 join prestaciones_liquidadas pl on pl.prestacion_brindada_id = pb.id and pl.efector_id = e.id
 join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = pl.id 
where n.id = 5
and  date_part('year',age(pb.fecha_de_la_prestacion, a.fecha_de_nacimiento )) BETWEEN 0 and 5 --beneficiarios que tenian entre 0 y 5 al momento de la prestacion 
and p.codigo ilike 'CTC001'
and d.codigo ilike 'A97'
and pb.estado_de_la_prestacion_id in (5, 12) --aceptada pendiente de pago, o pagada
and e.id in (select ef.id 
                        from efectores ef 
                             join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id 
                         where 'uad_' ||  u.codigo = current_schema() )   
and extract(month from pl.fecha_de_la_prestacion )  in (8,9)
and pb.diagnostico_id = d.id 
  end

  def self.grupo_embarazadas(arg_efectores, arg_meses, arg_nomenclador)
    
    arr_cq = []
    
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
            
            sql = "select  p.codigo, d.codigo diagnostico, count(*) total \n"+
              "from prestaciones p\n"+
              " join asignaciones_de_precios ap on ap.prestacion_id = p.id \n"+
              " join nomencladores n on n.id = ap.nomenclador_id\n"+
              " join diagnosticos_prestaciones dp on dp.prestacion_id = p.id\n"+
              " join diagnosticos d on d.id = dp.diagnostico_id\n"+
              " join prestaciones_brindadas pb on p.id = pb.prestacion_id\n"+
              " join afiliados a on a.clave_de_beneficiario = pb.clave_de_beneficiario\n"+
              " join periodos_de_embarazo pe on pe.afiliado_id = a.afiliado_id \n"+
              " join efectores e on e.id = pb.efector_id and e.area_de_prestacion_id = ap.area_de_prestacion_id and e.id = pb.efector_id\n"+
              " join prestaciones_liquidadas pl on pl.prestacion_brindada_id = pb.id and pl.efector_id = e.id\n"+
              " join liquidaciones_sumar_cuasifacturas_detalles det on det.prestacion_liquidada_id = pl.id \n"+
              "where n.id = 5\n"+
              "and ( (pe.fecha_de_inicio < pb.fecha_de_la_prestacion and pe.fecha_de_finalizacion is null )\n"+
              "          or\n"+
              "           (pb.fecha_de_la_prestacion BETWEEN pe.fecha_de_inicio and pe.fecha_de_finalizacion )\n"+
              "          )\n"+
              "and trim(p.codigo) = ?\n"+
              "and trim(d.codigo) = ?\n"+
              "and pb.estado_de_la_prestacion_id in (5, 12) --aceptada pendiente de pago, o pagada\n"+
              "and e.id in (select ef.id \n"+ # Solo efectores para ese esquema
              "                        from efectores ef \n"+
              "                             join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n"+
              "                         where 'uad_' ||  u.codigo = current_schema() )   \n"+
              "and extract(month from pl.fecha_de_la_prestacion )  in (8,9)\n"+ #solo prestaciones brindadas en un mes dado
              "GROUP BY p.codigo, d.codigo"


            cq = CustomQuery.buscar (
              {
                esquemas: esquemas,
                sql: sql,
                values: [cod_prestacion,cod_diagnostico ]
              })
            arr_cq << cq
           
        end
      end
    end

  end


end


