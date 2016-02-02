# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_ceo()
  CREATE OR REPLACE FUNCTION sirge_dr_ceo(IN prestacion_liquidada_id integer)
    RETURNS char(14) AS
      $BODY$
        DECLARE
          prestacion_liquidada RECORD;       -- La prestación liquidada correspondiente al parámetro
          dato_reportable_ceo_c RECORD;      -- Dato reportable con código CEO_C (caries)
          dato_reportable_ceo_e RECORD;      -- Dato reportable con código CEO_E (extracción indicada)
          dato_reportable_ceo_o RECORD;      -- Dato reportable con código CEO_O (obturados)
          valor_ceo_c integer;               -- Valor de caries
          valor_ceo_e integer;               -- Valor de extracciones indicadas
          valor_ceo_o integer;               -- Valor de obturados
          valor_de_retorno char(14);         -- El dato reportable asociado a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_ceo_c FROM datos_reportables WHERE codigo = 'CEO_C';
          SELECT * INTO dato_reportable_ceo_e FROM datos_reportables WHERE codigo = 'CEO_P';
          SELECT * INTO dato_reportable_ceo_o FROM datos_reportables WHERE codigo = 'CEO_O';

          -- Buscamos los valores de los datos reportables del índice CeO
          EXECUTE '
            SELECT valor_' || dato_reportable_ceo_c.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_ceo_c.id || ';' INTO valor_ceo_c;
          EXECUTE '
            SELECT valor_' || dato_reportable_ceo_e.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_ceo_e.id || ';' INTO valor_ceo_e;
          EXECUTE '
            SELECT valor_' || dato_reportable_ceo_o.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_ceo_o.id || ';' INTO valor_ceo_o;

          -- Construimos el valor de salida únicamente si tenemos los tres datos
          IF (valor_ceo_c IS NOT NULL AND valor_ceo_e IS NOT NULL AND valor_ceo_o IS NOT NULL) THEN
            SELECT
                (
                  'c:'::text ||
                  trim(to_char(valor_ceo_c, '00')) ||
                  '/e:'::text ||
                  trim(to_char(valor_ceo_e, '00')) ||
                  '/o:'::text ||
                  trim(to_char(valor_ceo_o, '00'))
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