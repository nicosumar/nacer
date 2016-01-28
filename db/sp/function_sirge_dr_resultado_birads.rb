# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_resultado_birads()
  CREATE OR REPLACE FUNCTION sirge_dr_resultado_birads(IN prestacion_liquidada_id integer)
    RETURNS integer AS
      $BODY$
        DECLARE
          prestacion_liquidada RECORD;        -- La prestación liquidada correspondiente al parámetro
          dato_reportable_birads2 RECORD;     -- Dato reportable con código BIRADS2 (resultado categorizado)
          dato_reportable_birads RECORD;      -- Dato reportable con código BIRADS (resultado texto)
          diagnostico_birads varchar(255);    -- El texto libre con el resultado de la mamografía
          valor_de_retorno integer;           -- El dato reportable asociado a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_birads2 FROM datos_reportables WHERE codigo = 'BIRADS2';
          SELECT * INTO dato_reportable_birads FROM datos_reportables WHERE codigo = 'BIRADS';

          -- Buscamos primero el dato más nuevo
          EXECUTE '
            SELECT valor_' || dato_reportable_birads2.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_birads2.id || ';' INTO valor_de_retorno;

          IF (valor_de_retorno IS NULL) THEN
            -- Si no hay dato nuevo, intentamos devolver el valor correcto dentro de las posibilidades
            EXECUTE '
              SELECT
                  upper(
                    regexp_replace(
                      trim(valor_' || dato_reportable_birads.tipo_ruby || '::varchar(255)),
                      ''[^A-Za-z0-9 ]'', '''', ''g''
                    )
                  )
                FROM
                  ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                  INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                  INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
                WHERE
                  dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                  AND dr.id = ' || dato_reportable_birads.id || ';' INTO diagnostico_birads;

            CASE
              WHEN (
                  diagnostico_birads LIKE '%NEG%' OR diagnostico_birads LIKE '%DIAG%'
                  OR diagnostico_birads LIKE 'O%' OR diagnostico_birads LIKE '%CONTROL%'
                  OR diagnostico_birads LIKE '%PREVENT%' OR diagnostico_birads LIKE '%BR%O%'
                ) THEN
                SELECT '0'::integer INTO valor_de_retorno;
              WHEN (
                  length(regexp_replace(diagnostico_birads, '[^0-9]', '', 'g')) > 0
                  AND regexp_replace(diagnostico_birads, '[^0-9]', '', 'g')::integer BETWEEN 0 AND 5
                ) THEN
                SELECT regexp_replace(diagnostico_birads, '[^0-9]', '', 'g')::integer INTO valor_de_retorno;
              WHEN (
                  length(regexp_replace(diagnostico_birads, '[^0-9]', '', 'g')) > 0
                  AND regexp_replace(diagnostico_birads, '[^0-9]', '', 'g')::integer = 6
                ) THEN
                SELECT '5'::integer INTO valor_de_retorno;
              WHEN (
                  diagnostico_birads LIKE '%IV%' OR diagnostico_birads LIKE '%CARCINOMA%'
                  OR diagnostico_birads LIKE '%MI4%'
                ) THEN
                SELECT '4'::integer INTO valor_de_retorno;
              WHEN diagnostico_birads LIKE '%V%' THEN
                SELECT '5'::integer INTO valor_de_retorno;
              WHEN diagnostico_birads LIKE '%III%' THEN
                SELECT '3'::integer INTO valor_de_retorno;
              WHEN diagnostico_birads LIKE '%II%' THEN
                SELECT '2'::integer INTO valor_de_retorno;
              WHEN diagnostico_birads LIKE '%I%' THEN
                SELECT '1'::integer INTO valor_de_retorno;
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