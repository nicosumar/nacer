class LiquidacionSumarAnexoAdministrativo < ActiveRecord::Base
  
  belongs_to :estado_del_proceso
  has_one :liquidacion_informe
  has_many :anexos_administrativos_prestaciones

  attr_accessible :fecha_de_finalizacion, :fecha_de_inicio, :estado_del_proceso

  def self.generar_anexo_administrativo(argInformeDeLiquidacionId)
  	# Obtengo la liquidacion
  	informe_de_liquidacion = LiquidacionInforme.find(argInformeDeLiquidacionId)
  	efector = informe_de_liquidacion.liquidacion_sumar_cuasifactura.efector.id
  	liquidacion_sumar = informe_de_liquidacion.liquidacion_sumar.id
  	estado_del_proceso = EstadoDelProceso.where(codigo: "C").first

    #Creo la cabecera 
  	anexo = LiquidacionSumarAnexoAdministrativo.create(
  		estado_del_proceso: estado_del_proceso,
  		fecha_de_inicio:  DateTime.now()
  		)

  	informe_de_liquidacion.liquidacion_sumar_anexo_administrativo = anexo
  	informe_de_liquidacion.save!

  	cq = CustomQuery.ejecutar ({
      sql:  "INSERT INTO \"public\".\"anexos_administrativos_prestaciones\" \n"+
						"(	\"liquidacion_sumar_anexo_administrativo_id\",	\"prestacion_liquidada_id\", \"created_at\",	\"updated_at\")\n"+
						"SELECT	#{anexo.id} anexo_administrativo_id, p.id, now(), now()\n"+
						"FROM\n"+
						"	liquidaciones_sumar l\n"+
						"JOIN prestaciones_liquidadas P ON P .liquidacion_id = l. ID\n"+
						"JOIN prestaciones_incluidas pi ON pi. ID = P .prestacion_incluida_id\n"+
						"JOIN prestaciones pr ON pr. ID = pi.prestacion_id\n"+
						"JOIN documentaciones_respaldatorias_prestaciones drp ON drp.prestacion_id = pr. ID\n"+
						"WHERE	P.liquidacion_id = #{liquidacion_sumar}\n"+
						"AND P .efector_id = #{efector}\n"+
						"AND (\n"+
						"	P .fecha_de_la_prestacion BETWEEN drp.fecha_de_inicio\n"+
						"	AND drp.fecha_de_finalizacion\n"+
						"	OR (\n"+
						"		P .fecha_de_la_prestacion >= drp.fecha_de_inicio\n"+
						"		AND drp.fecha_de_finalizacion IS NULL\n"+
						"	)\n"+
						")"
			})
  end

  def self.generar_anexo_para_devolucion(argInformeDeLiquidacionId)

  	informe_de_liquidacion = LiquidacionInforme.find(argInformeDeLiquidacionId)
    efector = informe_de_liquidacion.liquidacion_sumar_cuasifactura.efector.id
    liquidacion_sumar = informe_de_liquidacion.liquidacion_sumar

    # Estados
    estado_aceptada  = liquidacion_sumar.parametro_liquidacion_sumar.prestacion_aceptada.id
    estado_exceptuada = liquidacion_sumar.parametro_liquidacion_sumar.prestacion_exceptuada.id
    estados_aceptados = [estado_aceptada, estado_exceptuada].join(", ")
    estado_rechazada_refacturar = EstadoDeLaPrestacion.find(7) # 7  | Devuelta por la UGSP para refacturar |
  	estado_del_proceso = EstadoDelProceso.where(codigo: "B").first # estado "Finaliazo y cerrado"

  	anexo = LiquidacionSumarAnexoAdministrativo.create(
  		estado_del_proceso: estado_del_proceso,
  		fecha_de_inicio:  DateTime.now(),
  		fecha_de_finalizacion: DateTime.now()
  		)
  	informe_de_liquidacion.liquidacion_sumar_anexo_administrativo = anexo
  	informe_de_liquidacion.save!

    esquemas = UnidadDeAltaDeDatos.joins(:efectores).merge(Efector.where(id: efector))

    # Actualiza las prestaciones brindadas que hayan sido aceptadas durante la liquidación (o sea, aceptadas y exceptuadas por regla)
    # y las marca como rechazadas para refacturar.
    # Las prestaciones que no han sido aceptadas durante esta liquidación, se mantienen sin cambios en la tabla de prestaciones brindadas
    # sin tomar en cuenta si el rechazo se realizo por advertencias o algo similar. 
    cq = CustomQuery.ejecutar ({
      esquemas: esquemas,
      sql:  "update prestaciones_brindadas \n "+
            "   set estado_de_la_prestacion_id = #{estado_rechazada_refacturar.id} \n "+
            "from prestaciones_liquidadas p \n "+
            "where p.liquidacion_id = #{liquidacion_sumar.id} \n "+
            "and   p.estado_de_la_prestacion_liquidada_id in ( #{estados_aceptados} )\n "+
            "and p.efector_id in (select ef.id \n "+
            "                                      from efectores ef \n "+
            "                                         join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n "+
            "                                      where 'uad_' ||  u.codigo = current_schema() )\n "+
    				"and p.efector_id = #{efector}\n " +
            "and prestaciones_brindadas.id = p.prestacion_brindada_id"
      })

    # Actualizo el estado de la prestacion liquidada a rechazada para refacturar, siendo este su ultimo estado durante esta liquidación.
    cq = CustomQuery.ejecutar ({
      sql:  "update prestaciones_liquidadas \n "+
            "   set estado_de_la_prestacion_liquidada_id = #{estado_rechazada_refacturar.id} \n "+
            "where liquidacion_id = #{liquidacion_sumar.id} \n "+
            "and   estado_de_la_prestacion_liquidada_id in ( #{estados_aceptados} )\n "+
            "and efector_id = #{efector} "
      })
  end

  def finalizar_anexo
    # busco el estado de finalizado. TODO: Ver de parametrizar estos estados por algun lado
    estado_del_proceso = EstadoDelProceso.find(3) # Registrada, aun no se ha facturado

    # Establezco el estado de "Aceptada para liquidación en el estado de las prestaciones que no se ha definido estado"
    # TODO: Ver de parametrizar estos estados por algun lado
    estado_por_omision = EstadoDeLaPrestacion.find(5) # Aprobada pendiente de pago
    estado_por_defecto = EstadoDeLaPrestacion.find(4) #estado en el que esta la prestación al momento de generarse la cuasifactura (aca el estado es facturada, en proceso de liquidacion)

    transaction do
      
      self.anexos_administrativos_prestaciones.each do |prestacion|
        if prestacion.estado_de_la_prestacion.blank? || prestacion.estado_de_la_prestacion == estado_por_defecto
          prestacion.estado_de_la_prestacion = estado_por_omision
          prestacion.save!
        end
      end
      self.estado_del_proceso = estado_del_proceso
      self.fecha_de_finalizacion = Time.new
      self.save!
    end
  end

  def cerrar_anexo
    #busco el estado de finalizado. TODO: Ver de parametrizar estos estados por algun lado
    estado_del_proceso = EstadoDelProceso.find(4)

    self.estado_del_proceso = estado_del_proceso
    self.save!
  end
  
end
