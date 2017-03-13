namespace :revertir_cuasifactura do
  desc "TODO"
  task :actualizar_esquemas_nulos_prestaciones_liquidadas => :environment do
    Efector.where("unidad_de_alta_de_datos_id IS NOT NULL").map do |efector| 
      if efector.unidad_de_alta_de_datos.present?
        esquema = "uad_" + efector.unidad_de_alta_de_datos.codigo
        puts "Efector #{efector.id}"
        puts "UAD #{esquema}"

        if PrestacionLiquidada.where(efector_id: efector.id).where("esquema IS NULL").update_all(esquema: esquema)
          puts "OK"
        else
          puts "ERROR"
        end
        puts "-------------------------------------------------"
      end
    end
  end

  task :por_liquidacion_sumar_y_efector, [:liquidacion_sumar_id, :efector_id] => :environment do |task, args|
    por_liquidacion_y_efector args[:liquidacion_sumar_id], args[:efector_id]
  end

  task :por_liquidacion_sumar, [:liquidacion_sumar_id] => :environment do |task, args|
    por_liquidacion_sumar args[:liquidacion_sumar_id]
  end

  task :eliminar_prestaciones_incluidas_por_liquidacion_sumar, [:liquidacion_sumar_id] => :environment do |task, args|
    ActiveRecord::Base.transaction do
      liquidacion_sumar = LiquidacionSumar.find(args[:liquidacion_sumar_id])
      prestaciones_incluidas = PrestacionIncluida.where(liquidacion_id: liquidacion_sumar.id)
      prestaciones_incluidas.each do |pi|
        LiquidacionSumarCuasifacturaDetalle.where(prestacion_incluida_id: pi.id).destroy_all
      end
      PrestacionLiquidadaAdvertencia.where(liquidacion_id: liquidacion_sumar.id).destroy_all
      PrestacionLiquidadaDato.where(liquidacion_id: liquidacion_sumar.id).destroy_all
      PrestacionLiquidada.where(liquidacion_id: liquidacion_sumar.id).destroy_all
      prestaciones_incluidas.destroy_all
    end
  end

  task :crear_expedientes_por_liquidacion_sumar, [:liquidacion_sumar_id] => :environment do |task, args|
    liquidacion_sumar = LiquidacionSumar.find(args[:liquidacion_sumar_id])
    documento_generable = liquidacion_sumar.concepto_de_facturacion.documentos_generables_por_conceptos.where(documento_generable_id: 3).first
    ActiveRecord::Base.transaction do
      begin
        documento_generable.tipo_de_agrupacion.iterar_efectores_y_prestaciones_de(liquidacion_sumar) do |e, pliquidadas|

          # Si el efector administrador no posee prestaciones para liquidar, lo omito
          next if pliquidadas.sum(:monto) == 0

          puts "LOG INFO - LIQUIDACION_SUMAR: Creando cuasifactura para efector #{e.nombre} - Liquidacion #{liquidacion_sumar.id} "
          
          # 1) Creo la cabecera del expediente
          exp = ExpedienteSumar.where({ tipo_de_expediente_id: liquidacion_sumar.concepto_de_facturacion.tipo_de_expediente,
                                         liquidacion_sumar_id: liquidacion_sumar,
                                         efector_id: e}).first
          if exp.blank?
            exp = ExpedienteSumar.create({ tipo_de_expediente: liquidacion_sumar.concepto_de_facturacion.tipo_de_expediente,
                                           liquidacion_sumar: liquidacion_sumar,
                                           efector: e})
          end
          exp.numero = documento_generable.obtener_numeracion(exp.id)
          exp.save!(validate: false)
        end # end itera segun agrupacion

      rescue Exception => e
        raise "Ocurrio un problema: #{e.message}"
        return false
      end #en begin/rescue
    end #End active base transaction
  end

  task :crear_informes_por_liquidacion_sumar, [:liquidacion_sumar_id] => :environment do |task, args|
    liquidacion_sumar = LiquidacionSumar.find(args[:liquidacion_sumar_id])
    documento_generable = liquidacion_sumar.concepto_de_facturacion.documentos_generables_por_conceptos.where(documento_generable_id: 4).first
    puts "Generación de informes para liquidación #{liquidacion_sumar.id}"
    puts "#{documento_generable.present?}"
    puts "#{liquidacion_sumar.present?}"
    puts "#{LiquidacionSumarCuasifactura.where(liquidacion_sumar_id: liquidacion_sumar.id).size}"
    if documento_generable.present? and LiquidacionSumarCuasifactura.where(liquidacion_sumar_id: liquidacion_sumar.id).size == 0
      puts "IF"
      ActiveRecord::Base.transaction do
        begin
          puts "Comienzo....."
          documento_generable.tipo_de_agrupacion.iterar_efectores_y_prestaciones_de(liquidacion_sumar) do |e, pliquidadas |
            puts "Efector #{e.id}"
            # Si el efector no liquido prestaciones
            next if pliquidadas.size == 0

            puts "LOG INFO - LIQUIDACION_SUMAR: Creando informe para efector #{e.nombre} - Liquidacion #{liquidacion_sumar.id} "
            
            
            # Solo los efectores administradores o autoadministrados generan expediente
            # por lo que en el informe debe asignarse expediente del administrador a los efectores administrados
            if e.es_administrador? or e.es_autoadministrado?

              # Si solo hay un expediente, generado, todos los informes llevan ese numero
              if ExpedienteSumar.where([ "liquidacion_sumar_id = #{liquidacion_sumar.id} and efector_id = #{e.id} "]).size == 1
                expediente_sumar_id = ExpedienteSumar.where([ "liquidacion_sumar_id = #{liquidacion_sumar.id} and efector_id = #{e.id} "]).first.id
              else
                expediente_sumar_id = ExpedienteSumar.where([ "liquidacion_sumar_id = #{liquidacion_sumar.id} and efector_id = #{e.id} " +
                                                              "AND id not in (SELECT expediente_sumar_id from liquidaciones_informes) "]).first.id
              end
            else
              if ExpedienteSumar.where([ "liquidacion_sumar_id = #{liquidacion_sumar.id} and efector_id = #{e.administrador_sumar.id} "]).size == 1
                expediente_sumar_id = ExpedienteSumar.where([ "liquidacion_sumar_id = #{liquidacion_sumar.id} and efector_id = #{e.administrador_sumar.id} "]).first.id
              else
                expediente_sumar_id = ExpedienteSumar.where([ "liquidacion_sumar_id = #{liquidacion_sumar.id} and efector_id = #{e.administrador_sumar.id} " +
                                                              "AND id not in (SELECT expediente_sumar_id from liquidaciones_informes) "]).first.id
              end
            end

            cuasifactura_id = LiquidacionSumarCuasifactura.joins(:liquidaciones_sumar_cuasifacturas_detalles).
                                                           where(liquidaciones_sumar_cuasifacturas_detalles: {prestacion_liquidada_id: pliquidadas.first.id}).first.id

            # 1) Creo la cabecera del informe de liquidacion
            liquidacion = LiquidacionInforme.create!(
              { 
                efector_id: e.id,
                liquidacion_sumar_id: liquidacion_sumar.id,
                liquidacion_sumar_cuasifactura_id: cuasifactura_id, 
                expediente_sumar_id: expediente_sumar_id,
                estado_del_proceso_id: EstadoDelProceso.where(codigo: 'N').first.id #estado No iniciado
            })
            liquidacion.save

          end # end itera segun agrupacion

        rescue Exception => e
          raise "Ocurrio un problema: #{e.message}"
          return false
        end #en begin/rescue
      end #End active base transaction
    end
  end

  task :generar_documentos, [:liquidacion_sumar_id] => :environment do |task, args|
    liquidacion_sumar = LiquidacionSumar.find(args[:liquidacion_sumar_id])
    generar_documentos liquidacion_sumar
  end

  def por_liquidacion_y_efector liquidacion_sumar_id, efector_id
    puts "##################################################################"
    begin
      puts "Ejecutando proceso de revertir factura por efector"    
      liquidacion_sumar = LiquidacionSumar.find(liquidacion_sumar_id)
      efector = Efector.find(efector_id)
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
        
        if cq
          puts "Actualización de estado de prestaciones brindadas"
        else
          puts "No se actualizó el estado de prestaciones brindadas"
        end
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
        vigencia_prestaciones = liquidacion_sumar.periodo.dias_de_prestacion
        fecha_de_recepcion = liquidacion_sumar.periodo.fecha_recepcion.to_s
        fecha_limite_prestaciones = liquidacion_sumar.periodo.fecha_limite_prestaciones.to_s

        ActiveRecord::Base.transaction do 

          # Busco y marco prestaciones vencidas al momento de liquidar
          # PrestacionBrindada.marcar_prestaciones_vencidas liquidacion_sumar
          # PrestacionBrindada.marcar_prestaciones_sin_periodo_de_actividad liquidacion_sumar
          # PrestacionBrindada.marcar_prestaciones_sin_asignacion_de_precio liquidacion_sumar
          
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
                    " AND vpb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_prestaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd')\n"+
                    " AND ( CASE WHEN vpb.clave_de_beneficiario is not  null THEN \n"+
                    "                 (vpb.fecha_de_la_prestacion >= pa.fecha_de_inicio and pa.fecha_de_finalizacion is null )\n"+
                    "                 OR\n"+
                    "                 (vpb.fecha_de_la_prestacion between pa.fecha_de_inicio and pa.fecha_de_finalizacion )\n"+
                    "            WHEN vpb.clave_de_beneficiario is null then TRUE\n"+
                    "       END\n"+
                    "     )\n"+
                    " AND pr.id not in (select prestacion_id from prestaciones_incluidas where liquidacion_id = #{liquidacion_sumar.id} AND nomenclador_id=nom.id )"
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
                  "  AND vpb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_prestaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') \n"+
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
                  "AND pl.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_prestaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') \n"+
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
                  " AND pl.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_prestaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') "
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

      end
      puts "Ejecución exitosa"
    rescue
      puts "Falló la ejecución para éste efector #{efector.id}"
    end
    puts "##################################################################"
  end

  def por_liquidacion_sumar liquidacion_sumar_id
    puts "##################################################################"
    begin
      puts "Ejecutando proceso de revertir factura por liquidación"    
      liquidacion_sumar = LiquidacionSumar.find(liquidacion_sumar_id)
      liquidacion_sumar.grupo_de_efectores_liquidacion.efectores.each do |efector|
        por_liquidacion_y_efector liquidacion_sumar.id, efector.id
      end
      puts "GENERANDO DOCUMENTOS"
      generar_documentos liquidacion_sumar
      puts "DOCUMENTOS GENERADOS CORRECTAMENTE"
    rescue
      puts "Error generando liquidación #{liquidacion_sumar.id}"
    end
    puts "##################################################################"
  end

  def generar_documentos liquidacion_sumar
    liquidacion_sumar.generar_documentos!
  end  

end