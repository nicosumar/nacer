# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_ceod()
  CREATE OR REPLACE FUNCTION sirge_dr_ceod(IN prestacion_liquidada_id integer)
    RETURNS char(14) AS
      $BODY$
        DECLARE
          prestacion_liquidada RECORD;       -- La prestación liquidada correspondiente al parámetro
          dato_reportable_ceod_c RECORD;     -- Dato reportable con código CEOD_C (caries)
          dato_reportable_ceod_e RECORD;     -- Dato reportable con código CEOD_E (extracción indicada)
          dato_reportable_ceod_o RECORD;     -- Dato reportable con código CEOD_O (obturados)
          valor_ceod_c integer;              -- Valor de caries
          valor_ceod_e integer;              -- Valor de extracciones indicadas
          valor_ceod_o integer;              -- Valor de obturados
          valor_de_retorno char(14);         -- El dato reportable asociado a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_ceod_c FROM datos_reportables WHERE codigo = 'CPOD_C';
          SELECT * INTO dato_reportable_ceod_e FROM datos_reportables WHERE codigo = 'CPOD_P';
          SELECT * INTO dato_reportable_ceod_o FROM datos_reportables WHERE codigo = 'CPOD_O';

          -- Buscamos los valores de los datos reportables del índice CPOD
          EXECUTE '
            SELECT valor_' || dato_reportable_ceod_c.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_ceod_c.id || ';' INTO valor_ceod_c;
          EXECUTE '
            SELECT valor_' || dato_reportable_ceod_e.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_ceod_e.id || ';' INTO valor_ceod_e;
          EXECUTE '
            SELECT valor_' || dato_reportable_ceod_o.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_ceod_o.id || ';' INTO valor_ceod_o;

          -- Construimos el valor de salida únicamente si tenemos los tres datos
          IF (valor_ceod_c IS NOT NULL AND valor_ceod_e IS NOT NULL AND valor_ceod_o IS NOT NULL) THEN
            SELECT
                (
                  'c:'::text ||
                  trim(to_char(valor_ceod_c, '00')) ||
                  '/e:'::text ||
                  trim(to_char(valor_ceod_e, '00')) ||
                  '/o:'::text ||
                  trim(to_char(valor_ceod_o, '00'))
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