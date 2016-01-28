# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_peso()
  CREATE OR REPLACE FUNCTION sirge_dr_toma_tension_arterial(IN prestacion_liquidada_id integer)
    RETURNS char(7) AS
      $BODY$
        DECLARE
          prestacion_liquidada RECORD;       -- La prestación liquidada correspondiente al parámetro
          dato_reportable_tas RECORD;        -- Dato reportable con código TAS (tensión arterial sistólica)
          dato_reportable_tad RECORD;        -- Dato reportable con código TAD (tensión arterial diastólica)
          valor_tas integer;                 -- Valor de tensión arterial sistólica
          valor_tad integer;                 -- Valor de tensión arterial diastólica
          valor_de_retorno char(7);          -- El dato reportable asociado a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_tas FROM datos_reportables WHERE codigo = 'TAS';
          SELECT * INTO dato_reportable_tad FROM datos_reportables WHERE codigo = 'TAD';

          -- Buscamos los valores de los datos reportables de TAS y TAD
          EXECUTE '
            SELECT valor_' || dato_reportable_tas.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_tas.id || ';' INTO valor_tas;

          EXECUTE '
            SELECT valor_' || dato_reportable_tad.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_tad.id || ';' INTO valor_tad;

          -- Construimos el valor de salida únicamente si tenemos ambos datos
          IF (valor_tas IS NOT NULL AND valor_tad IS NOT NULL) THEN
            SELECT
                (trim(to_char(valor_tas, '000')) || '/'::text || trim(to_char(valor_tad, '000')))::char(7)
              INTO valor_de_retorno;
          ELSE
            SELECT NULL::char(7) INTO valor_de_retorno;
          END IF;

          RETURN valor_de_retorno;

        END;
      $BODY$
    LANGUAGE plpgsql VOLATILE
    RETURNS NULL ON NULL INPUT
    COST 100;
SQL