# -*- encoding : utf-8 -*-
class LiquidacionSumar < ActiveRecord::Base
  belongs_to :grupo_de_efectores_liquidacion
  belongs_to :concepto_de_facturacion
  belongs_to :periodo
  belongs_to :plantilla_de_reglas
  belongs_to :parametro_liquidacion_sumar
  has_many   :prestaciones_liquidadas, foreign_key: :liquidacion_id
  has_many   :liquidaciones_sumar_cuasifacturas
  has_many   :consolidados_sumar
  has_many   :expedientes_sumar
  has_many   :procesos_de_sistemas

  attr_accessible :descripcion, :grupo_de_efectores_liquidacion_id, :concepto_de_facturacion_id, :periodo_id, :plantilla_de_reglas_id, :parametro_liquidacion_sumar_id

  validates_presence_of :descripcion, :grupo_de_efectores_liquidacion, :concepto_de_facturacion, :periodo, :parametro_liquidacion_sumar_id

  scope :cuasifactura_de, lambda {|efector| where(efector_id: efector.id).first}  

  def cuasifactura_de(efector)
    if efector.class == Efector
      self.liquidaciones_sumar_cuasifacturas.where(efector_id: efector.id).first
    else
      raise "El argumento debe ser de tipo Efector"  
      return false
    end
  end

  def consolidado_de(efector)
    if efector.class == Efector
      self.consolidados_sumar.where(efector_id: efector.id).first
    else
      raise "El argumento debe ser de tipo Efector"  
      return false
    end
  end


  def self.liquidacion_de(efector, periodo, concepto)
    unless efector.is_a? Efector
      raise "El argumento debe ser de tipo Efector"  
      return false
    end
    unless periodo.is_a? Periodo
      raise "El argumento debe ser de tipo Periodo"  
      return false
    end
    unless concepto.is_a? ConceptoDeFacturacion 
      raise "El argumento debe ser de tipo Periodo"  
      return false
    end

    where(periodo_id: periodo.id).
    where(concepto_de_facturacion_id: concepto.id).
    where("EXISTS (SELECT id FROM prestaciones_liquidadas WHERE liquidacion_id = liquidaciones_sumar.id and efector_id = ?)", efector.id)

  end

  # 
  # Devuelve las prestaciones liquidadas para un efector dado
  # @param efector [Efector] Efector a buscar
  # 
  # @return [CustomQuery] Array con el resultado de la busqueda
  def prestaciones_liquidadas_de(efector)
    unless efector.is_a? Efector
      raise "El argumento debe ser de tipo Efector"  
      return false
    end

    sql = <<-SQL 
          SELECT pi.prestacion_codigo,pi.prestacion_nombre, d.codigo codigo_de_diagnostico, pl.fecha_de_la_prestacion, 
                   td.codigo||': '|| a.numero_de_documento documento, a.apellido || ', '|| a.nombre nombre_y_apellido, 
                   pl.id, pl.prestacion_brindada_id, pl.monto,
                   cuasi.numero_cuasifactura, amp.prestacion_liquidada_id, 
                  estado_li.nombre estado_informe_liquidacion, 
                  CASE WHEN  estado_prestacion_aa.id IS NULL AND aa.id IS NULL THEN 'En proceso de liquidación'  
                             WHEN  estado_prestacion_aa.id IS NULL AND aa.id IS  NOT NULL THEN 'No evalúa'  
                             ELSE  estado_prestacion_aa.nombre END estado_prestacion_aa,  motivo_rechazo_aa.nombre motivo_rechazo_aa ,
                   CASE WHEN  estado_prestacion_am.id IS NULL AND am.id IS NULL THEN 'En proceso de liquidación'  
                             WHEN  estado_prestacion_am.id IS NULL AND am.id IS  NOT NULL THEN 'No evalúa'  
                             ELSE  estado_prestacion_am.nombre END estado_prestacion_am, motivo_rechazo_am.nombre motivo_rechazo_am,
                  ep.nombre estado, pl.observaciones_liquidacion, epb.nombre estado_actual, vgpb.observaciones_de_liquidacion
          FROM liquidaciones_sumar l
           INNER JOIN prestaciones_liquidadas pl ON pl.liquidacion_id = l.id 
           INNER JOIN prestaciones_incluidas pi ON pl.prestacion_incluida_id = pi.id 
           INNER JOIN estados_de_las_prestaciones ep ON ep.id = pl.estado_de_la_prestacion_liquidada_id
           INNER JOIN efectores e ON e.\"id\" = pl.efector_id 
           INNER JOIN diagnosticos d ON d.id = pl.diagnostico_id
           INNER JOIN vista_global_de_prestaciones_brindadas vgpb ON ( vgpb.id = pl.prestacion_brindada_id AND vgpb.esquema = pl.esquema )
           INNER JOIN estados_de_las_prestaciones epb ON epb.id = vgpb.estado_de_la_prestacion_id
           LEFT JOIN  liquidaciones_informes li ON li.efector_id = e.id and li.liquidacion_sumar_id = l.id 
           LEFT JOIN  estados_de_los_procesos estado_li ON li.estado_del_proceso_id = estado_li.id 
           LEFT JOIN  liquidaciones_sumar_anexos_administrativos aa ON li.liquidacion_sumar_anexo_administrativo_id = aa.id and aa.estado_del_proceso_id = 3 --estado finalizado
           LEFT JOIN  anexos_administrativos_prestaciones aap ON aap.prestacion_liquidada_id = pl.id 
           LEFT JOIN  estados_de_las_prestaciones estado_prestacion_aa ON estado_prestacion_aa.id = aap.estado_de_la_prestacion_id
           LEFT JOIN  motivos_de_rechazos motivo_rechazo_aa ON motivo_rechazo_aa.id = aap.motivo_de_rechazo_id 
           LEFT JOIN  liquidaciones_sumar_anexos_medicos am ON li.liquidacion_sumar_anexo_medico_id = am.id and am.estado_del_proceso_id = 3 --estado finalizado
           LEFT JOIN  anexos_medicos_prestaciones amp ON amp.prestacion_liquidada_id = pl.id 
           LEFT JOIN  estados_de_las_prestaciones estado_prestacion_am ON estado_prestacion_am.id = amp.estado_de_la_prestacion_id
           LEFT JOIN  motivos_de_rechazos motivo_rechazo_am ON motivo_rechazo_am.id = amp.motivo_de_rechazo_id 
           LEFT JOIN  afiliados a ON a.clave_de_beneficiario = pl.clave_de_beneficiario
           LEFT JOIN  tipos_de_documentos td ON td.id = a.tipo_de_documento_id
           LEFT JOIN  (liquidaciones_sumar_cuasifacturas lsc 
                        join liquidaciones_sumar_cuasifacturas_detalles lscd ON lscd.liquidaciones_sumar_cuasifacturas_id = lsc.id ) cuasi ON cuasi.prestacion_liquidada_id = pl.id 
          WHERE e.id = ?
          AND l.id = ?
          ORDER BY numero_cuasifactura DESC, estado, prestacion_codigo, fecha_de_la_prestacion, documento
      SQL
    
    cq = CustomQuery.buscar (
    {
      :sql => sql,
      values: [efector.id, self.id ]
    })


  end

  # 
  #  Guarda las prestaciones brindadas, datos adicionales y advertencias,
  # inculadas a un grupo de efectores en un periodo dado, eliminando prestaciones duplicadas.
  # 
  # @return boolean 
  def generar_snapshoot_de_liquidacion
    #Traigo Grupo de efectores
    efectores =  self.grupo_de_efectores_liquidacion.efectores.all.collect {|ef| ef.id}
    vigencia_perstaciones = self.periodo.dias_de_prestacion
    fecha_de_recepcion = self.periodo.fecha_recepcion.to_s
    fecha_limite_prestaciones = self.periodo.fecha_limite_prestaciones.to_s
    esquemas = UnidadDeAltaDeDatos.where(facturacion: true)

    #Agrego El Log
    @log_del_proceso = Logger.new("log/GenerarSnapshootLiquidacion.log",10, 1024000)
    @log_del_proceso.formatter = proc do |severity, datetime, progname, msg|
             date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
                    if severity == "INFO" or severity == "WARN"
                      "[#{date_format}] #{severity}: #{msg}\n"
                    else        
                      "[#{date_format}] #{severity}: #{msg}\n"
                    end
    end
    @log_del_proceso.info("*****************************************************")
    @log_del_proceso.info("####***Iniciando procesamiento de Cierre de la liquidación***###")
    @log_del_proceso.info("******************************************************")
    @log_del_proceso.info("Iniciando el proceso de la liquidación'#{self.id }")



    ActiveRecord::Base.transaction do 

      # Busco y marco prestaciones vencidas al momento de liquidar
      PrestacionBrindada.marcar_prestaciones_vencidas self
      PrestacionBrindada.marcar_prestaciones_sin_periodo_de_actividad self
      PrestacionBrindada.marcar_prestaciones_sin_asignacion_de_precio self
      

      # 0 ) Elimino los duplicados
      @log_del_proceso.info("Elimino los duplicados")
      PrestacionBrindada.anular_prestaciones_duplicadas

      
      # 1) Identifico los TIPOS de prestaciones que se brindaron en esta liquidacion y genero el snapshoot de las mismas
       @log_del_proceso.info("Identifico los TIPOS de prestaciones que se brindaron en esta liquidacion y genero el snapshoot de las mismas")
      cq = CustomQuery.ejecutar (
        {
          sql:  "INSERT INTO public.prestaciones_incluidas\n"+
                "( liquidacion_id, \n"+
                "  nomenclador_id, nomenclador_nombre, \n"+
                "  prestacion_id, prestacion_nombre, prestacion_codigo, \n"+
                "  prestacion_cobertura, prestacion_comunitaria, prestacion_requiere_hc, prestacion_concepto_nombre, created_at, updated_at) \n"+
                "SELECT DISTINCT ON (nom.id, pr.id) \n"+
                "                #{self.id}, \n"+
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
                " AND cdf.id = #{self.concepto_de_facturacion.id}    \n"+
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
                " AND pr.id not in (select prestacion_id from prestaciones_incluidas where liquidacion_id = #{self.id} )"
      })

      # 2) Identifico las prestaciones que se brindaron en esta liquidacion y genero el snapshoot de las mismas 
      @log_del_proceso.info(" Identifico las prestaciones que se brindaron en esta liquidacion y genero el snapshoot de las mismas")
      cq = CustomQuery.ejecutar ({
        sql:  "INSERT INTO public.prestaciones_liquidadas \n "+
              "       (liquidacion_id, esquema, unidad_de_alta_de_datos_id, efector_id, \n "+
              "        prestacion_incluida_id, fecha_de_la_prestacion, \n "+
              "        estado_de_la_prestacion_id, historia_clinica, es_catastrofica, \n "+
              "        diagnostico_id, diagnostico_nombre, \n "+
              "        cantidad_de_unidades, observaciones, \n "+
              "        clave_de_beneficiario, codigo_area_prestacion, nombre_area_de_prestacion, prestacion_brindada_id, \n "+
              "        created_at, updated_at) \n "+
              "SELECT DISTINCT #{self.id} liquidacion_id, vpb.esquema, ef.unidad_de_alta_de_datos_id as unidad_de_alta_de_datos_id, ef.id,\n"+
              "                 pi.id as prestacion_incluida_id, vpb.fecha_de_la_prestacion,\n"+
              "                 vpb.estado_de_la_prestacion_id, vpb.historia_clinica, vpb.es_catastrofica, \n"+
              "                 vpb.diagnostico_id, diag.nombre diagnostico_nombre,\n"+
              "                 vpb.cantidad_de_unidades, vpb.observaciones,\n"+
              "                 af.clave_de_beneficiario, areas.codigo codigo_area_prestacion, areas.nombre nombre_area_de_prestacion, vpb.id prestacion_brindada_id, \n"+
              "                 now(), now()\n"+
              "FROM vista_global_de_prestaciones_brindadas vpb\n"+
              "  INNER JOIN prestaciones pr ON (pr.id = vpb.prestacion_id) \n"+
              "  INNER JOIN prestaciones_incluidas pi ON (vpb.prestacion_id = pi.prestacion_id AND pi.liquidacion_id = #{self.id} )\n"+
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
        logger.warn ("Tabla de prestaciones liquidadas generada")
       
      else
        logger.warn ("Tabla de prestaciones liquidadas NO generada")
        @log_del_proceso.info("Tabla de prestaciones liquidadas NO generada")
      end

      # 3)  Identifico los datos vinculados a las prestaciones brindadas
      #    que se incluyeron en esta liquidacion y genero el snapshoot de las mismas
      @log_del_proceso.info("Identifico los datos vinculados a las prestaciones brindadas que se incluyeron en esta liquidacion y genero el snapshoot de las mismas")
      cq = CustomQuery.ejecutar ({
        sql:  "INSERT INTO prestaciones_liquidadas_datos \n "+
              " (liquidacion_id, prestacion_liquidada_id, \n "+
              "  dato_reportable_nombre, precio_por_unidad, valor_integer, valor_big_decimal, valor_date, valor_string, adicional_por_prestacion, \n "+
              "   dato_reportable_id, dato_reportable_requerido_id, created_at, updated_at) \n "+
              "SELECT '#{self.id}' liquidacion_id, pl.id prestacion_liquidada_id, \n"+
              "        dr.nombre dato_reportable_nombre, ap.precio_por_unidad, dra.valor_integer, dra.valor_big_decimal, dra.valor_date, dra.valor_string, ap.adicional_por_prestacion, \n"+
              "        dr.id dato_reportable_id, drr.id dato_reportable_requerido_id, now(), now()\n"+
              "FROM prestaciones_incluidas pi \n"+
              "  INNER JOIN prestaciones_liquidadas pl ON ( pl.prestacion_incluida_id = pi.id AND pl.liquidacion_id = #{self.id} )\n"+
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
        logger.warn ("Tabla de prestaciones Liquidadas datos generada")
      else
        logger.warn ("Tabla de prestaciones Liquidadas datos NO generada")
        @log_del_proceso.info("Tabla de prestaciones Liquidadas datos NO generada")
      end

      # 4)  Identifico las advertencias que poseen las prestaciones brindadas que se
      #    que se incluyeron en esta liquidacion y genero el snapshoot de las mismas
      @log_del_proceso.info("Identifico las advertencias que poseen las prestaciones brindadas que se que se incluyeron en esta liquidacion y genero el snapshoot de las mismas")
      cq = CustomQuery.ejecutar ({
        sql:  "INSERT INTO prestaciones_liquidadas_advertencias \n" +
              " (liquidacion_id, prestacion_liquidada_id, metodo_de_validacion_id, comprobacion, mensaje, created_at, updated_at)  \n"+
              "SELECT '#{self.id}', pl.id prestacion_liquidada_id, m.metodo_de_validacion_id, mv.nombre comprobacion, mv.mensaje, now(), now() \n"+
              "FROM vista_global_de_metodos_de_validacion_fallados m \n"+
              " INNER JOIN metodos_de_validacion mv ON (mv.id = m.metodo_de_validacion_id )\n"+
              " INNER JOIN prestaciones_liquidadas pl ON  (pl.prestacion_brindada_id = m.prestacion_brindada_id \n"+
              "                                            AND pl.esquema = m.esquema\n"+
              "                                            AND pl.liquidacion_id = #{self.id} )\n"+
              "WHERE pl.estado_de_la_prestacion_id IN (2,3,7) \n "+
              " AND pl.efector_id in ( #{efectores.join(", ")} )\n"+
              " AND pl.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_limite_prestaciones}','yyyy-mm-dd') "
        })
      if cq
        logger.warn ("Tabla de prestaciones Liquidadas advertencias generada")
      else
          @log_del_proceso.info("Tabla de prestaciones Liquidadas advertencias NO generada")
        logger.warn ("Tabla de prestaciones Liquidadas advertencias NO generada")
      end

      # 5) Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla
      #    de prestaciones liquidadas
      #    - Aca con las prestaciones aceptadas
      @log_del_proceso.info("Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla de prestaciones liquidadas - Aca con las prestaciones aceptadas")
      formula = "Formula_#{self.concepto_de_facturacion.formula.id}"
      plantilla_de_reglas = (self.plantilla_de_reglas_id.blank?) ? -1 : self.plantilla_de_reglas_id
      estado_aceptada = self.parametro_liquidacion_sumar.prestacion_aceptada.id
      estado_rechazada = self.parametro_liquidacion_sumar.prestacion_rechazada.id
      estado_exceptuada = self.parametro_liquidacion_sumar.prestacion_exceptuada.id

      cq = CustomQuery.ejecutar ({
        sql:  "UPDATE prestaciones_liquidadas   \n"+
              " SET monto = #{formula}(pl.id),   \n"+
              " estado_de_la_prestacion_liquidada_id =  #{estado_aceptada}   \n"+
              "FROM prestaciones_liquidadas pl\n"+
              " LEFT JOIN prestaciones_liquidadas_advertencias pla on pl.id = pla.prestacion_liquidada_id\n"+
              "WHERE pla.id is null\n"+
              "AND pl.liquidacion_id = #{self.id}\n"+
              "AND prestaciones_liquidadas.id = pl.id\n"+
              "AND pl.efector_id in ( #{efectores.join(", ")} )\n"
        })

      if cq
        logger.warn ("Tabla de prestaciones Liquidadas Actualizada con ACEPTADAS")
      else
          @log_del_proceso.info("Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla de prestaciones liquidadas - Aca con las prestaciones aceptadas")
        logger.warn ("Tabla de prestaciones Liquidadas NO Actualizada con ACEPTADAS")
      end

      # 6) Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla
      #    de prestaciones liquidadas
      #    - Aca con las prestaciones rechazadas, con su observacion

      @log_del_proceso.info("Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla de prestaciones liquidadas- Aca con las prestaciones rechazadas, con su observacion")
      cq = CustomQuery.ejecutar ({
        sql:    "UPDATE public.prestaciones_liquidadas \n"+
                "            SET monto = #{formula}(pl.id), \n"+
                "                estado_de_la_prestacion_liquidada_id =  #{estado_rechazada}, \n"+
                "                observaciones_liquidacion = COALESCE( prestaciones_liquidadas.observaciones_liquidacion, '') || 'No cumple con la validacion de \"' || pla.comprobacion || '\" al periodo #{self.periodo.periodo} ;' \n"+
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
                "   AND pl.liquidacion_id = #{self.id}\n"+
                " AND prestaciones_liquidadas.id = pl.id\n "+
                " AND pl.efector_id in ( #{efectores.join(", ")} )\n"
      })

      if cq
        logger.warn ("Tabla de prestaciones Liquidadas Actualizada con RECHAZADAS")
      else
        @log_del_proceso.info("Tabla de prestaciones Liquidadas NO Actualizada con RECHAZADAS")
        logger.warn ("Tabla de prestaciones Liquidadas NO Actualizada con RECHAZADAS")
      end

      # 7) Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla
      #    de prestaciones liquidadas
      #    - Aca con las prestaciones exceptuadas por regla
       @log_del_proceso.info("Con todos los datos, calculo el valor de cada prestacion y lo actualizo en la tabla de prestaciones liquidadas")
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
              "where pl.liquidacion_id = #{self.id}\n "+
              " and pl.estado_de_la_prestacion_liquidada_id is NULL \n"+
              " and prestaciones_liquidadas.id = pl.id \n"+
              " AND pl.efector_id in ( #{efectores.join(", ")} )\n"


       })
      if cq
        logger.warn ("Tabla de prestaciones Liquidadas Actualizada con EXCEPTUADAS")
      else
        @log_del_proceso.info("Tabla de prestaciones Liquidadas NO Actualizada con EXCEPTUADAS")
        logger.warn ("Tabla de prestaciones Liquidadas NO Actualizada con EXCEPTUADAS")
      end
    end # END transaction
      @log_del_proceso.info("Finalizó el proceso de la liquidación #{self.id }")
  end  # END Method

  def generar_documentos!
    begin

    #Agrego El Log
    @log_del_proceso = Logger.new("log/GenerarCuasifacturasLiquidacion.log",10, 1024000)
    @log_del_proceso.formatter = proc do |severity, datetime, progname, msg|
             date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
                    if severity == "INFO" or severity == "WARN"
                      "[#{date_format}] #{severity}: #{msg}\n"
                    else        
                      "[#{date_format}] #{severity}: #{msg}\n"
                    end
    end
    @log_del_proceso.info("*****************************************************")
    @log_del_proceso.info("####***Iniciando procesamiento de Generado de cuasifacturas***###")
    @log_del_proceso.info("******************************************************")
    @log_del_proceso.info("Iniciando el proceso de Generado de cuasifacturas - Liq #{self.id }")


      transaction do
        self.concepto_de_facturacion.generar_documentos!(self)
        @log_del_proceso.info("Generar Documentos OK")
        PrestacionBrindada.marcar_prestaciones_facturadas!(self)
        @log_del_proceso.info("Marcar Prestaciones Facturadas OK")
      end

      @log_del_proceso.info("Finalizó el proceso de Generado de cuasifacturas - Liq #{self.id }")
    rescue Exception => e
       logger.warn "Ocurrio un error: " + e.message
      @log_del_proceso.error("Ocurrio un error: " + e.message)
      raise "Ocurrio un error: " + e.message
    end
  end

  def vaciar_liquidacion

    # Comprobar que no existen cuasifacturas generadas para poder eliminar
    unless self.liquidaciones_sumar_cuasifacturas.size > 0
      ActiveRecord::Base.connection.execute "
              SET session_replication_role = replica;
               delete \n"+
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
              "where liquidacion_id = #{self.id};
              SET session_replication_role = DEFAULT;"
    else
      raise "Las cuasifacturas ya han sido generadas!"
    end 
  end

end
