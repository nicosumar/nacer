# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_resultado_citologia()
  CREATE OR REPLACE FUNCTION sirge_dr_resultado_citologia(IN prestacion_liquidada_id integer)
    RETURNS integer AS
      $BODY$
        DECLARE
          prestacion_liquidada RECORD;        -- La prestación liquidada correspondiente al parámetro
          dato_reportable_diagapc RECORD;     -- Dato reportable con código DIAGAPB (resultado categorizado)
          dato_reportable_diagap RECORD;      -- Dato reportable con código DIAGAP (resultado texto)
          diagnostico_citologia_id integer;   -- El ID del resultado del diagnóstico (definición nueva)
          diagnostico_citologia RECORD;       -- El diagnóstico de la biopsia asociado
          diagnostico_ap varchar(255);        -- El texto libre con el resultado de la otoemisión
          valor_de_retorno integer;           -- El dato reportable asociado a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_diagapc FROM datos_reportables WHERE codigo = 'DIAGAPC';
          SELECT * INTO dato_reportable_diagap FROM datos_reportables WHERE codigo = 'DIAGAP';

          -- Buscamos primero el dato más nuevo
          EXECUTE '
            SELECT valor_' || dato_reportable_diagapc.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_diagapc.id || ';' INTO diagnostico_citologia_id;

          IF (diagnostico_citologia_id IS NOT NULL) THEN
            -- Si hay dato nuevo, devolvemos la cadena de acuerdo con la opción seleccionada
            SELECT * INTO diagnostico_citologia FROM diagnosticos_citologias WHERE id = diagnostico_citologia_id;
            SELECT diagnostico_citologia.codigo_sirge INTO valor_de_retorno;
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
              WHEN (
                  diagnostico_ap LIKE '%INSATISF%' OR diagnostico_ap LIKE '%NO APTO%'
                  OR diagnostico_ap LIKE '%TRAST%FIJAC%' OR diagnostico_ap LIKE '%COLORAC%'
                ) THEN
                SELECT NULL::integer INTO valor_de_retorno;
              WHEN diagnostico_ap LIKE '%SITU%' THEN
                SELECT '4'::integer INTO valor_de_retorno;
              WHEN (
                  diagnostico_ap LIKE '%ASC%H%'
                ) THEN
                SELECT '7'::integer INTO valor_de_retorno;
              WHEN (
                  diagnostico_ap LIKE '%CARCINOMA%' OR diagnostico_ap LIKE '%POS%'
                  OR diagnostico_ap LIKE '%+%' OR diagnostico_ap LIKE '%INVASOR%'
                  OR diagnostico_ap LIKE '%CA CERVICAL%' OR diagnostico_ap LIKE '%CON CA%'
                ) THEN
                SELECT '5'::integer INTO valor_de_retorno;
              WHEN diagnostico_ap LIKE '%III%' THEN
                SELECT '3'::integer INTO valor_de_retorno;
              WHEN diagnostico_ap LIKE '%II%' THEN
                SELECT '2'::integer INTO valor_de_retorno;
              WHEN (
                  diagnostico_ap LIKE '%H%SIL%' AND diagnostico_ap NOT LIKE '%SOSPECHOSO%'
                  OR diagnostico_ap LIKE '%SIL%ALTO%'OR diagnostico_ap LIKE '%SIL%AG%'
                  OR diagnostico_ap LIKE '%PREC%ALTO%' OR diagnostico_ap LIKE '%PREC%AG%'
                  OR diagnostico_ap LIKE '%ALTO%GRADO%'
                ) THEN
                SELECT '1'::integer INTO valor_de_retorno;
              WHEN (
                  diagnostico_ap LIKE '%NEG%' OR diagnostico_ap LIKE '%AMENORREA%'
                  OR diagnostico_ap LIKE '-' OR diagnostico_ap LIKE '%CAND%'
                  OR diagnostico_ap LIKE '%SATISF%' AND diagnostico_ap NOT LIKE '%INSATISF%'
                  OR diagnostico_ap LIKE '%CLIMATERIO%' OR diagnostico_ap LIKE '%NORMAL%'
                  OR diagnostico_ap LIKE '%INFL%' OR diagnostico_ap LIKE '%CONTROL%'
                  OR diagnostico_ap LIKE '%TROFICO%' OR diagnostico_ap LIKE '%EMBARAZO%'
                  OR diagnostico_ap LIKE '%QUERAT%'
                ) THEN
                SELECT '8'::integer INTO valor_de_retorno;
              WHEN (
                  diagnostico_ap LIKE '%AGC%' OR diagnostico_ap LIKE '%AGS%'
                  OR diagnostico_ap LIKE '%CIN%I%' OR diagnostico_ap LIKE '%SIL%B%' 
                  OR diagnostico_ap LIKE '%BAJO%GRADO%' OR diagnostico_ap LIKE '%L%SIL%'
                  OR diagnostico_ap LIKE '%ASC%US%'
                ) THEN
                SELECT '6'::integer INTO valor_de_retorno;
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