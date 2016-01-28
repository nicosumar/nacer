# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_resultado_vdrl()
  CREATE OR REPLACE FUNCTION sirge_dr_resultado_vdrl(IN prestacion_liquidada_id integer)
    RETURNS char(1) AS
      $BODY$
        DECLARE
          prestacion_liquidada RECORD;        -- La prestación liquidada correspondiente al parámetro
          dato_reportable_vdrl RECORD;        -- Dato reportable con código VDRL
          resultado_vdrl_id integer;          -- El ID del resultado del análisis de VDRL seleccionado
          resultado_vdrl RECORD;              -- El resultado del análisis VDRL asociado
          valor_de_retorno char(1);           -- El dato reportable asociado a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_vdrl FROM datos_reportables WHERE codigo = 'VDRL';

          -- Buscamos primero el dato más nuevo
          EXECUTE '
            SELECT valor_' || dato_reportable_vdrl.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_vdrl.id || ';' INTO resultado_vdrl_id;

          IF (resultado_vdrl_id IS NOT NULL) THEN
            -- Si hay dato nuevo, devolvemos la cadena de acuerdo con la opción seleccionada
            SELECT * INTO resultado_vdrl FROM resultados_vdrl WHERE id = resultado_vdrl_id;
            SELECT resultado_vdrl.codigo_sirge::char(1) INTO valor_de_retorno;
          ELSE
            SELECT NULL::char(1) INTO valor_de_retorno;
          END IF;

          RETURN valor_de_retorno;

        END;
      $BODY$
    LANGUAGE plpgsql VOLATILE
    RETURNS NULL ON NULL INPUT
    COST 100;
SQL