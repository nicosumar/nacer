# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL
  -- Function: "verificar_duplicacion_de_prestaciones()"()
  -- DROP FUNCTION "verificar_duplicacion_de_prestaciones()"();
  CREATE OR REPLACE FUNCTION verificar_duplicacion_de_prestaciones()
    RETURNS trigger AS
  $BODY$
          DECLARE
            duplicada bool;
          BEGIN
            -- Si el estado de la prestación que se inserta/modifica es un estado anulado dejamos que continúe
            IF NEW.estado_de_la_prestacion_id IN (SELECT id FROM estados_de_las_prestaciones WHERE codigo IN ('U', 'S')) THEN
              RETURN NEW; 
            ELSIF NEW.clave_de_beneficiario IS NULL THEN
              RETURN NEW;
            END IF;

            -- Para todos los otros estados verificamos que la operación no cree un duplicado
            IF (TG_OP = 'INSERT') THEN
              EXECUTE '
              SELECT COUNT(*) > 0
                FROM '|| TG_TABLE_SCHEMA ||'.prestaciones_brindadas pb
                WHERE
                  pb.clave_de_beneficiario = ''' || NEW.clave_de_beneficiario || '''
                  AND pb.fecha_de_la_prestacion = ''' || NEW.fecha_de_la_prestacion || '''
                  AND pb.prestacion_id = ' || NEW.prestacion_id || '
                  AND estado_de_la_prestacion_id NOT IN (
                    SELECT id FROM estados_de_las_prestaciones WHERE codigo IN (''U'', ''S'')
                  )' INTO duplicada;
            ELSIF (TG_OP = 'UPDATE') THEN
               EXECUTE '
              SELECT COUNT(*) > 0
                FROM '||TG_TABLE_SCHEMA||'.prestaciones_brindadas pb
                WHERE
                  pb.clave_de_beneficiario = ''' || NEW.clave_de_beneficiario || '''
                  AND pb.fecha_de_la_prestacion = ''' || NEW.fecha_de_la_prestacion || '''
                  AND pb.prestacion_id = ' || NEW.prestacion_id || '
                  AND estado_de_la_prestacion_id NOT IN (
                    SELECT id FROM estados_de_las_prestaciones WHERE codigo IN (''U'', ''S'')
                  )
                  AND pb.id <> ' || OLD.id INTO duplicada;
            END IF;

            IF duplicada THEN
              RAISE EXCEPTION 'El % falló debido a que duplicaría una prestación ya registrada (clave: ''%'', fecha: ''%'', prestacion: ''%'', prestacion_brindada_id: "%", esquema: "%")',
                TG_OP, NEW.clave_de_beneficiario, NEW.fecha_de_la_prestacion, NEW.prestacion_id, NEW.id, TG_TABLE_SCHEMA;
              RETURN NULL;
            END IF;

            -- No se encontraron duplicados, se puede proceder a la inserción o actualización
            RETURN NEW;
          END;
        $BODY$
    LANGUAGE plpgsql VOLATILE
    COST 100;
  ALTER FUNCTION verificar_duplicacion_de_prestaciones()
    OWNER TO nacer_adm;

SQL