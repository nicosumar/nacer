class CreateTriggerModificarVistaGlobalDePrestacionesBrindadas < ActiveRecord::Migration
  def up
    execute "
      CREATE OR REPLACE FUNCTION modificar_vista_global_de_prestaciones_brindadas() RETURNS trigger AS
      $BODY$
        DECLARE
          sql_text text;
          esquemas_de_uads CURSOR FOR
            SELECT DISTINCT table_schema
              FROM information_schema.tables
              WHERE table_name = 'prestaciones_brindadas' ORDER BY table_schema;
        BEGIN
          sql_text := '';
          FOR uad IN esquemas_de_uads LOOP
            IF length(sql_text) > 0 THEN
              sql_text :=
                sql_text ||
                ' UNION ALL SELECT ''' ||
                uad.table_schema ||
                '''::text AS esquema, * FROM \"' ||
                uad.table_schema ||
                '\".\"prestaciones_brindadas\"';
            ELSE
              sql_text :=
                'SELECT ''' ||
                uad.table_schema ||
                '''::text AS esquema, * FROM \"' ||
                uad.table_schema ||
                '\".\"prestaciones_brindadas\"';
            END IF;
          END LOOP;
          EXECUTE '
            -- Creamos la vista que trae los datos completos de todas las prestaciones brindadas registradas
            CREATE OR REPLACE VIEW \"public\".\"vista_global_de_prestaciones_brindadas\" AS
              ' || sql_text || ';';
          RETURN NULL;
        END;
      $BODY$
      LANGUAGE plpgsql;

      CREATE TRIGGER trg_modificar_vista_global_de_prestaciones_brindadas
        AFTER INSERT OR UPDATE OF facturacion
        ON unidades_de_alta_de_datos
        FOR EACH STATEMENT
        EXECUTE PROCEDURE modificar_vista_global_de_prestaciones_brindadas();
    "

  end

  def down

  end
end
