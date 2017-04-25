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
    begin
      puts "Ejecutando proceso de revertir factura"    
      liquidacion_sumar = LiquidacionSumar.find(arg_liquidacion)
      efector = Efector.find(args_arr_efectores[0])
      puts "LiquidacionSumarId #{liquidacion_sumar.id}"
      puts "Efector #{efector.id}"

      ActiveRecord::Base.transaction do
        cuasi_facturas = LiquidacionSumarCuasifactura.where(liquidacion_sumar_id: liquidacion_sumar.id, efector_id: efector.id)
        # Reveer no iria esto si es por un solo efector
        efectores =  liquidacion_sumar.grupo_de_efectores_liquidacion.efectores.where(id: efector.id).collect {|ef| ef.id}
        esquemas = UnidadDeAltaDeDatos.joins(:efectores).merge(Efector.where(id: efectores))
      
        # 1) Actualiza las prestaciones brindadas para que no sean modificadas
        cq = CustomQuery.ejecutar ({
          esquemas: esquemas,
          sql:  "update prestaciones_brindadas \n "+
                "   set estado_de_la_prestacion_id = p.estado_de_la_prestacion_id \n "+
                "from prestaciones_liquidadas p \n "+
                "    join liquidaciones_sumar_cuasifacturas lsc on (lsc.liquidacion_sumar_id = p.liquidacion_id and lsc.efector_id = p.efector_id ) \n "+
                "where p.liquidacion_id = #{liquidacion_sumar.id} \n "+
                "and p.efector_id in (select ef.id \n "+
                "                                      from efectores ef \n "+
                "                                         join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n "+
                "                                      where 'uad_' ||  u.codigo = current_schema() )\n "+
                "and prestaciones_brindadas.id = p.prestacion_brindada_id"
        })
      
        # Volver hacia atrás las secuencias
        cuasi_facturas = LiquidacionSumarCuasifactura.where(liquidacion_sumar_id: liquidacion_sumar.id, efector_id: efector.id)
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

        # Borro los informes de liquidacion
        # 1) Obtengo los ids de anexos
        
        li = LiquidacionInforme.where(efector_id: efector.id, liquidacion_sumar_id: liquidacion_sumar.id).first
        if li.present? and  li.liquidacion_sumar_anexo_administrativo.present?

          aa_id = li.liquidacion_sumar_anexo_administrativo.id
          am_id = li.liquidacion_sumar_anexo_medico.id


          ActiveRecord::Base.connection.execute "delete \n"+
          "from anexos_administrativos_prestaciones\n"+
          "where id in (\n"+
          "   select aap.id\n"+
          "   from liquidaciones_informes li\n"+
          "    left join liquidaciones_sumar_anexos_administrativos aa on aa.id = li.liquidacion_sumar_anexo_administrativo_id\n"+
          "    left join anexos_administrativos_prestaciones aap on aap.liquidacion_sumar_anexo_administrativo_id = aa.id\n"+
          "   where li.efector_id = #{efector.id}\n"+
          "   and li.liquidacion_sumar_id = #{liquidacion_sumar.id}\n"+
          ")\n"+
          ";\n"+
          "delete \n"+
          "from anexos_medicos_prestaciones \n"+
          "where id in (\n"+
          "   select amp.id\n"+
          "   from liquidaciones_informes li\n"+
          "    left join liquidaciones_sumar_anexos_medicos am on am.id = li.liquidacion_sumar_anexo_medico_id\n"+
          "    left join anexos_medicos_prestaciones amp on amp.liquidacion_sumar_anexo_medico_id = am.id\n"+
          "   where li.efector_id = #{efector.id}\n"+
          "   and li.liquidacion_sumar_id = #{liquidacion_sumar.id}\n"+
          ")\n"+
          ";\n"

          ActiveRecord::Base.connection.execute "DELETE\n"+
          "from liquidaciones_informes\n"+
          "where efector_id = #{efector.id}\n"+
          "and liquidacion_sumar_id = #{liquidacion_sumar.id}\n"+
          ";\n"

          ActiveRecord::Base.connection.execute "delete\n"+
          "from liquidaciones_sumar_anexos_administrativos \n"+
          "where id = #{aa_id} \n"+
          ";\n"+
          "delete\n"+
          "from liquidaciones_sumar_anexos_medicos\n"+
          "where id = #{am_id}\n"+
          ";"
        elsif li.present?
          ActiveRecord::Base.connection.execute "DELETE\n"+
          "from liquidaciones_informes\n"+
          "where efector_id = #{efector.id}\n"+
          "and liquidacion_sumar_id = #{liquidacion_sumar.id}\n"+
          ";\n"
        end

        # Elimino las cuasifacturas
        cuasi_facturas.each do |cf|
          cf.liquidaciones_sumar_cuasifacturas_detalles.destroy_all
          cf.destroy
        end

        # Una vez eliminada la cuasifactura vacio la liquidación para ese efector
        ActiveRecord::Base.connection.execute "
                  SET session_replication_role = replica;
                  delete \n"+
                  "from prestaciones_liquidadas_advertencias\n"+
                  "where prestacion_liquidada_id in ( select id from prestaciones_liquidadas where liquidacion_id = #{liquidacion_sumar.id} and efector_id in (#{efector.id} ) )  ;\n"+

                  "delete \n"+
                  "from prestaciones_liquidadas_datos\n"+
                  "where prestacion_liquidada_id in  ( select id from prestaciones_liquidadas where liquidacion_id = #{liquidacion_sumar.id} and efector_id in (#{efector.id} ) )  \n"+
                  ";\n"+
                  "DELETE\n"+
                  "from  prestaciones_liquidadas\n"+
                  "where liquidacion_id = #{liquidacion_sumar.id} and efector_id in (#{efector.id}) \n"+
                  ";\n"+
                  "SET session_replication_role = DEFAULT;"

        # Genero la liquidación nuevamente
        vigencia_perstaciones = liquidacion_sumar.periodo.dias_de_prestacion
        fecha_de_recepcion = liquidacion_sumar.periodo.fecha_recepcion.to_s
        fecha_limite_prestaciones = liquidacion_sumar.periodo.fecha_limite_prestaciones.to_s

        ActiveRecord::Base.transaction do 

          # Busco y marco prestaciones vencidas al momento de liquidar
          #PrestacionBrindada.marcar_prestaciones_vencidas liquidacion_sumar
          #PrestacionBrindada.marcar_prestaciones_sin_periodo_de_actividad liquidacion_sumar
          #PrestacionBrindada.marcar_prestaciones_sin_asignacion_de_precio liquidacion_sumar
          
          # 0 ) Elimino los duplicados
          #PrestacionBrindada.anular_prestaciones_duplicadas

          # 1) Identifico los TIPOS de prestaciones que se brindaron en esta liquidacion y genero el snapshoot de las mismas
          cq = CustomQuery.ejecutar (
            {
              sql:  "INSERT INTO public.prestaciones_incluidas\n"+
                    "( liquidacion_id, \n"+
                    "  nomenclador_id, nomenclador_nombre, \n"+
                    "  prestacion_id, prestacion_nombre, prestacion_codigo, \n"+
                    "  prestacion_cobertura, prestacion_comunitaria, prestacion_requiere_hc, prestacion_concepto_nombre, created_at, updated_at) \n"+
                    "SELECT DISTINCT ON (nom.id, pr.id) \n"+
                    "                #{liquidacion_sumar.id}, \n"+
                    "                nom.id as nomenclador_id, nom.nombre as nomenclador_nombre,\n"+
                    "                pr.id as prestacion_id, pr.nombre, pr.codigo as prestacion_codigo,\n"+
                    "                pr.otorga_cobertura as prestacion_cobertura, pr.comunitaria as prestacion_comunitaria, pr.requiere_historia_clinica as prestacion_requiere_hc,\n"+
                    "                cdf.concepto as prestacion_concepto_nombre,now(), now()\n"+
                    "FROM vista_global_de_prestaciones_brindadas vpb\n"+
                    "  INNER JOIN prestaciones pr ON ( pr.id = vpb.prestacion_id ) \n"+
                    "  INNER JOIN conceptos_de_facturacion cdf on (cdf.id = pr.concepto_de_facturacion_id)\n"+
                    "  INNER JOIN efectores ef ON (ef.id = vpb.efector_id)\n"+
                    "  INNER JOIN asignaciones_de_precios ap ON ( ap.prestacion_id = vpb.prestacion_id AND ap.area_de_prestacion_id = ef.area_de_prestacion_id )\n"+
                    "  INNER JOIN nomencladores nom  ON ( nom.id = ap.nomenclador_id )\n"+
                    "  LEFT JOIN  afiliados af ON (af.clave_de_beneficiario = vpb.clave_de_beneficiario)\n"+
                    "  LEFT JOIN  periodos_de_actividad pa ON (pa.afiliado_id  = af.afiliado_id )\n"+
                    "WHERE vpb.estado_de_la_prestacion_id IN (2,3,7) \n"+
                    " AND (vpb.estado_de_la_prestacion_liquidada_id is null or vpb.estado_de_la_prestacion_liquidada_id != 14) \n "+
                    " AND cdf.id = #{liquidacion_sumar.concepto_de_facturacion.id}    \n"+
                    " AND ef.id in ( #{efectores.join(", ")} )\n"+
                    " AND nom.id =    \n"+
                    "             ( select id from nomencladores \n"+
                    "               where activo = 't' \n"+
                    "               and nomenclador_sumar = 't' \n"+
                    "               and (vpb.fecha_de_la_prestacion BETWEEN fecha_de_inicio and fecha_de_finalizacion\n"+
                    "               or  \n"+
                    "               (vpb.fecha_de_la_prestacion >= fecha_de_inicio and fecha_de_finalizacion is null) )\n"+
                    "               limit 1\n"+
                    "             )\n"+
                    " AND vpb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd')\n"+
                    " AND ( CASE WHEN vpb.clave_de_beneficiario is not  null THEN \n"+
                    "                 (vpb.fecha_de_la_prestacion >= pa.fecha_de_inicio and pa.fecha_de_finalizacion is null )\n"+
                    "                 OR\n"+
                    "                 (vpb.fecha_de_la_prestacion between pa.fecha_de_inicio and pa.fecha_de_finalizacion )\n"+
                    "            WHEN vpb.clave_de_beneficiario is null then TRUE\n"+
                    "       END\n"+
                    "     )\n"+
                    " AND pr.id not in (select prestacion_id from prestaciones_incluidas where liquidacion_id = #{liquidacion_sumar.id} )"
          })

          # 2) Identifico las prestaciones que se brindaron en esta liquidacion y genero el snapshoot de las mismas 
          cq = CustomQuery.ejecutar ({
            sql:  "INSERT INTO public.prestaciones_liquidadas \n "+
                  "       (liquidacion_id, esquema, unidad_de_alta_de_datos_id, efector_id, \n "+
                  "        prestacion_incluida_id, fecha_de_la_prestacion, \n "+
                  "        estado_de_la_prestacion_id, historia_clinica, es_catastrofica, \n "+
                  "        diagnostico_id, diagnostico_nombre, \n "+
                  "        cantidad_de_unidades, observaciones, \n "+
                  "        clave_de_beneficiario, codigo_area_prestacion, nombre_area_de_prestacion, prestacion_brindada_id, \n "+
                  "        created_at, updated_at) \n "+
                  "SELECT DISTINCT #{liquidacion_sumar.id} liquidacion_id, vpb.esquema, ef.unidad_de_alta_de_datos_id as unidad_de_alta_de_datos_id, ef.id,\n"+
                  "                 pi.id as prestacion_incluida_id, vpb.fecha_de_la_prestacion,\n"+
                  "                 vpb.estado_de_la_prestacion_id, vpb.historia_clinica, vpb.es_catastrofica, \n"+
                  "                 vpb.diagnostico_id, diag.nombre diagnostico_nombre,\n"+
                  "                 vpb.cantidad_de_unidades, vpb.observaciones,\n"+
                  "                 af.clave_de_beneficiario, areas.codigo codigo_area_prestacion, areas.nombre nombre_area_de_prestacion, vpb.id prestacion_brindada_id, \n"+
                  "                 now(), now()\n"+
                  "FROM vista_global_de_prestaciones_brindadas vpb\n"+
                  "  INNER JOIN prestaciones pr ON (pr.id = vpb.prestacion_id) \n"+
                  "  INNER JOIN prestaciones_incluidas pi ON (vpb.prestacion_id = pi.prestacion_id AND pi.liquidacion_id = #{liquidacion_sumar.id} )\n"+
                  "  INNER JOIN diagnosticos diag ON (diag.id = vpb.diagnostico_id)\n"+
                  "  LEFT JOIN     afiliados af ON (af.clave_de_beneficiario = vpb.clave_de_beneficiario) \n"+
                  "  LEFT JOIN     periodos_de_actividad pa ON (af.afiliado_id = pa.afiliado_id ) --solo los afiliados que tenga algun periodo de actividad\n"+
                  "  INNER JOIN efectores ef ON (ef.id = vpb.efector_id) \n"+
                  "  INNER JOIN asignaciones_de_precios ap  \n"+
                  "             ON (\n"+
                  "                  ap.prestacion_id = vpb.prestacion_id\n"+
                  "                  AND ap.area_de_prestacion_id = ef.area_de_prestacion_id\n"+
                  "                )\n"+
                  "  INNER JOIN areas_de_prestacion areas on ap.area_de_prestacion_id = areas.id \n"+
                  "  INNER JOIN nomencladores nom ON ( nom.id = ap.nomenclador_id ) \n"+
                  "WHERE vpb.estado_de_la_prestacion_id IN (2,3,7)\n"+
                  " AND (vpb.estado_de_la_prestacion_liquidada_id is null or vpb.estado_de_la_prestacion_liquidada_id != 14) \n "+
                  "  AND ef.id in ( #{efectores.join(", ")} )\n"+
                  "  AND nom.id =      \n"+
                  "              (select id from nomencladores \n"+
                  "               where activo = 't' \n"+
                  "                and nomenclador_sumar = 't' \n"+
                  "                and ( vpb.fecha_de_la_prestacion BETWEEN fecha_de_inicio and fecha_de_finalizacion\n"+
                  "                      or  \n"+
                  "                      (vpb.fecha_de_la_prestacion >= fecha_de_inicio and fecha_de_finalizacion is null) )\n"+
                  "               limit 1\n"+
                  "              )\n"+
                  "  AND vpb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') \n"+
                  "  AND ( CASE WHEN vpb.clave_de_beneficiario IS NOT NULL THEN \n"+
                  "                  (vpb.fecha_de_la_prestacion >= pa.fecha_de_inicio and pa.fecha_de_finalizacion is null )\n"+
                  "                    OR\n"+
                  "                  (vpb.fecha_de_la_prestacion between pa.fecha_de_inicio and pa.fecha_de_finalizacion )\n"+
                  "             WHEN vpb.clave_de_beneficiario is null then TRUE\n"+
                  "        END\n"+
                  "      ) \n"+
                  "  AND pi.nomenclador_id = nom.id "
            })

          if cq
            puts "Tabla de prestaciones liquidadas generada"
          else
            puts "Tabla de prestaciones liquidadas NO generada"
          end

          # 3)  Identifico los datos vinculados a las prestaciones brindadas
          #    que se incluyeron en esta liquidacion y genero el snapshoot de las mismas
          
          cq = CustomQuery.ejecutar ({
            sql:  "INSERT INTO prestaciones_liquidadas_datos \n "+
                  " (liquidacion_id, prestacion_liquidada_id, \n "+
                  "  dato_reportable_nombre, precio_por_unidad, valor_integer, valor_big_decimal, valor_date, valor_string, adicional_por_prestacion, \n "+
                  "   dato_reportable_id, dato_reportable_requerido_id, created_at, updated_at) \n "+
                  "SELECT '#{liquidacion_sumar.id}' liquidacion_id, pl.id prestacion_liquidada_id, \n"+
                  "        dr.nombre dato_reportable_nombre, ap.precio_por_unidad, dra.valor_integer, dra.valor_big_decimal, dra.valor_date, dra.valor_string, ap.adicional_por_prestacion, \n"+
                  "        dr.id dato_reportable_id, drr.id dato_reportable_requerido_id, now(), now()\n"+
                  "FROM prestaciones_incluidas pi \n"+
                  "  INNER JOIN prestaciones_liquidadas pl ON ( pl.prestacion_incluida_id = pi.id AND pl.liquidacion_id = #{liquidacion_sumar.id} )\n"+
                  "  INNER JOIN efectores ef ON (ef.id = pl.efector_id) -- Este join es para obtener el ID y el área de prestación del efector\n"+
                  "  INNER JOIN asignaciones_de_precios ap  -- Este join trae los datos de la asignación de precios correspondiente al área de prestación del efector\n"+
                  "             ON (\n"+
                  "                 ap.prestacion_id = pi.prestacion_id\n"+
                  "                 AND ap.area_de_prestacion_id = ef.area_de_prestacion_id --si el efector esta tipificado como rural y cargo una prestacion urbana, esta se excluye.\n"+
                  "                 )\n"+
                  "  INNER JOIN nomencladores nom ON ( nom.id = ap.nomenclador_id ) -- Este join selecciona únicamente las AP correspondientes al nomenclador activo en el momento de la prestación\n"+
                  "  LEFT JOIN (  -- Este join añade la información de los datos reportables asociados a las AP que los requieren (para obtener las cantidades)\n"+
                  "              vista_global_de_datos_reportables_asociados dra\n"+
                  "                INNER JOIN datos_reportables_requeridos drr ON (drr.id = dra.dato_reportable_requerido_id)\n"+
                  "                INNER JOIN datos_reportables dr ON (drr.dato_reportable_id = dr.id) \n"+
                  "            )\n"+
                  "            ON (\n"+
                  "                 dra.prestacion_brindada_id = pl.prestacion_brindada_id \n"+
                  "                 AND pl.esquema = dra.esquema\n"+
                  "                 AND ap.dato_reportable_id = drr.dato_reportable_id\n"+
                  "                )\n"+
                  "WHERE pl.estado_de_la_prestacion_id IN (2,3,7)\n"+
                  "AND ef.id in ( #{efectores.join(", ")} )\n"+
                  "AND ap.nomenclador_id =  \n"+
                  "                       (select id from nomencladores \n"+
                  "                        where activo = 't' \n"+
                  "                        and nomenclador_sumar = 't' \n"+
                  "                        and (pl.fecha_de_la_prestacion BETWEEN fecha_de_inicio and fecha_de_finalizacion\n"+
                  "                        or  \n"+
                  "                        (pl.fecha_de_la_prestacion >= fecha_de_inicio and fecha_de_finalizacion is null) )\n"+
                  "                        limit 1\n"+
                  "                        )\n"+
                  "AND pl.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') \n"+
                  "AND pi.nomenclador_id = nom.id "

          })
          if cq
            puts "Tabla de prestaciones Liquidadas datos generada"
          else
            puts "Tabla de prestaciones Liquidadas datos NO generada"
          end

          # 4)  Identifico las advertencias que poseen las prestaciones brindadas que se
          #    que se incluyeron en esta liquidacion y genero el snapshoot de las mismas
          cq = CustomQuery.ejecutar ({
            sql:  "INSERT INTO prestaciones_liquidadas_advertencias \n" +
                  " (liquidacion_id, prestacion_liquidada_id, metodo_de_validacion_id, comprobacion, mensaje, created_at, updated_at)  \n"+
                  "SELECT '#{liquidacion_sumar.id}', pl.id prestacion_liquidada_id, m.metodo_de_validacion_id, mv.nombre comprobacion, mv.mensaje, now(), now() \n"+
                  "FROM vista_global_de_metodos_de_validacion_fallados m \n"+
                  " INNER JOIN metodos_de_validacion mv ON (mv.id = m.metodo_de_validacion_id )\n"+
                  " INNER JOIN prestaciones_liquidadas pl ON  (pl.prestacion_brindada_id = m.prestacion_brindada_id \n"+
                  "                                            AND pl.esquema = m.esquema\n"+
                  "                                            AND pl.liquidacion_id = #{liquidacion_sumar.id} )\n"+
                  "WHERE pl.estado_de_la_prestacion_id IN (2,3,7) \n "+
                  " AND pl.efector_id in ( #{efectores.join(", ")} )\n"+
                  " AND pl.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') "
            })
          if cq
            puts "Tabla de prestaciones Liquidadas advertencias generada"
          else
            puts "Tabla de prestaciones Liquidadas advertencias NO generada"
          end

          # 5) Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla
          #    de prestaciones liquidadas
          #    - Aca con las prestaciones aceptadas

          formula = "Formula_#{liquidacion_sumar.concepto_de_facturacion.formula.id}"
          plantilla_de_reglas = (liquidacion_sumar.plantilla_de_reglas_id.blank?) ? -1 : liquidacion_sumar.plantilla_de_reglas_id
          estado_aceptada = liquidacion_sumar.parametro_liquidacion_sumar.prestacion_aceptada.id
          estado_rechazada = liquidacion_sumar.parametro_liquidacion_sumar.prestacion_rechazada.id
          estado_exceptuada = liquidacion_sumar.parametro_liquidacion_sumar.prestacion_exceptuada.id

          cq = CustomQuery.ejecutar ({
            sql:  "UPDATE prestaciones_liquidadas   \n"+
                  " SET monto = #{formula}(pl.id),   \n"+
                  " estado_de_la_prestacion_liquidada_id =  #{estado_aceptada}   \n"+
                  "FROM prestaciones_liquidadas pl\n"+
                  " LEFT JOIN prestaciones_liquidadas_advertencias pla on pl.id = pla.prestacion_liquidada_id\n"+
                  "WHERE pla.id is null\n"+
                  "AND pl.liquidacion_id = #{liquidacion_sumar.id}\n"+
                  "AND prestaciones_liquidadas.id = pl.id\n"+
                  "AND pl.efector_id in ( #{efectores.join(", ")} )\n"
            })

          if cq
            puts "Tabla de prestaciones Liquidadas Actualizada con ACEPTADAS"
          else
            puts "Tabla de prestaciones Liquidadas NO Actualizada con ACEPTADAS"
          end

          # 6) Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla
          #    de prestaciones liquidadas
          #    - Aca con las prestaciones rechazadas, con su observacion
          cq = CustomQuery.ejecutar ({
            sql:    "UPDATE public.prestaciones_liquidadas \n"+
                    "            SET monto = #{formula}(pl.id), \n"+
                    "                estado_de_la_prestacion_liquidada_id =  #{estado_rechazada}, \n"+
                    "                observaciones_liquidacion = COALESCE( prestaciones_liquidadas.observaciones_liquidacion, '') || 'No cumple con la validacion de \"' || pla.comprobacion || '\" al periodo #{liquidacion_sumar.periodo.periodo} ;' \n"+
                    "FROM prestaciones_incluidas pi\n"+
                    " JOIN prestaciones_liquidadas pl on pl.prestacion_incluida_id = pi.id\n"+
                    " JOIN prestaciones_liquidadas_advertencias pla on pla.prestacion_liquidada_id = pl.id \n"+
                    " LEFT JOIN (\n"+
                    "             SELECT r.*\n"+
                    "               FROM\n"+
                    "                 reglas r\n"+
                    "                 JOIN plantillas_de_reglas_reglas prr ON (r.id = prr.regla_id)\n"+
                    "                 JOIN plantillas_de_reglas pr ON (pr.id = prr.plantilla_de_reglas_id) \n"+
                    "               WHERE pr.id = #{plantilla_de_reglas}\n"+
                    "             ) sq1 ON (\n"+
                    "                       sq1.efector_id = pl.efector_id\n"+
                    "                       AND sq1.prestacion_id = pi.prestacion_id\n"+
                    "                       AND sq1.metodo_de_validacion_id = pla.metodo_de_validacion_id \n"+
                    "                      )\n"+
                    "   WHERE permitir IS NULL\n"+
                    "   AND pl.liquidacion_id = #{liquidacion_sumar.id}\n"+
                    " AND prestaciones_liquidadas.id = pl.id\n "+
                    " AND pl.efector_id in ( #{efectores.join(", ")} )\n"
          })

          if cq
            puts "Tabla de prestaciones Liquidadas Actualizada con RECHAZADAS"
          else
            puts "Tabla de prestaciones Liquidadas NO Actualizada con RECHAZADAS"
          end

          # 7) Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla
          #    de prestaciones liquidadas
          #    - Aca con las prestaciones exceptuadas por regla
          cq = CustomQuery.ejecutar ({
            sql:  "UPDATE public.prestaciones_liquidadas \n"+
                  "SET monto = #{formula}(pl.id), \n"+
                  "    estado_de_la_prestacion_liquidada_id =  #{estado_exceptuada}, \n"+
                  "    observaciones_liquidacion = COALESCE( prestaciones_liquidadas.observaciones_liquidacion, '') || 'No cumple con la validacion de \"' || pla.comprobacion ||'\".' \n "+
                  "                         ' Aprobada por regla \"'|| regl.nombre || '\"' ||\n"+
                  "                         ' Observaciones: ' || COALESCE(regl.observaciones, '')||\n"+
                  "                         ';' \n "+
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
                  "    where pr.id = #{plantilla_de_reglas} \n" +
                  "    ) as regl\n"+
                  "    on\n"+
                  "    ( regl.prestacion_id = pi.prestacion_id\n"+
                  "    and regl.metodo_de_validacion_id = pla.metodo_de_validacion_id\n"+
                  "    and regl.efector_id = pl.efector_id\n"+
                  "    ) \n"+
                  "where pl.liquidacion_id = #{liquidacion_sumar.id}\n "+
                  " and pl.estado_de_la_prestacion_liquidada_id is NULL \n"+
                  " and prestaciones_liquidadas.id = pl.id \n"+
                  " AND pl.efector_id in ( #{efectores.join(", ")} )\n"


           })
          if cq
            puts "Tabla de prestaciones Liquidadas Actualizada con EXCEPTUADAS"
          else
            puts "Tabla de prestaciones Liquidadas NO Actualizada con EXCEPTUADAS"
          end
        end # END transaction


        ####################################################################################
        #GENERO LAS CUASIFACTURAS PARA LOS EFECTORES INDICADOS
        
        pliquidadas = liquidacion_sumar.prestaciones_liquidadas.where(efector_id: efector.id)
        # 1) Creo la cabecera de la cuasifactura
        total_cuasifactura = pliquidadas.sum(:monto).to_f
        
        # Si el monto de la cuasi es cero, sigo con el prox efector
        next if total_cuasifactura == 0
        cuasifactura = LiquidacionSumarCuasifactura.create!( liquidacion_sumar: liquidacion_sumar, 
                                                            efector: efector, 
                                                            monto_total: total_cuasifactura, 
                                                            concepto_de_facturacion: liquidacion_sumar.concepto_de_facturacion)
        
        # 2) Obtengo el numero de cuasifactura si corresponde para este tipo de documento
        documento_generable = liquidacion_sumar.concepto_de_facturacion.documentos_generables_por_conceptos.where(documento_generable_id: 1).first

        cuasifactura.numero_cuasifactura = documento_generable.obtener_numeracion(cuasifactura.id) + " - R"
        cuasifactura.save!(validate: false)

        # 3) Creo el detalle para esta cuasifactura
        ActiveRecord::Base.connection.execute "--Creo el detalle para esta cuasifactura\n"+
          "INSERT INTO public.liquidaciones_sumar_cuasifacturas_detalles  \n"+
           "(liquidaciones_sumar_cuasifacturas_id, prestacion_incluida_id, estado_de_la_prestacion_id, monto, prestacion_liquidada_id, observaciones, created_at, updated_at)  \n"+
           pliquidadas.select(["#{cuasifactura.id}", :prestacion_incluida_id, :estado_de_la_prestacion_liquidada_id, :monto, :id, :observaciones, "now() as created_at", "now() as updated_at"]).to_sql

        # 3) Actualiza las prestaciones brindadas para que no sean modificadas

        estado_aceptada = liquidacion_sumar.parametro_liquidacion_sumar.prestacion_aceptada.id
        estado_rechazada = liquidacion_sumar.parametro_liquidacion_sumar.prestacion_rechazada.id
        estado_exceptuada = liquidacion_sumar.parametro_liquidacion_sumar.prestacion_exceptuada.id
        estados_aceptados = [estado_aceptada, estado_exceptuada].join(", ")

        cq = CustomQuery.ejecutar ({
          esquemas: esquemas,
          sql:  "update prestaciones_brindadas \n "+
                "   set estado_de_la_prestacion_id = #{estado_aceptada} \n "+
                "from prestaciones_liquidadas p \n "+
                "    join liquidaciones_sumar_cuasifacturas lsc on (lsc.liquidacion_sumar_id = p.liquidacion_id and lsc.efector_id = p.efector_id ) \n "+
                "where p.liquidacion_id = #{liquidacion_sumar.id} \n "+
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
        cq = CustomQuery.ejecutar(
        {
        sql:  "INSERT INTO \"public\".\"liquidaciones_informes\" \n"+
              "( \"efector_id\", \"liquidacion_sumar_id\", \"liquidacion_sumar_cuasifactura_id\", \"estado_del_proceso_id\", \"created_at\", \"updated_at\") \n"+
              "SELECT\n"+
              " lc.efector_id, ls.id liquidacion_sumar_id, lc.id iquidacion_sumar_cuasifactura_id, ( SELECT ID FROM estados_de_los_procesos WHERE codigo = 'N'  ) estado_del_proceso_id,  now(),  now()\n"+
              "FROM\n"+
              " liquidaciones_sumar ls\n"+
              "JOIN liquidaciones_sumar_cuasifacturas lc ON lc.liquidacion_sumar_id = ls.ID\n"+
              "JOIN grupos_de_efectores_liquidaciones g ON g.id = ls.grupo_de_efectores_liquidacion_id\n"+
              "JOIN efectores e ON e.grupo_de_efectores_liquidacion_id = g.id AND lc.efector_id = e.ID\n"+
              "where ls.id = #{liquidacion_sumar.id}\n"+
              "and lc.efector_id = #{efector.id}"
        })

        # 5 ) Genero los consolidados para quienes correspondan.

          # Busco el administrador
          if efector.es_administrado? 
            administrador = efector.administrador_sumar
          elsif efector.es_autoadministrado?
            next
          else 
            administrador = efector
          end

          
          # Verifico que no haya generado anteriormente el consolidado de este efector administrador
          c = ConsolidadoSumar.where(efector_id: administrador.id, liquidacion_sumar_id: liquidacion_sumar.id)
          
          case c.size
          
          when 0 #No existe un consolidado para este efector administrador y esta liquidación
            referente = administrador.referentes.where(["(fecha_de_inicio <= ? and fecha_de_finalizacion is null) or ? between fecha_de_inicio and fecha_de_finalizacion",
                                                    liquidacion_sumar.periodo.fecha_cierre,
                                                    liquidacion_sumar.periodo.fecha_cierre
                                                    ]).first
            
            # TODO: ahora le pongo null pero no deberia poder guardar el convenio si no existe el firmante. 
            firmante_id = referente.blank? ? nil : referente.contacto.id 

            # Genero el detalle y cabecera si la suma de las cuasifacturas de los administrados es mayor a cero
            total_consolidado = 0
            
            total_cuasifactura_administrador = 0
            if administrador.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).size > 0
              total_cuasifactura_administrador += administrador.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).first.monto_total
            end

            total_cuasifactura_administrados = 0
            administrador.efectores_administrados.each do |ea|
              if ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).size > 0
                total_cuasifactura_administrados += ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).first.monto_total
              end
            end

            total_consolidado = total_cuasifactura_administrador + total_cuasifactura_administrados
           
            # Si el administrador ha facturado pero ningun administrado lo ha hecho, solo creo la cabecera
            if total_consolidado > 0
              #Verifico que exista la secuencia para los consolidados. Sino que la cree
              #self.generar_secuencia administrador
              puts "self.generar_secuencia_administrador [NO SE EJECUTA] revisar."

              consolidado = ConsolidadoSumar.create!({
                fecha: Date.today,
                efector_id: administrador.id,
                firmante_id: firmante_id,
                periodo_id: liquidacion_sumar.periodo.id,
                liquidacion_sumar_id: liquidacion_sumar.id
              })
              consolidado.numero_de_consolidado = documento_generable.obtener_numeracion(consolidado.id)
              consolidado.save
                          
              # Genero el detalle del consolidado
              administrador.efectores_administrados.each do |ea|
                
                # Verifico si existe una cuasifactura para este efector
                if ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).size > 0
                  monto = ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).first.monto_total
                else
                  monto = 0
                end
                
                cq = CustomQuery.ejecutar({
                  sql:  "INSERT INTO  public . consolidados_sumar_detalles  \n"+
                        "( consolidado_sumar_id ,  efector_id ,  convenio_de_administracion_sumar_id ,  convenio_de_gestion_sumar_id ,  total ,  created_at ,  updated_at ) \n"+
                        "VALUES \n"+
                        "(#{consolidado.id}, #{ea.id}, #{ea.convenio_de_administracion_sumar.id}, #{ea.convenio_de_gestion_sumar.id}, #{monto}, now(), now());"
                })
                if cq
                else
                end
              end
            end

          when 1 # Ya existe el consolidado. Regenera el detalle y el actualiza el firmante
            referente = administrador.referentes.where(["(fecha_de_inicio <= ? and fecha_de_finalizacion is null) or ? between fecha_de_inicio and fecha_de_finalizacion",
                                                    liquidacion_sumar.periodo.fecha_cierre,
                                                    liquidacion_sumar.periodo.fecha_cierre
                                                    ]).first

            # TODO: ahora le pongo null pero no deberia poder guardar el convenio si no existe el firmante. 
            firmante_id = referente.blank? ? nil : referente.contacto.id 

            c_id = c.first.id
            begin
              ActiveRecord::Base.transaction do

                c.first.update_attributes(firmante_id: firmante_id)
                cq = CustomQuery.ejecutar({
                  sql:  "DELETE \n"+
                        "FROM consolidados_sumar_detalles\n"+
                        "WHERE consolidado_sumar_id =  #{c_id};\n"
                })

                administrador.efectores_administrados.each do |ea|
                  # Verifico si existe una cuasifactura para este efector
                  if ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).size > 0
                    monto = ea.cuasifacturas.where(liquidacion_sumar_id: liquidacion_sumar.id).first.monto_total
                  else
                    monto = 0
                  end

                  cq = CustomQuery.ejecutar({
                    sql:  "INSERT INTO  public . consolidados_sumar_detalles  \n"+
                          "( consolidado_sumar_id ,  efector_id ,  convenio_de_administracion_sumar_id ,  convenio_de_gestion_sumar_id ,  total ,  created_at ,  updated_at ) \n"+
                          "VALUES \n"+
                          "(#{c_id}, #{ea.id}, #{ea.convenio_de_administracion_sumar.id}, #{ea.convenio_de_gestion_sumar.id}, #{monto}, now(), now());\n"
                  })
                end #end each
              end #end transaction
            rescue Exception => e
              return false
            end #end try catch

          else
            next
          end

      end
      puts "Ejecución exitosa"
    rescue
      puts "Falló la ejecución para éste efector"
    end
  end #end function
  
end #end class
