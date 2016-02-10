# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_peso()
  CREATE OR REPLACE FUNCTION sirge_dr_peso(IN prestacion_liquidada_id integer)
    RETURNS numeric(6, 3) AS
      $BODY$
        DECLARE
          prestacion_liquidada RECORD;       -- La prestación liquidada correspondiente al parámetro
          dato_reportable_pkg RECORD;        -- Dato reportable con código PKG (peso en kg antes)
          dato_reportable_pkg2 RECORD;       -- Dato reportable con código PKG2 (peso en kg nuevo)
          valor_de_retorno numeric(6, 3);    -- El dato reportable asociado a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_pkg FROM datos_reportables WHERE codigo = 'PKG';
          SELECT * INTO dato_reportable_pkg2 FROM datos_reportables WHERE codigo = 'PKG2';

          -- Buscamos primero el dato más nuevo
          EXECUTE '
            SELECT valor_' || dato_reportable_pkg2.tipo_ruby || '::numeric(6, 3)
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_pkg2.id || ';' INTO valor_de_retorno;

          -- Si no hay dato nuevo, buscamos el anterior
          IF (valor_de_retorno IS NULL) THEN
            EXECUTE '
              SELECT valor_' || dato_reportable_pkg.tipo_ruby || '::numeric(6, 3)
                FROM
                  ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                  INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                  INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
                WHERE
                  dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                  AND dr.id = ' || dato_reportable_pkg.id || ';' INTO valor_de_retorno;
          END IF;

          RETURN valor_de_retorno;

        END;
      $BODY$
    LANGUAGE plpgsql VOLATILE
    RETURNS NULL ON NULL INPUT
    COST 100;
SQL