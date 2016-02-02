# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_resultado_biopsia()
  CREATE OR REPLACE FUNCTION sirge_dr_resultado_biopsia_mama(IN prestacion_liquidada_id integer)
    RETURNS integer AS
      $BODY$
        DECLARE
          prestacion_liquidada RECORD;        -- La prestación liquidada correspondiente al parámetro
          dato_reportable_diagapbm RECORD;    -- Dato reportable con código DIAGAPBM (resultado categorizado)
          dato_reportable_diagap RECORD;      -- Dato reportable con código DIAGAP (resultado texto)
          diagnostico_biopsia_id integer;     -- El ID del resultado del diagnóstico seleccionado (definición nueva)
          diagnostico_biopsia RECORD;         -- El diagnóstico de la biopsia asociado
          diagnostico_ap varchar(255);        -- El texto libre con el resultado de la otoemisión
          valor_de_retorno integer;           -- El dato reportable asociado a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_diagapbm FROM datos_reportables WHERE codigo = 'DIAGAPBM';
          SELECT * INTO dato_reportable_diagap FROM datos_reportables WHERE codigo = 'DIAGAP';

          -- Buscamos primero el dato más nuevo
          EXECUTE '
            SELECT valor_' || dato_reportable_diagapbm.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_diagapbm.id || ';' INTO diagnostico_biopsia_id;

          IF (diagnostico_biopsia_id IS NOT NULL) THEN
            -- Si hay dato nuevo, devolvemos la cadena de acuerdo con la opción seleccionada
            SELECT * INTO diagnostico_biopsia FROM diagnosticos_biopsias_mamas WHERE id = diagnostico_biopsia_id;
            SELECT diagnostico_biopsia.codigo_sirge INTO valor_de_retorno;
          ELSE
            -- Si no hay dato nuevo, intentamos devolver el ID correcto dentro de las posibilidades
            EXECUTE '
              SELECT
                  upper(
                    regexp_replace(
                      trim(valor_' || dato_reportable_diagap.tipo_ruby || '::varchar(255)),
                      ''[^A-Za-z\\+\\- ]'', '''', ''g''
                    )
                  )
                FROM
                  ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                  INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                  INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
                WHERE
                  dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                  AND dr.id = ' || dato_reportable_diagap.id || ';' INTO diagnostico_ap;

            CASE
              WHEN diagnostico_ap LIKE '%SITU%' THEN
                SELECT '1'::integer INTO valor_de_retorno;
              WHEN (
                  diagnostico_ap LIKE '%CARCI%' OR diagnostico_ap LIKE '%POSITIVO%'
                  OR diagnostico_ap LIKE '%+%' OR diagnostico_ap LIKE 'CA%'
                  OR diagnostico_ap LIKE '%INVASOR%' OR diagnostico_ap LIKE 'TU%'
                  OR diagnostico_ap LIKE '%MELANOMA%' OR diagnostico_ap LIKE '%II%'
                ) THEN
                SELECT '2'::integer INTO valor_de_retorno;
              WHEN (
                  diagnostico_ap LIKE '%QUISTE%' OR diagnostico_ap LIKE '%TEJIDO%'
                  OR diagnostico_ap LIKE '%MASTO%' OR diagnostico_ap LIKE '%MATERIAL%'
                  OR diagnostico_ap LIKE '%NEG%' OR diagnostico_ap LIKE '%BAJO%GRADO%'
                  OR diagnostico_ap LIKE '%FIBRO%' OR diagnostico_ap LIKE '%ESCLER%'
                ) THEN
                SELECT '6'::integer INTO valor_de_retorno;
              WHEN (
                  diagnostico_ap LIKE '%SOSPECHOSO%'
                ) THEN
                SELECT '5'::integer INTO valor_de_retorno;
              WHEN (
                  diagnostico_ap LIKE '%FALTA%' OR diagnostico_ap LIKE '%INSUF%'
                ) THEN
                SELECT '7'::integer INTO valor_de_retorno;
              ELSE
                SELECT NULL::integer INTO valor_de_retorno;
            END CASE;
          END IF;

          RETURN valor_de_retorno;

        END;
      $BODY$
    LANGUAGE plpgsql VOLATILE
    RETURNS NULL ON NULL INPUT
    COST 100;
SQL