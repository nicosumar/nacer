# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: sirge_dr_tratamiento_instaurado_cu()
  CREATE OR REPLACE FUNCTION sirge_dr_tratamiento_instaurado_cu(IN prestacion_liquidada_id integer)
    RETURNS integer AS
      $BODY$

        DECLARE
          prestacion_liquidada RECORD;        -- La prestación liquidada correspondiente al parámetro
          dato_reportable_tratc RECORD;       -- Dato reportable con código TRATC
          tratamiento_instaurado_id integer;  -- El ID del tratamiento instaurado seleccionado
          tratamiento_instaurado RECORD;      -- El tratamiento instaurado asociado
          valor_de_retorno integer;           -- El valor a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT * INTO prestacion_liquidada FROM prestaciones_liquidadas WHERE id = prestacion_liquidada_id;
          SELECT * INTO dato_reportable_tratc FROM datos_reportables WHERE codigo = 'TRATC';

          -- Buscamos primero el dato
          EXECUTE '
            SELECT valor_' || dato_reportable_tratc.tipo_ruby || '::integer
              FROM
                ' || prestacion_liquidada.esquema || '.datos_reportables_asociados dra
                INNER JOIN public.datos_reportables_requeridos drr ON drr.id = dra.dato_reportable_requerido_id
                INNER JOIN public.datos_reportables dr ON dr.id = drr.dato_reportable_id
              WHERE
                dra.prestacion_brindada_id = ' || prestacion_liquidada.prestacion_brindada_id || '
                AND dr.id = ' || dato_reportable_tratc.id || ';' INTO tratamiento_instaurado_id;

          IF (tratamiento_instaurado_id IS NOT NULL) THEN
            -- Si hay dato, devolvemos el código de acuerdo con la opción seleccionada
            SELECT * INTO tratamiento_instaurado FROM tratamientos_instaurados_cu
              WHERE id = tratamiento_instaurado_id;
            SELECT tratamiento_instaurado.codigo_sirge INTO valor_de_retorno;
          ELSE
            SELECT NULL::integer INTO valor_de_retorno;
          END IF;

          RETURN valor_de_retorno;
        END;

      $BODY$
    LANGUAGE plpgsql VOLATILE
    RETURNS NULL ON NULL INPUT
    COST 100;
SQL