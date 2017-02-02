# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_peso()
  CREATE OR REPLACE FUNCTION sirge_dr_resultado_oea_oi(IN prestacion_liquidada_id integer)
    RETURNS varchar(8) AS
      $BODY$
        DECLARE
          prestacion_liquidada RECORD;        -- La prestación liquidada correspondiente al parámetro
          dato_reportable_roi2 RECORD;        -- Dato reportable con código ROI2 (resultado oído izquierdo nuevo)
          dato_reportable_roi RECORD;         -- Dato reportable con código ROI (resultado oído izquierdo antes)
          resultado_de_otoemision_id integer; -- El ID del resultado de la otoemisión seleccionado (definición nueva)
          resultado_de_otoemision RECORD;     -- El resultado de otoemisión asociado
          resultado_del_estudio varchar(255); -- El texto libre con el resultado de la otoemisión
          valor_de_retorno varchar(8);        -- El dato reportable asociado a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_roi2 FROM datos_reportables WHERE codigo = 'ROI2';
          SELECT * INTO dato_reportable_roi FROM datos_reportables WHERE codigo = 'ROI';

          -- Buscamos primero el dato más nuevo
          EXECUTE '
            SELECT valor_' || dato_reportable_roi2.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_roi2.id || ';' INTO resultado_de_otoemision_id;

          IF (resultado_de_otoemision_id IS NOT NULL) THEN
            -- Si hay dato nuevo, devolvemos la cadena de acuerdo con la opción seleccionada
            SELECT * INTO resultado_de_otoemision FROM resultados_de_otoemisiones WHERE id = resultado_de_otoemision_id;
            SELECT 'OI'::text || resultado_de_otoemision.subcodigo_sirge INTO valor_de_retorno;
          ELSE
            -- Si no hay dato nuevo, intentamos devolver la cadena correcta dentro de las posibilidades
            EXECUTE '
              SELECT
                  upper(
                    regexp_replace(
                      trim(valor_' || dato_reportable_roi.tipo_ruby || '::varchar(255)),
                      ''[^A-Za-z\\+\\- ]'', '''', ''g''
                    )
                  )
                FROM
                  ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                  INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                  INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
                WHERE
                  dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                  AND dr.id = ' || dato_reportable_roi.id || ';' INTO resultado_del_estudio;

            CASE
              WHEN (
                  resultado_del_estudio LIKE '%POSITIVO%' OR
                  resultado_del_estudio LIKE '%NORMAL%' OR
                  resultado_del_estudio LIKE '%PRESENTE%' OR
                  resultado_del_estudio LIKE '%+%' OR
                  resultado_del_estudio LIKE '%SANO%' OR
                  resultado_del_estudio LIKE '%PASA%' AND resultado_del_estudio NOT LIKE '%N%PASA%'
                ) THEN
                  SELECT 'OIpasa'::varchar(8) INTO valor_de_retorno;
              WHEN (
                  resultado_del_estudio LIKE '%AUSENTE%' OR
                  resultado_del_estudio LIKE '%-%' AND resultado_del_estudio NOT LIKE '%+%' OR
                  resultado_del_estudio LIKE '%N%PASA%'
                ) THEN
                  SELECT 'OInopasa'::varchar(8) INTO valor_de_retorno;
              ELSE
                SELECT NULL::varchar(8) INTO valor_de_retorno;
            END CASE;
          END IF;

          RETURN valor_de_retorno;

        END;
      $BODY$
    LANGUAGE plpgsql VOLATILE
    RETURNS NULL ON NULL INPUT
    COST 100;
SQL