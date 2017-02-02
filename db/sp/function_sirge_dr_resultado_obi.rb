# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_resultado_obi()
  CREATE OR REPLACE FUNCTION sirge_dr_resultado_obi(IN prestacion_liquidada_id integer)
    RETURNS numeric(6, 3) AS
      $BODY$
        DECLARE
          prestacion_liquidada RECORD;       -- La prestación liquidada correspondiente al parámetro
          dato_reportable_rop RECORD;        -- Dato reportable con código ROP
          valor_de_retorno integer;          -- El dato reportable asociado a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_rop FROM datos_reportables WHERE codigo = 'ROP';

          -- Buscamos primero el dato más nuevo
          EXECUTE '
            SELECT valor_' || dato_reportable_rop.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND drr.minimo = 0.0::numeric(15, 4)
                AND dr.id = ' || dato_reportable_rop.id || ';' INTO valor_de_retorno;

          -- Si no hay dato nuevo, buscamos el anterior
          IF (valor_de_retorno IS NULL) THEN
          EXECUTE '
            SELECT valor_' || dato_reportable_rop.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND drr.minimo = 1.0::numeric(15, 4)
                AND dr.id = ' || dato_reportable_rop.id || ';' INTO valor_de_retorno;
            IF (valor_de_retorno IS NULL) THEN
              SELECT 0::integer INTO valor_de_retorno;
            END IF;
          END IF;

          RETURN valor_de_retorno;

        END;
      $BODY$
    LANGUAGE plpgsql VOLATILE
    RETURNS NULL ON NULL INPUT
    COST 100;
SQL