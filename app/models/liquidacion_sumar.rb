# -*- encoding : utf-8 -*-
class LiquidacionSumar < ActiveRecord::Base
  belongs_to :grupo_de_efectores_liquidacion
  belongs_to :concepto_de_facturacion
  belongs_to :periodo
  belongs_to :plantilla_de_reglas
  belongs_to :parametro_liquidacion_sumar
  has_many   :prestaciones_liquidadas, foreign_key: :liquidacion_id


  attr_accessible :descripcion, :grupo_de_efectores_liquidacion_id, :concepto_de_facturacion_id, :periodo_id, :plantilla_de_reglas_id, :parametro_liquidacion_sumar_id

  validates_presence_of :descripcion, :grupo_de_efectores_liquidacion, :concepto_de_facturacion, :periodo, :parametro_liquidacion_sumar_id
  
  def generar_snapshoot_de_liquidacion

    #Traigo Grupo de efectores y nomenclador
  	efectores =  self.grupo_de_efectores_liquidacion.efectores.all.collect {|ef| ef.id}
    esquemas = UnidadDeAltaDeDatos.joins(:efectores).merge(Efector.where(id: efectores))
    nomenclador = self.parametro_liquidacion_sumar.nomenclador
    vigencia_perstaciones = self.parametro_liquidacion_sumar.dias_de_prestacion
    fecha_de_recepcion = self.periodo.fecha_recepcion.to_s

    # 1) Identifico los TIPOS de prestaciones que se brindaron en esta liquidacion y genero el snapshoot de las mismas
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

    # 2) Identifico las prestaciones que se brindaron en esta liquidacion y genero el snapshoot de las mismas
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

    # 3)  Identifico los datos vinculados a las prestaciones brindadas 
    #    que se incluyeron en esta liquidacion y genero el snapshoot de las mismas
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

    # 4)  Identifico las advertencias que poseen las prestaciones brindadas que se  
    #    que se incluyeron en esta liquidacion y genero el snapshoot de las mismas
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

    # 5) Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla
    #    de prestaciones liquidadas 
    #    - Aca con las prestaciones aceptadas

    formula = "Formula_#{self.parametro_liquidacion_sumar.formula.id}"
    plantilla_de_reglas = self.plantilla_de_reglas_id
    estado_aceptada = self.parametro_liquidacion_sumar.prestacion_aceptada.id
    estado_rechazada = self.parametro_liquidacion_sumar.prestacion_rechazada.id
    estado_exceptuada = self.parametro_liquidacion_sumar.prestacion_exceptuada.id
    nomenclador = self.parametro_liquidacion_sumar.nomenclador.id

    cq = CustomQuery.ejecutar ({
      sql:  "UPDATE public.prestaciones_liquidadas \n"+
            "SET monto = #{formula}(id), \n"+
            "    estado_de_la_prestacion_liquidada_id =  #{estado_aceptada} \n"+
            "WHERE id in \n"+
            "(select pl.id \n" +
            " from prestaciones_liquidadas pl \n "+
            "where pl.liquidacion_id = #{self.id}\n "+
            "and pl.id not in (select pla.prestacion_liquidada_id from prestaciones_liquidadas_advertencias pla where pla.liquidacion_id = #{self.id}) )"
      })
    # 6) Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla
    #    de prestaciones liquidadas 
    #    - Aca con las prestaciones exceptuadas (aceptadas por regla), con su observacion
    cq = CustomQuery.ejecutar ({
      sql:  "UPDATE public.prestaciones_liquidadas \n"+
            "SET monto = #{formula}(pl.id), \n"+
            "    estado_de_la_prestacion_liquidada_id =  #{estado_exceptuada}, \n"+
            "    observaciones_liquidacion = CAST(E'No cumple con la validacion de \"' || pla.comprobacion ||'\" \\n ' \n "+
            "                         ' Aprobada por regla \"'|| regl.nombre || '\" \\n' ||\n"+
            "                         ' Observaciones: ' || regl.observaciones\n"+
            "                           as text)\n "+
            " from prestaciones_liquidadas_advertencias pla \n "+
            "   join prestaciones_liquidadas pl on pl.id = pla.prestacion_liquidada_id\n "+
            "   join prestaciones_incluidas pi on pi.id = pl.prestacion_incluida_id\n "+
            "join (\n"+
            "     select r.nombre, r.observaciones, r.prestacion_id, r.metodo_de_validacion_id, pr.id\n"+
            "    from plantillas_de_reglas pr\n"+
            "    join plantillas_de_reglas_reglas prr on prr.plantilla_de_reglas_id = pr.id\n"+
            "    join reglas r on (\n"+
            "    r.id = prr.regla_id\n"+
            "    and r.permitir = 't' )\n"+
            "    ) as regl\n"+
            "    on\n"+
            "    ( regl.prestacion_id = pi.prestacion_id\n"+
            "    and regl.metodo_de_validacion_id = pla.metodo_de_validacion_id\n"+
            "    ) \n"+
            "where pl.liquidacion_id = #{self.id}\n "+
            "and   pi.nomenclador_id = #{nomenclador} \n"+
            "and prestaciones_liquidadas.id = pl.id \n"+
            "and regl.id = #{plantilla_de_reglas}"
      })
    logger.warn("CQ--------------------------------- #{cq.inspect}")
    # 7) Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla
    #    de prestaciones liquidadas 
    #    - Aca con las prestaciones rechazadas
    cq = CustomQuery.ejecutar ({
      sql:  "UPDATE public.prestaciones_liquidadas \n"+
            "SET monto = #{formula}(pl.id), \n"+
            "    estado_de_la_prestacion_liquidada_id =  #{estado_rechazada}, \n"+
            "    observaciones_liquidacion = CAST(E'No cumple con la validacion de \"' || pla.comprobacion ||'\" \\n ' \n "+
            "                           as text)\n "+
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
            "               select prestacion_liquidada_id\n"+
            "               from prestaciones_liquidadas_advertencias pla\n"+
            "               join prestaciones_liquidadas pl on pl.id = pla.prestacion_liquidada_id\n"+
            "               join prestaciones_incluidas pi on pi.id = pl.prestacion_incluida_id\n"+
            "               join (\n"+
            "                 select r.nombre, r.observaciones, r.prestacion_id, r.metodo_de_validacion_id, pr.id\n"+
            "                  from plantillas_de_reglas pr\n"+
            "                  join plantillas_de_reglas_reglas prr on prr.plantilla_de_reglas_id = pr.id\n"+
            "                  join reglas r on (\n"+
            "                                     r.id = prr.regla_id\n"+
            "                                     and r.permitir = 't' )\n"+
            "                                     ) as regl\n"+
            "                  on\n"+
            "                    ( regl.prestacion_id = pi.prestacion_id\n"+
            "                      and regl.metodo_de_validacion_id = pla.metodo_de_validacion_id\n"+
            "                    )\n"+
            "                 where pl.liquidacion_id = #{self.id} \n"+
            "                 and pi.nomenclador_id = #{nomenclador} \n"+
           # "                 and prestaciones_liquidadas.id = pl.id\n".
            "                 and regl.id = #{plantilla_de_reglas} )\n"+
            "and prestaciones_liquidadas.id = pl.id "

     })


  end

  def generar_cuasifacturas

    estado_rechazada = self.parametro_liquidacion_sumar.prestacion_rechazada.id

    # 1) Genero las cabeceras
    cq = CustomQuery.ejecutar ({
      sql:  "INSERT INTO public.liquidaciones_sumar_cuasifacturas  \n"+
            "(liquidacion_sumar_id, efector_id, monto_total, created_at, updated_at)  \n"+
            "select liquidacion_id, efector_id, sum(monto), now(), now() \n"+
            "from prestaciones_liquidadas \n"+
            "where liquidacion_id = #{self.id} \n"+
            "and   estado_de_la_prestacion_liquidada_id != #{estado_rechazada} \n"+
            "group by liquidacion_id, efector_id"
                  })
    if cq 
      logger.warn ("Tabla de cuasifacturas generada")
    else
      logger.warn ("Tabla de cuasifacturas NO generada")
      return false
    end

    # 2) Insertar las que tienen advertencias salvadas por una regla con su observacion -- id 5: Aprobada para liquidación 
    cq = CustomQuery.ejecutar ({
      sql:  "INSERT INTO public.liquidaciones_sumar_cuasifacturas_detalles  \n"+
            "(liquidaciones_sumar_cuasifacturas_id, prestacion_incluida_id, estado_de_la_prestacion_id, monto, observaciones, created_at, updated_at)  \n"+
            "select lsc.id , p.prestacion_incluida_id, p.estado_de_la_prestacion_liquidada_id, p.monto, 
             'Observaciones de la prestacion: ' ||p.observaciones || '\\n Observaciones de liquidacion: '|| p.observaciones_liquidacion
              , now(),now() \n"+
            "from prestaciones_liquidadas p \n"+
            " join liquidaciones_sumar_cuasifacturas lsc on (lsc.liquidacion_sumar_id = p.liquidacion_id and lsc.efector_id = p.efector_id ) \n"+
            "where p.liquidacion_id = #{self.id} \n"+
            "and   p.estado_de_la_prestacion_liquidada_id != #{estado_rechazada}"
      })

    if cq 
      logger.warn ("Tabla de detalle de cuasifacturas generada")
    else
      logger.warn ("Tabla de detalle de cuasifacturas NO generada")
      return false
    end
    return true

  end

  def vaciar_liquidacion

    # TODO: comprobar que no existen cuasifacturas generadas para poder eliminar
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
