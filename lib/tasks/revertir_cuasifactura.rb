#~~ encoding: utf-8 ~~
class RevertirCuasifactura

  # Revierte y regenera una cuasifactura des un efector.
  # Para regenerar la cuasifactura utiliza la misma liquidación
  # sin afectar a los otros efectores incluidos.
  #
  # @param arg_liquidacion: ID de liquidación 
  # @param [] args_arr_efectores: Arrays con los IDs de efectores en la liquidacion indicada
  # @return boolean
  def self.desde_efectores(arg_liquidacion, args_arr_efectores)
    
    ActiveRecord::Base.transaction do

      liquidacion = LiquidacionSumar.where(id: arg_liquidacion)
      liquidacion.each do |l|

        # Si no existe la cuasifactura, que solo reliquide al efector en esa liquidacion.
        args_arr_efectores.each do |e|
          cuasi_facturas = LiquidacionSumarCuasifactura.where(liquidacion_sumar_id: arg_liquidacion, efector_id: e)
          efectores =  l.grupo_de_efectores_liquidacion.efectores.where(id: e).collect {|ef| ef.id}
          esquemas = UnidadDeAltaDeDatos.joins(:efectores).merge(Efector.where(id: efectores))
          if cuasi_facturas.size > 0 
            # 3) Actualiza las prestaciones brindadas para que no sean modificadas

            cq = CustomQuery.ejecutar ({
              esquemas: esquemas,
              sql:  "update prestaciones_brindadas \n "+
                    "   set estado_de_la_prestacion_id = p.estado_de_la_prestacion_id \n "+
                    "from prestaciones_liquidadas p \n "+
                    "    join liquidaciones_sumar_cuasifacturas lsc on (lsc.liquidacion_sumar_id = p.liquidacion_id and lsc.efector_id = p.efector_id ) \n "+
                    "where p.liquidacion_id = #{l.id} \n "+
                    "and p.efector_id in (select ef.id \n "+
                    "                                      from efectores ef \n "+
                    "                                         join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n "+
                    "                                      where 'uad_' ||  u.codigo = current_schema() )\n "+
                    "and prestaciones_brindadas.id = p.prestacion_brindada_id"
            })
          
            # Volver hacia atrás las secuencias
            cuasi_facturas = LiquidacionSumarCuasifactura.where(liquidacion_sumar_id: arg_liquidacion, efector_id: e)
            cuasi_facturas.each do |cf|
              ultima_secuencia = ActiveRecord::Base.connection.exec_query("SELECT * FROM public.cuasi_factura_sumar_seq_efector_id_#{cf.efector_id};").first["last_value"].to_i
              if ultima_secuencia > 1
                ActiveRecord::Base.connection.execute "
                  SELECT setval('public.cuasi_factura_sumar_seq_efector_id_#{cf.efector_id}', #{ultima_secuencia - 1}, 't');
                "
              else
                ActiveRecord::Base.connection.execute "
                  SELECT setval('public.cuasi_factura_sumar_seq_efector_id_#{cf.efector_id}', 1, 'f');
                "
              end
            end

            ActiveRecord::Base.connection.execute "
              DELETE FROM liquidaciones_sumar_cuasifacturas_detalles WHERE liquidaciones_sumar_cuasifacturas_id IN (
                SELECT id 
                FROM liquidaciones_sumar_cuasifacturas 
                WHERE liquidacion_sumar_id = #{arg_liquidacion} 
                AND efector_id IN (#{efectores.join(", ")} )
                );
              DELETE FROM liquidaciones_sumar_cuasifacturas WHERE liquidacion_sumar_id = #{arg_liquidacion}
              AND efector_id IN( #{efectores.join(", ")});"
              
              ActiveRecord::Base.connection.execute "delete \n"+
                "from prestaciones_liquidadas_advertencias\n"+
                "where prestacion_liquidada_id in ( select id from prestaciones_liquidadas where liquidacion_id = #{l.id} and efector_id in (#{efectores.join(", ")} ) )  ;\n"+

                "delete \n"+
                "from prestaciones_liquidadas_datos\n"+
                "where prestacion_liquidada_id in  ( select id from prestaciones_liquidadas where liquidacion_id = #{l.id} and efector_id in (#{efectores.join(", ")} ) )  \n"+
                ";\n"+
                "DELETE\n"+
                "from  prestaciones_liquidadas\n"+
                "where liquidacion_id = #{l.id} and efector_id in (#{efectores.join(", ")}) \n"+
                ";\n" #+
                #{}"delete\n"+
                #{}"from prestaciones_incluidas\n"+
                #{}"where liquidacion_id = #{l.id}"
          
          end

        ##############################################################################################
        #liquido de nuevo esos efectores (copy paste del modulo de liquidacion )
        vigencia_perstaciones = l.parametro_liquidacion_sumar.dias_de_prestacion
        fecha_de_recepcion = l.periodo.fecha_recepcion.to_s
        fecha_limite_prestaciones = l.periodo.fecha_limite_prestaciones.to_s

        # 0 ) Elimino los duplicados
        cq = CustomQuery.ejecutar({
          esquemas: esquemas,
          sql: "update prestaciones_brindadas\n"+
              "set estado_de_la_prestacion_id = 11\n"+
              "WHERE\n"+
              " EXISTS (\n"+
              "   SELECT *\n"+
              "   FROM prestaciones_brindadas pb2\n"+
              "   WHERE prestaciones_brindadas.efector_id = pb2.efector_id\n"+
              "   AND prestaciones_brindadas.prestacion_id = pb2.prestacion_id\n"+
              "   AND prestaciones_brindadas.clave_de_beneficiario = pb2.clave_de_beneficiario\n"+
              "   AND prestaciones_brindadas.fecha_de_la_prestacion = pb2.fecha_de_la_prestacion\n"+
              "   AND pb2.id > prestaciones_brindadas.id \n"+
              "   AND prestaciones_brindadas.estado_de_la_prestacion_id = pb2.estado_de_la_prestacion_id\n"+
              "   AND prestaciones_brindadas.estado_de_la_prestacion_id IN (2, 3, 7)\n"+
              " )"
          })

        # 1) a -  Identifico los TIPOS de prestaciones que se brindaron en esta liquidacion y genero el snapshoot de las mismas
        cq = CustomQuery.ejecutar (
          {
            esquemas: esquemas,
            sql:  "INSERT INTO public.prestaciones_incluidas\n"+
                  "( liquidacion_id, \n"+
                  "  nomenclador_id, nomenclador_nombre, \n"+
                  "  prestacion_id, prestacion_nombre, prestacion_codigo, \n"+
                  "  prestacion_cobertura, prestacion_comunitaria, prestacion_requiere_hc, prestacion_concepto_nombre, created_at, updated_at) \n"+
                  " SELECT DISTINCT ON (nom.id, pr.id) #{l.id}, \n"+
                  "               nom.id as nomenclador_id, nom.nombre as nomenclador_nombre, \n"+
                  "               pr.id as prestacion_id, pr.nombre, pr.codigo as prestacion_codigo,  \n"+
                  "               pr.otorga_cobertura as prestacion_cobertura, pr.comunitaria as prestacion_comunitaria, pr.requiere_historia_clinica as prestacion_requiere_hc \n"+
                  "              ,cdf.concepto as prestacion_concepto_nombre,now(), now()\n"+
                  "FROM prestaciones_brindadas pb\n"+
                  "  INNER JOIN prestaciones pr ON (pr.id = pb.prestacion_id) \n"+
                  "  INNER JOIN conceptos_de_facturacion cdf on (cdf.id = pr.concepto_de_facturacion_id)\n"+
                  "  INNER JOIN afiliados af ON (af.clave_de_beneficiario = pb.clave_de_beneficiario) \n"+
                  "  INNER JOIN periodos_de_actividad pa on (af.afiliado_id = pa.afiliado_id ) \n"+ #solo los afiliados que tenga algun periodo de actividad
                  "  INNER JOIN efectores ef ON (ef.id = pb.efector_id) \n"+
                  "  INNER JOIN asignaciones_de_precios ap \n"+
                  "    ON (\n"+
                  "      ap.prestacion_id = pb.prestacion_id\n"+
                  "      AND ap.area_de_prestacion_id = ef.area_de_prestacion_id\n"+
                  "    )\n"+
                  "  INNER JOIN nomencladores nom  ON ( nom.id = ap.nomenclador_id ) \n"+
                  "  WHERE estado_de_la_prestacion_id IN (2,3,7)\n"+
                  "  AND cdf.id = #{l.concepto_de_facturacion.id}    \n"+
                  "  AND ef.id in (select ef.id \n" +
                  "                from efectores ef \n"+
                  "                    join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n"+
                  "                where 'uad_' ||  u.codigo = current_schema() )   \n"+
                  "  AND nom.id =      \n"+
                  "              (select id from nomencladores \n"+
                  "               where activo = 't' \n"+
                  "               and nomenclador_sumar = 't' \n"+
                  "               and (pb.fecha_de_la_prestacion BETWEEN fecha_de_inicio and fecha_de_finalizacion\n"+
                  "               or  \n"+
                  "               (pb.fecha_de_la_prestacion >= fecha_de_inicio and fecha_de_finalizacion is null) )\n"+
                  "               limit 1\n"+
                  "               )"+
                  "  AND pb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') \n"+
                  "  AND pr.id not in (select prestacion_id from prestaciones_incluidas where liquidacion_id = #{l.id} ) \n" +
                  "  AND ( (pb.fecha_de_la_prestacion >= pa.fecha_de_inicio and pa.fecha_de_finalizacion is null )\n"+  # La prestacion debe haber sido brindada en algun periodo de actividad vigente
                  "         OR\n"+
                  "       (pb.fecha_de_la_prestacion between pa.fecha_de_inicio and pa.fecha_de_finalizacion )\n"+
                  "       )"
          })

        if cq
          puts ("Tabla de prestaciones incluidas generada")
        else
          puts ("Tabla de prestaciones incluidas NO generada")
          return false
        end

        # 1) b -  Identifico los TIPOS de prestaciones que no requieren un beneficiario que se brindaron en esta liquidacion y genero el snapshoot de las mismas
        cq = CustomQuery.ejecutar (
          {
            esquemas: esquemas,
            sql:  "INSERT INTO public.prestaciones_incluidas\n"+
                  "( liquidacion_id, \n"+
                  "  nomenclador_id, nomenclador_nombre, \n"+
                  "  prestacion_id, prestacion_nombre, prestacion_codigo, \n"+
                  "  prestacion_cobertura, prestacion_comunitaria, prestacion_requiere_hc, prestacion_concepto_nombre, created_at, updated_at) \n"+
                  " SELECT DISTINCT ON (nom.id, pr.id) #{l.id}, \n"+
                  "               nom.id as nomenclador_id, nom.nombre as nomenclador_nombre, \n"+
                  "               pr.id as prestacion_id, pr.nombre, pr.codigo as prestacion_codigo,  \n"+
                  "               pr.otorga_cobertura as prestacion_cobertura, pr.comunitaria as prestacion_comunitaria, pr.requiere_historia_clinica as prestacion_requiere_hc \n"+
                  "              ,cdf.concepto as prestacion_concepto_nombre,now(), now()\n"+
                  "FROM prestaciones_brindadas pb\n"+
                  "  INNER JOIN prestaciones pr ON (pr.id = pb.prestacion_id) \n"+
                  "  INNER JOIN conceptos_de_facturacion cdf on (cdf.id = pr.concepto_de_facturacion_id)\n"+
                  "  INNER JOIN efectores ef ON (ef.id = pb.efector_id) \n"+
                  "  INNER JOIN asignaciones_de_precios ap \n"+
                  "    ON (\n"+
                  "      ap.prestacion_id = pb.prestacion_id\n"+
                  "      AND ap.area_de_prestacion_id = ef.area_de_prestacion_id\n"+
                  "    )\n"+
                  "  INNER JOIN nomencladores nom  ON ( nom.id = ap.nomenclador_id ) \n"+
                  "  WHERE estado_de_la_prestacion_id IN (2,3,7)\n"+
                  "  AND cdf.id = #{l.concepto_de_facturacion.id}    \n"+
                  "  AND ef.id in (select ef.id \n" +
                  "                from efectores ef \n"+
                  "                    join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n"+
                  "                where 'uad_' ||  u.codigo = current_schema() )   \n"+
                  "  AND nom.id =      \n"+
                  "              (select id from nomencladores \n"+
                  "               where activo = 't' \n"+
                  "               and nomenclador_sumar = 't' \n"+
                  "               and (pb.fecha_de_la_prestacion BETWEEN fecha_de_inicio and fecha_de_finalizacion\n"+
                  "               or  \n"+
                  "               (pb.fecha_de_la_prestacion >= fecha_de_inicio and fecha_de_finalizacion is null) )\n"+
                  "               limit 1\n"+
                  "               )"+
                  "  AND pb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') \n"+
                  "  AND pr.id not in (select prestacion_id from prestaciones_incluidas where liquidacion_id = #{l.id} ) \n" +
                  "  AND pr.comunitaria "
          })

        if cq
          puts ("Tabla de prestaciones incluidas generada")
        else
          puts ("Tabla de prestaciones incluidas NO generada")
          return false
        end


        # 2) a ) Identifico las prestaciones que se brindaron en esta liquidacion y genero el snapshoot de las mismas 
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
                "SELECT DISTINCT #{l.id} liquidacion_id, ef.unidad_de_alta_de_datos_id as unidad_de_alta_de_datos_id, pb.efector_id,\n "+
                "       pi.id as prestacion_incluida_id, pb.fecha_de_la_prestacion,\n "+
                "       pb.estado_de_la_prestacion_id, pb.historia_clinica, pb.es_catastrofica, \n "+
                "       pb.diagnostico_id, diag.nombre diagnostico_nombre,\n "+
                "       pb.cantidad_de_unidades, pb.observaciones,\n "+
                "       af.clave_de_beneficiario, areas.codigo codigo_area_prestacion, areas.nombre nombre_area_de_prestacion, pb.id prestacion_brindada_id, \n "+
                "       now(), now()\n "+
                "  FROM prestaciones_brindadas pb\n "+
                "  INNER JOIN prestaciones pr ON (pr.id = pb.prestacion_id) \n "+
                "  INNER JOIN prestaciones_incluidas pi on (pb.prestacion_id = pi.prestacion_id AND pi.liquidacion_id = #{l.id})\n "+
                "  INNER JOIN diagnosticos diag on diag.id = pb.diagnostico_id\n "+
                "  INNER JOIN afiliados af ON (af.clave_de_beneficiario = pb.clave_de_beneficiario) \n "+
                "  INNER JOIN periodos_de_actividad pa on (af.afiliado_id = pa.afiliado_id ) \n"+ #solo los afiliados que tenga algun periodo de actividad
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
                "  WHERE pb.estado_de_la_prestacion_id IN (2,3,7)\n "+
                "  AND ef.id in (select ef.id \n" +
                "                from efectores ef \n"+
                "                    join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n"+
                "                where 'uad_' ||  u.codigo = current_schema() )   \n"+
                "  AND nom.id =      \n"+
                "              (select id from nomencladores \n"+
                "               where activo = 't' \n"+
                "               and nomenclador_sumar = 't' \n"+
                "               and (pb.fecha_de_la_prestacion BETWEEN fecha_de_inicio and fecha_de_finalizacion\n"+
                "               or  \n"+
                "               (pb.fecha_de_la_prestacion >= fecha_de_inicio and fecha_de_finalizacion is null) )\n"+
                "               limit 1\n"+
                "               )"+
                "  AND pb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') \n"+
                "  AND ( (pb.fecha_de_la_prestacion >= pa.fecha_de_inicio and pa.fecha_de_finalizacion is null )\n"+  # La prestacion debe haber sido brindada en algun periodo de actividad vigente
                "         OR\n"+
                "       (pb.fecha_de_la_prestacion between pa.fecha_de_inicio and pa.fecha_de_finalizacion )\n"+
                "       )"
          })

        if cq
          puts ("Tabla de prestaciones liquidadas generada")
        else
          puts ("Tabla de prestaciones liquidadas NO generada")
          return false
        end

        # 2) B ) Identifico las prestaciones que se brindaron en esta liquidacion y genero el snapshoot de las mismas 
        #        que no poseen beneficiario
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
                "SELECT DISTINCT #{l.id} liquidacion_id, ef.unidad_de_alta_de_datos_id as unidad_de_alta_de_datos_id, pb.efector_id,\n "+
                "       pi.id as prestacion_incluida_id, pb.fecha_de_la_prestacion,\n "+
                "       pb.estado_de_la_prestacion_id, pb.historia_clinica, pb.es_catastrofica, \n "+
                "       pb.diagnostico_id, diag.nombre diagnostico_nombre,\n "+
                "       pb.cantidad_de_unidades, pb.observaciones,\n "+
                "       NULL, areas.codigo codigo_area_prestacion, areas.nombre nombre_area_de_prestacion, pb.id prestacion_brindada_id, \n "+
                "       now(), now()\n "+
                "  FROM prestaciones_brindadas pb\n "+
                "  INNER JOIN prestaciones pr ON (pr.id = pb.prestacion_id) \n "+
                "  INNER JOIN prestaciones_incluidas pi on (pb.prestacion_id = pi.prestacion_id AND pi.liquidacion_id = #{l.id})\n "+
                "  INNER JOIN diagnosticos diag on diag.id = pb.diagnostico_id\n "+
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
                "  WHERE pb.estado_de_la_prestacion_id IN (2,3,7)\n "+
                "  AND ef.id in (select ef.id \n" +
                "                from efectores ef \n"+
                "                    join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n"+
                "                where 'uad_' ||  u.codigo = current_schema() )   \n"+
                "  AND nom.id =      \n"+
                "              (select id from nomencladores \n"+
                "               where activo = 't' \n"+
                "               and nomenclador_sumar = 't' \n"+
                "               and (pb.fecha_de_la_prestacion BETWEEN fecha_de_inicio and fecha_de_finalizacion\n"+
                "               or  \n"+
                "               (pb.fecha_de_la_prestacion >= fecha_de_inicio and fecha_de_finalizacion is null) )\n"+
                "               limit 1\n"+
                "               )"+
                "  AND pb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') \n"+
                "  AND pr.comunitaria "
          })

        if cq
          puts ("Tabla de prestaciones liquidadas  (sin afiliado) generada")
        else
          puts ("Tabla de prestaciones liquidadas  (sin afiliado) NO generada")
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
                "SELECT '#{l.id}' liquidacion_id, pl.id prestacion_liquidada_id, \n "+
                "       dr.nombre dato_reportable_nombre, ap.precio_por_unidad, dra.valor_integer, dra.valor_big_decimal, dra.valor_date, dra.valor_string, ap.adicional_por_prestacion, \n "+
                "       dr.id dato_reportable_id, drr.id dato_reportable_requerido_id, now(), now()\n "+
                "  FROM prestaciones_incluidas pi \n "+
                "   INNER JOIN prestaciones_liquidadas pl ON ( pl.prestacion_incluida_id = pi.id AND pl.liquidacion_id = #{l.id} )\n "+
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
                "  WHERE pl.estado_de_la_prestacion_id IN (2,3,7)\n "+
                "  AND ef.id in (select ef.id \n" +
                "                from efectores ef \n"+
                "                    join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n"+
                "                where 'uad_' ||  u.codigo = current_schema() )   \n"+
                "  and ap.nomenclador_id =  \n" +
                "              (select id from nomencladores \n"+
                "               where activo = 't' \n"+
                "               and nomenclador_sumar = 't' \n"+
                "               and (pl.fecha_de_la_prestacion BETWEEN fecha_de_inicio and fecha_de_finalizacion\n"+
                "               or  \n"+
                "               (pl.fecha_de_la_prestacion >= fecha_de_inicio and fecha_de_finalizacion is null) )\n"+
                "               limit 1\n"+
                "               )"+
                "  AND pl.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') "
          })
        if cq
          puts ("Tabla de prestaciones Liquidadas datos generada")
        else
          puts ("Tabla de prestaciones Liquidadas datos NO generada")
          return false
        end

        # 4)  Identifico las advertencias que poseen las prestaciones brindadas que se
        #    que se incluyeron en esta liquidacion y genero el snapshoot de las mismas
        cq = CustomQuery.ejecutar ({
          esquemas: esquemas,
          sql:  "INSERT INTO prestaciones_liquidadas_advertencias \n" +
                " (liquidacion_id, prestacion_liquidada_id, metodo_de_validacion_id, comprobacion, mensaje, created_at, updated_at)  \n"+
                "SELECT '#{l.id}', pl.id prestacion_liquidada_id, m.metodo_de_validacion_id, mv.nombre comprobacion, mv.mensaje, now(), now() \n"+
                "FROM metodos_de_validacion_fallados m \n"+
                " INNER JOIN metodos_de_validacion mv ON (mv.id = m.metodo_de_validacion_id )\n"+
                " INNER JOIN prestaciones_liquidadas pl ON  (pl.prestacion_brindada_id = m.prestacion_brindada_id and pl.liquidacion_id = #{l.id} )\n"+
                "WHERE pl.estado_de_la_prestacion_id IN (2,3,7) \n "+
                "AND pl.efector_id in (SELECT ef.id \n" +
                "                      FROM efectores ef \n"+
                "                          INNER JOIN unidades_de_alta_de_datos u ON ef.unidad_de_alta_de_datos_id = u.id \n"+
                "                        WHERE 'uad_' ||  u.codigo = current_schema() )   \n"+
                " AND pl.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') "
          })
        if cq
          puts ("Tabla de prestaciones Liquidadas advertencias generada")
        else
          puts ("Tabla de prestaciones Liquidadas advertencias NO generada")
          return false
        end

        # 5) Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla
        #    de prestaciones liquidadas
        #    - Aca con las prestaciones aceptadas

        formula = "Formula_#{l.parametro_liquidacion_sumar.formula.id}"
        plantilla_de_reglas = (l.plantilla_de_reglas_id.blank?) ? -1 : l.plantilla_de_reglas_id
        estado_aceptada = l.parametro_liquidacion_sumar.prestacion_aceptada.id
        estado_rechazada = l.parametro_liquidacion_sumar.prestacion_rechazada.id
        estado_exceptuada = l.parametro_liquidacion_sumar.prestacion_exceptuada.id

        cq = CustomQuery.ejecutar ({
          sql:  "UPDATE prestaciones_liquidadas   \n"+
                " SET monto = #{formula}(pl.id),   \n"+
                " estado_de_la_prestacion_liquidada_id =  #{estado_aceptada}   \n"+
                "FROM prestaciones_liquidadas pl\n"+
                " LEFT JOIN prestaciones_liquidadas_advertencias pla on pl.id = pla.prestacion_liquidada_id\n"+
                "WHERE pla.id is null\n"+
                "AND pl.liquidacion_id = #{l.id}\n"+
                "AND prestaciones_liquidadas.id = pl.id"
          })

        # 6) Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla
        #    de prestaciones liquidadas
        #    - Aca con las prestaciones rechazadas, con su observacion
        cq = CustomQuery.ejecutar ({
          sql:    "UPDATE public.prestaciones_liquidadas \n"+
                  "            SET monto = #{formula}(pl.id), \n"+
                  "                estado_de_la_prestacion_liquidada_id =  #{estado_rechazada}, \n"+
                  "                observaciones_liquidacion = COALESCE( prestaciones_liquidadas.observaciones_liquidacion, '') || CAST(E'No cumple con la validacion de \"' || pla.comprobacion || E'\" \\n ' \n"+
                  "                                      as text)\n"+
                  "FROM prestaciones_incluidas pi\n"+
                  " join prestaciones_liquidadas pl on pl.prestacion_incluida_id = pi.id\n"+
                  " join prestaciones_liquidadas_advertencias pla on pla.prestacion_liquidada_id = pl.id \n"+
                  " LEFT JOIN (\n"+
                  "             SELECT r.*\n"+
                  "               FROM\n"+
                  "                 reglas r\n"+
                  "                 JOIN plantillas_de_reglas_reglas prr ON (r.id = prr.regla_id)\n"+
                  "                 JOIN plantillas_de_reglas pr ON (pr.id = prr.plantilla_de_reglas_id) \n"+
                  "               WHERE pr.id = #{plantilla_de_reglas}\n"+
                  "             ) SQ1 ON (\n"+
                  "                       sq1.efector_id = pl.efector_id\n"+
                  "                       AND sq1.prestacion_id = pi.prestacion_id\n"+
                  "                       AND sq1.metodo_de_validacion_id = pla.metodo_de_validacion_id \n"+
                  "                      )\n"+
                  "   WHERE permitir IS NULL\n"+
                  "   and pl.liquidacion_id = #{l.id}\n"+
                  " and prestaciones_liquidadas.id = pl.id "
        })

        puts("CQ--------------------------------- #{cq.inspect}")
        # 7) Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla
        #    de prestaciones liquidadas
        #    - Aca con las prestaciones exceptuadas por regla
        cq = CustomQuery.ejecutar ({
          sql:  "UPDATE public.prestaciones_liquidadas \n"+
                "SET monto = #{formula}(pl.id), \n"+
                "    estado_de_la_prestacion_liquidada_id =  #{estado_exceptuada}, \n"+
                "    observaciones_liquidacion = COALESCE( prestaciones_liquidadas.observaciones_liquidacion, '') || CAST(E'No cumple con la validacion de \"' || pla.comprobacion ||E'\" \\n ' \n "+
                "                         ' Aprobada por regla \"'|| regl.nombre || E'\" \\n' ||\n"+
                "                         ' Observaciones: ' || regl.observaciones\n"+
                "                           as text)\n "+
                " from prestaciones_liquidadas_advertencias pla \n "+
                "   join prestaciones_liquidadas pl on pl.id = pla.prestacion_liquidada_id\n "+
                "   join prestaciones_incluidas pi on pi.id = pl.prestacion_incluida_id\n "+
                  "join (\n"+
                "     select r.nombre, r.observaciones, r.prestacion_id, r.metodo_de_validacion_id, pr.id, r.efector_id \n"+
                "    from plantillas_de_reglas pr\n"+
                "    join plantillas_de_reglas_reglas prr on prr.plantilla_de_reglas_id = pr.id\n"+
                "    join reglas r on (\n"+
                "    r.id = prr.regla_id\n"+
                "    and r.permitir = 't' )\n"+
                "    where pr.id = #{l.plantilla_de_reglas_id} \n" +
                "    ) as regl\n"+
                "    on\n"+
                "    ( regl.prestacion_id = pi.prestacion_id\n"+
                "    and regl.metodo_de_validacion_id = pla.metodo_de_validacion_id\n"+
                "    and regl.efector_id = pl.efector_id\n"+
                "    ) \n"+
                "where pl.liquidacion_id = #{l.id}\n "+
                " and pl.estado_de_la_prestacion_liquidada_id is NULL \n"+
                " and prestaciones_liquidadas.id = pl.id "

         })

        ####################################################################################
        #GENERO LAS CUASIFACTURAS PARA LOS EFECTORES INDICADOS
        estado_rechazada = l.parametro_liquidacion_sumar.prestacion_rechazada.id
        estado_aceptada  = l.parametro_liquidacion_sumar.prestacion_aceptada.id

        # 1) Genero las cabeceras
        cq = CustomQuery.ejecutar ({
          sql:  "INSERT INTO public.liquidaciones_sumar_cuasifacturas  \n"+
                "(liquidacion_sumar_id, efector_id, monto_total, created_at, updated_at)  \n"+
                "select liquidacion_id, efector_id, sum(monto), now(), now() \n"+
                "from prestaciones_liquidadas \n"+
                "where prestaciones_liquidadas.liquidacion_id = #{l.id} \n"+
                "and prestaciones_liquidadas.efector_id in (#{efectores.join(", ")})\n" +
                "and   estado_de_la_prestacion_liquidada_id != #{estado_rechazada} \n"+
                "group by liquidacion_id, efector_id"
                      })
        if cq
          puts ("Tabla de cuasifacturas generada")
        else
          puts ("Tabla de cuasifacturas NO generada")
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
                "where p.liquidacion_id = #{l.id} \n"+
                "and p.efector_id in (#{efectores.join(", ")})\n "+
                "and   p.estado_de_la_prestacion_liquidada_id != #{estado_rechazada}"
          })

        if cq
          puts ("Tabla de detalle de cuasifacturas generada")
        else
          puts ("Tabla de detalle de cuasifacturas NO generada")
          return false
        end


        # 3) Actualiza las prestaciones brindadas para que no sean modificadas

        estado_exceptuada = l.parametro_liquidacion_sumar.prestacion_exceptuada.id
        estados_aceptados = [estado_aceptada, estado_exceptuada].join(", ")

        cq = CustomQuery.ejecutar ({
          esquemas: esquemas,
          sql:  "update prestaciones_brindadas \n "+
                "   set estado_de_la_prestacion_id = #{estado_aceptada} \n "+
                "from prestaciones_liquidadas p \n "+
                "    join liquidaciones_sumar_cuasifacturas lsc on (lsc.liquidacion_sumar_id = p.liquidacion_id and lsc.efector_id = p.efector_id ) \n "+
                "where p.liquidacion_id = #{l.id} \n "+
                "and   p.estado_de_la_prestacion_liquidada_id in ( #{estados_aceptados} )\n "+
                "and p.efector_id in (select ef.id \n "+
                "                                      from efectores ef \n "+
                "                                         join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n "+
                "                                      where 'uad_' ||  u.codigo = current_schema() )\n "+
                "and prestaciones_brindadas.id = p.prestacion_brindada_id"
          })
        if cq
          puts ("Tabla prestaciones brindadas actualizada")
        else
          puts ("Tabla prestaciones brindadas NO actualizada")
          return false
        end

        # 4) Creo los informes de liquidacion
        if LiquidacionInforme.generar_informes_de_liquidacion(l)
          puts  ("Informes de liquidacion generados")
        else
          puts  ("Informes de liquidacion NO generados")
        end

        # 5 ) Genero los consolidados para quienes correspondan.
        if ConsolidadoSumar.generar_consolidados l
          puts  ("Consolidados de efectores generados")
        else
          puts  ("Consolidados de efectores NO generados")
        end
        
        end #end each efector
      end #end each
    end #end transaction
  end #end function
  
end #end class
