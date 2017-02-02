# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: codigo_de_prestacion_con_diagnosticos
  CREATE OR REPLACE FUNCTION codigo_de_prestacion_con_diagnosticos(IN ppdss_id integer)
    RETURNS varchar(255) AS
      $BODY$
        DECLARE
          codigo_de_prestacion text;         -- El código de prestación asociado a la prestacion_pdss
          cantidad_de_diagnosticos integer;  -- La cantidad de diagnósticos asociados con la/s prestación/es relacionadas
          diagnosticos_asociados CURSOR FOR  -- Los diagnósticos asociados con la/s prestación/es relacionadas
            SELECT DISTINCT d.codigo
              FROM
                diagnosticos d
                JOIN diagnosticos_prestaciones dp ON dp.diagnostico_id = d.id
                JOIN prestaciones p ON dp.prestacion_id = p.id
                JOIN prestaciones_prestaciones_pdss ppp ON ppp.prestacion_id = p.id
              WHERE
                ppp.prestacion_pdss_id = ppdss_id
              ORDER BY d.codigo;
          diagnostico_asociado RECORD;       -- Un diagnóstico asociado
          valor_de_retorno varchar(255);     -- La cadena a devolver

        BEGIN
          -- Buscar los ID de los datos reportables asociados
          SELECT p.codigo INTO codigo_de_prestacion
            FROM
              prestaciones p
              JOIN prestaciones_prestaciones_pdss ppp ON ppp.prestacion_id = p.id
            WHERE ppp.prestacion_pdss_id = ppdss_id
            LIMIT 1;

          SELECT COUNT(DISTINCT d.codigo) INTO cantidad_de_diagnosticos
            FROM
              diagnosticos d
              JOIN diagnosticos_prestaciones dp ON dp.diagnostico_id = d.id
              JOIN prestaciones p ON dp.prestacion_id = p.id
              JOIN prestaciones_prestaciones_pdss ppp ON ppp.prestacion_id = p.id
            WHERE
              ppp.prestacion_pdss_id = ppdss_id;

          IF ( cantidad_de_diagnosticos = 1 ) THEN
            OPEN diagnosticos_asociados;
            FETCH diagnosticos_asociados INTO diagnostico_asociado;
            valor_de_retorno := codigo_de_prestacion || diagnostico_asociado.codigo;
            CLOSE diagnosticos_asociados;
          ELSIF ( cantidad_de_diagnosticos < 35 ) THEN
            valor_de_retorno := codigo_de_prestacion || ' '::text;
            FOR diagnostico_asociado IN diagnosticos_asociados LOOP
              valor_de_retorno := valor_de_retorno || diagnostico_asociado.codigo || ' · ';
            END LOOP;
            valor_de_retorno := LEFT(valor_de_retorno, -3);
          ELSE
            valor_de_retorno := codigo_de_prestacion || 'xxx (VMD*)'::text;
          END IF;

          RETURN valor_de_retorno;

        END;
      $BODY$
    LANGUAGE plpgsql VOLATILE
    RETURNS NULL ON NULL INPUT
    COST 100;
SQL