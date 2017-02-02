# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_peso()
  CREATE OR REPLACE FUNCTION sirge_dr_talla(IN prestacion_liquidada_id integer)
    RETURNS numeric(4, 1) AS
      $BODY$
        DECLARE
          prestacion_liquidada RECORD;       -- La prestación liquidada correspondiente al parámetro
          dato_reportable_tcm RECORD;        -- Dato reportable con código TCM (talla en cm antes)
          dato_reportable_tcm2 RECORD;       -- Dato reportable con código TCM2 (talla en cm nuevo)
          dato_reportable_tm RECORD;         -- Dato reportable con código TM (talla en m)
          valor_de_retorno numeric(4, 1);    -- El dato reportable asociado a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_tcm2 FROM datos_reportables WHERE codigo = 'TCM2';
          SELECT * INTO dato_reportable_tcm FROM datos_reportables WHERE codigo = 'TCM';
          SELECT * INTO dato_reportable_tm FROM datos_reportables WHERE codigo = 'TM';

          -- Buscamos primero el dato más nuevo
          EXECUTE '
            SELECT valor_' || dato_reportable_tcm2.tipo_ruby || '::numeric(4, 1)
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_tcm2.id || ';' INTO valor_de_retorno;

          -- Si no hay dato nuevo, buscamos el anterior en cm
          IF (valor_de_retorno IS NULL) THEN
            EXECUTE '
              SELECT valor_' || dato_reportable_tcm.tipo_ruby || '::numeric(4, 1)
                FROM
                  ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                  INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                  INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
                WHERE
                  dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                  AND dr.id = ' || dato_reportable_tcm.id || ';' INTO valor_de_retorno;
          END IF;

          -- Si tampoco está nos fijamos si lo podemos convertir desde el de metros
          IF (valor_de_retorno IS NULL) THEN
            EXECUTE '
              SELECT (valor_' || dato_reportable_tm.tipo_ruby || '::numeric * 100.0::numeric)::numeric(4, 1)
                FROM
                  ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                  INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                  INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
                WHERE
                  dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                  AND dr.id = ' || dato_reportable_tm.id || ';' INTO valor_de_retorno;
          END IF;

          RETURN valor_de_retorno;

        END;
      $BODY$
    LANGUAGE plpgsql VOLATILE
    RETURNS NULL ON NULL INPUT
    COST 100;
SQL