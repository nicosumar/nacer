# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_cpod()
  CREATE OR REPLACE FUNCTION sirge_dr_cpod(IN prestacion_liquidada_id integer)
    RETURNS char(14) AS
      $BODY$
        DECLARE
          prestacion_liquidada RECORD;       -- La prestación liquidada correspondiente al parámetro
          dato_reportable_cpod_c RECORD;     -- Dato reportable con código CPOD_C (caries)
          dato_reportable_cpod_p RECORD;     -- Dato reportable con código CPOD_P (perdidos)
          dato_reportable_cpod_o RECORD;     -- Dato reportable con código CPOD_O (obturados)
          valor_cpod_c integer;              -- Valor de caries
          valor_cpod_p integer;              -- Valor de perdidos
          valor_cpod_o integer;              -- Valor de obturados
          valor_de_retorno char(14);         -- El dato reportable asociado a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_cpod_c FROM datos_reportables WHERE codigo = 'CPOD_C';
          SELECT * INTO dato_reportable_cpod_p FROM datos_reportables WHERE codigo = 'CPOD_P';
          SELECT * INTO dato_reportable_cpod_o FROM datos_reportables WHERE codigo = 'CPOD_O';

          -- Buscamos los valores de los datos reportables del índice CPOD
          EXECUTE '
            SELECT valor_' || dato_reportable_cpod_c.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_cpod_c.id || ';' INTO valor_cpod_c;
          EXECUTE '
            SELECT valor_' || dato_reportable_cpod_p.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_cpod_p.id || ';' INTO valor_cpod_p;
          EXECUTE '
            SELECT valor_' || dato_reportable_cpod_o.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_cpod_o.id || ';' INTO valor_cpod_o;

          -- Construimos el valor de salida únicamente si tenemos los tres datos
          IF (valor_cpod_c IS NOT NULL AND valor_cpod_p IS NOT NULL AND valor_cpod_o IS NOT NULL) THEN
            SELECT
                (
                  'C:'::text ||
                  trim(to_char(valor_cpod_c, '00')) ||
                  '/P:'::text ||
                  trim(to_char(valor_cpod_p, '00')) ||
                  '/O:'::text ||
                  trim(to_char(valor_cpod_o, '00'))
                )::char(14)
              INTO valor_de_retorno;
          ELSE
            SELECT NULL::char(14) INTO valor_de_retorno;
          END IF;

          RETURN valor_de_retorno;

        END;
      $BODY$
    LANGUAGE plpgsql VOLATILE
    RETURNS NULL ON NULL INPUT
    COST 100;
SQL