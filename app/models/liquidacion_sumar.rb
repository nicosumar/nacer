# -*- encoding : utf-8 -*-
class LiquidacionSumar < ActiveRecord::Base
  belongs_to :grupo_de_efectores_liquidacion
  belongs_to :concepto_de_facturacion
  belongs_to :periodo
  belongs_to :plantilla_de_reglas
  belongs_to :parametro_liquidacion_sumar
  has_many   :prestaciones_liquidadas


  attr_accessible :descripcion, :grupo_de_efectores_liquidacion_id, :concepto_de_facturacion_id, :periodo_id, :plantilla_de_reglas_id, :parametro_liquidacion_sumar_id

  validates_presence_of :descripcion, :grupo_de_efectores_liquidacion, :concepto_de_facturacion, :periodo, :parametro_liquidacion_sumar_id
  
  def generar_snapshoot_de_liquidacion

    #Traigo Grupo de efectores y nomenclador
  	efectores =  self.grupo_de_efectores_liquidacion.efectores.all.collect {|ef| ef.id}
    esquemas = UnidadDeAltaDeDatos.joins(:efectores).merge(Efector.where(id: efectores))
    nomenclador = self.parametro_liquidacion_sumar.nomenclador
    vigencia_perstaciones = self.parametro_liquidacion_sumar.dias_de_prestacion
    fecha_de_recepcion = self.periodo.fecha_recepcion.to_s

    cq = CustomQuery.ejecutar (
      {
        esquemas: esquemas,
        sql:  "INSERT INTO public.prestaciones_incluidas\n"+
              "( liquidacion_id, \n"+
              "  nomenclador_id, nomenclador_nombre, \n"+
              "  prestacion_id, prestacion_nombre, prestacion_codigo, \n"+
              "  prestacion_cobertura, prestacion_comunitaria, prestacion_requiere_hc, prestacion_concepto_nombre, created_at, updated_at) \n"+
              " SELECT distinct #{self.id}, \n"+
              "               nom.id as nomenclador_id, nom.nombre as nomenclador_nombre, \n"+
              "               pr.id as prestacion_id, pr.nombre, pr.codigo as prestacion_codigo,  \n"+
              "               pr.otorga_cobertura as prestacion_cobertura, pr.comunitaria as prestacion_comunitaria, pr.requiere_historia_clinica as prestacion_requiere_hc \n"+
              "              ,cdf.concepto as prestacion_concepto_nombre,now(), now()\n"+
              "FROM prestaciones_brindadas pb\n"+
              "  INNER JOIN prestaciones pr ON (pr.id = pb.prestacion_id) \n"+
              "  INNER JOIN conceptos_de_facturacion cdf on (cdf.id = pr.concepto_de_facturacion_id)\n"+
              "  INNER JOIN afiliados af ON (af.clave_de_beneficiario = pb.clave_de_beneficiario) \n"+
              "  INNER JOIN efectores ef ON (ef.id = pb.efector_id) \n"+
              "  INNER JOIN asignaciones_de_precios ap \n"+
              "    ON (\n"+
              "      ap.prestacion_id = pb.prestacion_id\n"+
              "      AND ap.area_de_prestacion_id = ef.area_de_prestacion_id\n"+
              "    )\n"+
              "  INNER JOIN nomencladores nom  ON ( nom.id = ap.nomenclador_id ) \n"+
              "  WHERE estado_de_la_prestacion_id IN (2,3)\n"+
              "  AND cdf.id = #{self.concepto_de_facturacion.id}    \n"+
              "  AND ef.id in (select ef.id \n" +
              "                from efectores ef \n"+
              "                    join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n"+
              "                where 'uad_' ||  u.codigo = current_schema() )   \n"+
              "  AND nom.id = #{nomenclador.id}     \n"+
              "  AND pb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_de_recepcion}','yyyy-mm-dd') "
      })

    if cq 
      logger.warn ("Tabla de prestaciones incluidas generada")
    else
      logger.warn ("Tabla de prestaciones incluidas NO generada")
      return false
    end

    cq = CustomQuery.ejecutar ({
      esquemas: esquemas,
      sql:  "INSERT INTO public.prestaciones_liquidadas \n "+
            "       (liquidacion_id, unidad_de_alta_de_datos_id, efector_id, \n "+
            "        prestacion_incluida_id, fecha_de_la_prestacion, \n "+
            "        estado_de_la_prestacion_id, historia_clinica, es_catastrofica, \n "+
            "        diagnostico_id, diagnostico_nombre, \n "+
            "        cantidad_de_unidades, observaciones, \n "+
            "        clave_de_beneficiario, codigo_area_prestacion, nombre_area_de_prestacion, prestacion_brindada_id, \n "+
            "        created_at, updated_at) \n "+
            "SELECT distinct #{self.id} liquidacion_id, ef.unidad_de_alta_de_datos_id as unidad_de_alta_de_datos_id, pb.efector_id,\n "+
            "       pi.id as prestacion_incluida_id, pb.fecha_de_la_prestacion,\n "+
            "       pb.estado_de_la_prestacion_id, pb.historia_clinica, pb.es_catastrofica, \n "+
            "       pb.diagnostico_id, diag.nombre diagnostico_nombre,\n "+
            "       pb.cantidad_de_unidades, pb.observaciones,\n "+
            "       af.clave_de_beneficiario, areas.codigo codigo_area_prestacion, areas.nombre nombre_area_de_prestacion, pb.id prestacion_brindada_id, \n "+
            "       now(), now()\n "+
            "  FROM prestaciones_brindadas pb\n "+
            "  INNER JOIN prestaciones pr ON (pr.id = pb.prestacion_id) \n "+
            "  INNER JOIN prestaciones_incluidas pi on pb.prestacion_id = pi.prestacion_id\n "+
            " INNER JOIN diagnosticos diag on diag.id = pb.diagnostico_id\n "+
            "  INNER JOIN afiliados af ON (af.clave_de_beneficiario = pb.clave_de_beneficiario) \n "+
            "  INNER JOIN efectores ef ON (ef.id = pb.efector_id) \n "+
            "  INNER JOIN asignaciones_de_precios ap  \n "+
            "    ON (\n "+
            "      ap.prestacion_id = pb.prestacion_id\n "+
            "      AND ap.area_de_prestacion_id = ef.area_de_prestacion_id\n "+
            "    )\n "+
            "  INNER JOIN areas_de_prestacion areas on ap.area_de_prestacion_id = areas.id \n "+
            "  INNER JOIN nomencladores nom  \n "+
            "    ON ( nom.id = ap.nomenclador_id )\n "+
            "  \n "+
            "  WHERE pb.estado_de_la_prestacion_id IN (2,3)\n "+
            "  AND ef.id in (select ef.id \n" +
            "                from efectores ef \n"+
            "                    join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n"+
            "                where 'uad_' ||  u.codigo = current_schema() )   \n"+
            "  AND nom.id = #{nomenclador.id}     \n"+
            "  AND pb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_de_recepcion}','yyyy-mm-dd') "
      })

    if cq 
      logger.warn ("Tabla de prestaciones incluidas generada")
    else
      logger.warn ("Tabla de prestaciones incluidas NO generada")
      return false
    end
    cq = CustomQuery.ejecutar ({
      esquemas: esquemas,
      sql:  "INSERT INTO prestaciones_liquidadas_datos \n "+
            " (liquidacion_id, prestacion_liquidada_id, \n "+
            "  dato_reportable_nombre, precio_por_unidad, valor_integer, valor_big_decimal, valor_date, valor_string, adicional_por_prestacion, \n "+
            "   dato_reportable_id, dato_reportable_requerido_id, created_at, updated_at) \n "+
            "SELECT '#{self.id}' liquidacion_id, pl.id prestacion_liquidada_id, \n "+
            "       dr.nombre dato_reportable_nombre, ap.precio_por_unidad, dra.valor_integer, dra.valor_big_decimal, dra.valor_date, dra.valor_string, ap.adicional_por_prestacion, \n "+
            "        dr.id dato_reportable_id, drr.id dato_reportable_requerido_id, now(), now()\n "+
            "  FROM prestaciones_incluidas pi \n "+
            "   INNER JOIN prestaciones_liquidadas pl ON pl.prestacion_incluida_id  = pi.id \n "+
            "   INNER JOIN efectores ef ON (ef.id = pl.efector_id) -- Este join es para obtener el ID y el área de prestación del efector\n "+
            "   INNER JOIN asignaciones_de_precios ap  -- Este join trae los datos de la asignación de precios correspondiente al área de prestación del efector\n "+
            "     ON (\n "+
            "       ap.prestacion_id = pi.prestacion_id\n "+
            "       AND ap.area_de_prestacion_id = ef.area_de_prestacion_id --si el efector esta tipificado como rural y cargo una prestacion urbana, esta se excluye.\n "+
            "     )\n "+
            "   INNER JOIN nomencladores nom ON ( nom.id = ap.nomenclador_id ) -- Este join selecciona únicamente las AP correspondientes al nomenclador activo en el momento de la prestación\n "+
            "   LEFT JOIN (  -- Este join añade la información de los datos reportables asociados a las AP que los requieren (para obtener las cantidades)\n "+
            "       datos_reportables_asociados dra\n "+
            "       INNER JOIN\n "+
            "         datos_reportables_requeridos drr ON (drr.id = dra.dato_reportable_requerido_id)\n "+
            "       INNER JOIN\n "+
            "         datos_reportables dr ON (drr.dato_reportable_id = dr.id)\n "+
            "     )\n "+
            "     ON (\n "+
            "       dra.prestacion_brindada_id = pl.prestacion_brindada_id\n "+
            "       AND ap.dato_reportable_id = drr.dato_reportable_id\n "+
            "     )\n "+
            "  WHERE pl.estado_de_la_prestacion_id IN (2,3)\n "+
            "  AND ef.id in (select ef.id \n" +
            "                from efectores ef \n"+
            "                    join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n"+
            "                where 'uad_' ||  u.codigo = current_schema() )   \n"+
            "  and ap.nomenclador_id = #{nomenclador.id} \n" +
            "  AND pl.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_de_recepcion}','yyyy-mm-dd') "
      })
    if cq 
      logger.warn ("Tabla de prestaciones Liquidadas datos generada")
    else
      logger.warn ("Tabla de prestaciones Liquidadas datos NO generada")
      return false
    end

    cq = CustomQuery.ejecutar ({
      esquemas: esquemas,
      sql:  "INSERT INTO prestaciones_liquidadas_advertencias \n" +
            " (liquidacion_id, prestacion_liquidada_id, metodo_de_validacion_id, comprobacion, mensaje, created_at, updated_at)  \n"+
            "select '#{self.id}', pl.id prestacion_liquidada_id, m.metodo_de_validacion_id, mv.nombre comprobacion, mv.mensaje, now(), now() \n"+
            "from metodos_de_validacion_prestaciones_brindadas m \n"+
            " join metodos_de_validacion mv on mv.id = m.metodo_de_validacion_id \n"+
            " join prestaciones_liquidadas pl on pl.prestacion_brindada_id = m.prestacion_brindada_id \n"+
            "  WHERE pl.estado_de_la_prestacion_id IN (2,3) \n "+
            "  AND pl.efector_id in (select ef.id \n" +
            "                        from efectores ef \n"+
            "                          join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n"+
            "                        where 'uad_' ||  u.codigo = current_schema() )   \n"+
            "  AND pl.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_de_recepcion}','yyyy-mm-dd') "
      })
    if cq 
      logger.warn ("Tabla de prestaciones Liquidadas advertencias generada")
    else
      logger.warn ("Tabla de prestaciones Liquidadas advertencias NO generada")
      return false
    end

  end

  def generar_cuasifacturas

    nomenclador = self.parametro_liquidacion_sumar.nomenclador.id
    formula = "Formula_#{self.parametro_liquidacion_sumar.formula.id}"
    efectores =  self.grupo_de_efectores_liquidacion.efectores.all.collect {|ef| ef.id}
    esquemas = UnidadDeAltaDeDatos.joins(:efectores).merge(Efector.where(id: efectores))
    estado_aceptada = self.parametro_liquidacion_sumar.prestacion_aceptada.id
    estado_rechazada = self.parametro_liquidacion_sumar.prestacion_rechazada.id
    estado_exceptuada = self.parametro_liquidacion_sumar.prestacion_exceptuada.id

    # 1) hacer un insert de las que no tienen advertencias -- id 5: Aprobada para liquidación
    cq = CustomQuery.ejecutar ({
      esquemas: esquemas,
      sql:  "INSERT INTO public.liquidaciones_sumar_cuasifacturas \n"+
            "     (liquidacion_id, efector_id, prestacion_incluida_id, estado_de_la_prestacion_id, monto, observaciones, cuasifactura_id, created_at, updated_at) \n"+
            "select pl.liquidacion_id, pl.efector_id, pl.prestacion_incluida_id, #{estado_aceptada} estado_de_la_prestacion_id, #{formula}(pl.id) monto, null observaciones, null cuasifactura_id, now(), now()" +
            " from prestaciones_liquidadas pl \n "+
            "where pl.liquidacion_id = #{self.id}\n "+
            "and pl.id not in (select pla.prestacion_liquidada_id from prestaciones_liquidadas_advertencias pla where pla.liquidacion_id = #{self.id} )"
      })
    if cq 
      logger.warn ("Tabla de prestaciones Liquidadas advertencias generada")
    else
      logger.warn ("Tabla de prestaciones Liquidadas advertencias NO generada")
      return false
    end

    # 2) Insertar las que tienen advertencias salvadas por una regla con su observacion -- id 5: Aprobada para liquidación 
    cq = CustomQuery.ejecutar ({
      esquemas: esquemas,
      sql:  "INSERT INTO public.liquidaciones_sumar_cuasifacturas \n"+
            "     (liquidacion_id, efector_id, prestacion_incluida_id, estado_de_la_prestacion_id, monto, observaciones, cuasifactura_id, created_at, \"updated_at\") \n"+
            "select pl.liquidacion_id, pl.efector_id, pl.prestacion_incluida_id, #{estado_exceptuada} estado_de_la_prestacion_id, #{formula}(pl.id) monto, \n"+
            "       CAST(E'No cumple con la validacion de \"' || pla.comprobacion ||'\" \\n ' || \n"+
            "             'Aprobada por regla \"'|| r.nombre || '\" \\n' ||\n"+
            "             ' Observaciones: ' || r.observaciones\n"+
            "            as text) observaciones, null cuasifactura_id, now(), now()"+
            " from prestaciones_liquidadas_advertencias pla \n "+
            "   join prestaciones_liquidadas pl on pl.id = pla.prestacion_liquidada_id\n "+
            "   join prestaciones_incluidas pi on pi.id = pl.prestacion_incluida_id\n "+
            "   join reglas r on (r.prestacion_id = pi.prestacion_id and r.metodo_de_validacion_id = pla.metodo_de_validacion_id and r.permitir = 't' )\n "+
            "where pl.liquidacion_id = #{self.id}\n "+
            "and   pi.nomenclador_id = #{nomenclador}"
      })
    if cq 
      logger.warn ("Tabla de prestaciones Liquidadas advertencias generada")
    else
      logger.warn ("Tabla de prestaciones Liquidadas advertencias NO generada")
      return false
    end

    # 3) Insertar las que tienen advertencias no salvadas por una regla -- ID 6: Rechazada por la UGSP
    cq = CustomQuery.ejecutar ({
      esquemas: esquemas,
      sql:  "INSERT INTO public.liquidaciones_sumar_cuasifacturas \n"+
            "     (liquidacion_id, efector_id, prestacion_incluida_id, estado_de_la_prestacion_id, monto, observaciones, cuasifactura_id, created_at, updated_at) \n"+
            "select pl.liquidacion_id, pl.efector_id, pl.prestacion_incluida_id, #{estado_rechazada} estado_de_la_prestacion_id, #{formula}(pl.id) monto, \n"+
            "       CAST(E'No cumple con la validacion de \"' || pla.comprobacion ||'\" \\n ' \n "+
            "            as text) observaciones, null cuasifactura_id, now(), now() \n "+
            " from prestaciones_liquidadas_advertencias pla \n "+
            "   join prestaciones_liquidadas pl on pl.id = pla.prestacion_liquidada_id\n "+
            "   join prestaciones_incluidas pi on pi.id = pl.prestacion_incluida_id\n "+
            "where pl.liquidacion_id = #{self.id}\n "+
            "and   pi.nomenclador_id = #{nomenclador} \n "+
            "and pl.id in (select pla.prestacion_liquidada_id --todas las prestaciones liquidadas con advertencias\n "+
            "                 from prestaciones_liquidadas_advertencias pla\n "+
            "                 join prestaciones_liquidadas pl on pl.id = pla.prestacion_liquidada_id\n "+
            "                 join prestaciones_incluidas pi on pi.id = pl.prestacion_incluida_id\n "+
            "               where pla.liquidacion_id = #{self.id}\n "+
            "               and pi.nomenclador_id = #{nomenclador} \n "+
            "               EXCEPT\n "+
            "               select pl.id --le saco las prestaciones liquidadas con advertencias que son salvadas por una regla\n "+
            "                 from prestaciones_liquidadas_advertencias pla \n "+
            "                   join prestaciones_liquidadas pl on pl.id = pla.prestacion_liquidada_id\n "+
            "                   join prestaciones_incluidas pi on pi.id = pl.prestacion_incluida_id\n "+
            "                   join reglas r on (r.prestacion_id = pi.prestacion_id and r.metodo_de_validacion_id = pla.metodo_de_validacion_id and r.permitir = 't' )\n "+
            "               where pl.liquidacion_id = #{self.id}\n "+
            "               and   pi.nomenclador_id = #{nomenclador}  )"
      })
    if cq 
      logger.warn ("Tabla de prestaciones Liquidadas advertencias generada")
    else
      logger.warn ("Tabla de prestaciones Liquidadas advertencias NO generada")
      return false
    end
    return true

  end

  def vaciar_liquidacion
    ActiveRecord::Base.connection.execute "delete \n"+
            "from prestaciones_liquidadas_advertencias\n"+
            "where liquidacion_id = #{self.id};\n"+
            "delete \n"+
            "from prestaciones_liquidadas_datos\n"+
            "where liquidacion_id = #{self.id}\n"+
            ";\n"+
            "DELETE\n"+
            "from  prestaciones_liquidadas\n"+
            "where liquidacion_id = #{self.id}\n"+
            ";\n"+
            "delete\n"+
            "from prestaciones_incluidas\n"+
            "where liquidacion_id = #{self.id}"
  end
end
