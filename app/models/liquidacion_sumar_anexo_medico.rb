class LiquidacionSumarAnexoMedico < ActiveRecord::Base
  belongs_to :estado_del_proceso
  has_one :liquidacion_informe

  attr_accessible :fecha_de_finalizacion, :fecha_de_inicio, :estado_del_proceso

  def self.generar_anexo_para_devolucion(argInformeDeLiquidacionId)

  	informe_de_liquidacion = LiquidacionInforme.find(argInformeDeLiquidacionId)
    efector = informe_de_liquidacion.liquidacion_sumar_cuasifactura.efector.id
    liquidacion_sumar = informe_de_liquidacion.liquidacion_sumar

    # Estados
    estado_aceptada  = liquidacion_sumar.parametro_liquidacion_sumar.prestacion_aceptada.id
    estado_exceptuada = liquidacion_sumar.parametro_liquidacion_sumar.prestacion_exceptuada.id
    estados_aceptados = [estado_aceptada, estado_exceptuada].join(", ")
    estado_rechazada_refacturar = EstadoDeLaPrestacion.find(7) # 7  | Devuelta por la UGSP para refacturar |
  	estado_del_proceso = EstadoDelProceso.where(codigo: "B").first

  	anexo = LiquidacionSumarAnexoMedico.create(
  		estado_del_proceso: estado_del_proceso,
  		fecha_de_inicio:  DateTime.now(),
  		fecha_de_finalizacion: DateTime.now()
  		)

    esquemas = UnidadDeAltaDeDatos.joins(:efectores).merge(Efector.where(id: efector))

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
            "and prestaciones_brindadas.id = p.prestacion_brindada_id"
      })

      cq = CustomQuery.ejecutar ({
      sql:  "update prestaciones_liquidadas \n "+
            "   set estado_de_la_prestacion_id = #{estado_rechazada_refacturar.id} \n "+
            "where liquidacion_id = #{liquidacion_sumar.id} \n "+
            "and   estado_de_la_prestacion_liquidada_id in ( #{estados_aceptados} )\n "+
            "and efector_id in (select ef.id \n "+
            "                                      from efectores ef \n "+
            "                                         join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n "+
            "                                      where 'uad_' ||  u.codigo = current_schema() )\n "
      })

  end
end
