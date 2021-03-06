class CreateTriggerModificarVistaGlobalDeNovedadesDeLosAfiliados < ActiveRecord::Migration
  def up
    execute "
      CREATE OR REPLACE FUNCTION modificar_vista_global_de_novedades_de_los_afiliados() RETURNS trigger AS
      $BODY$
        DECLARE
          sql_text text;
          esquemas_de_uads CURSOR FOR
            SELECT DISTINCT table_schema
              FROM information_schema.tables
              WHERE table_name = 'novedades_de_los_afiliados' ORDER BY table_schema;
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
                '\".\"novedades_de_los_afiliados\"';
            ELSE
              sql_text :=
                'SELECT ''' ||
                uad.table_schema ||
                '''::text AS esquema, * FROM \"' ||
                uad.table_schema ||
                '\".\"novedades_de_los_afiliados\"';
            END IF;
          END LOOP;
          EXECUTE '
            -- Creamos la vista que trae los datos completos de todas las novedades de los afiliados
            CREATE OR REPLACE VIEW \"public\".\"vista_global_de_novedades_de_los_afiliados\" AS
              ' || sql_text || ';';
          RETURN NULL;
        END;
      $BODY$
      LANGUAGE plpgsql;

      CREATE TRIGGER trg_modificar_vista_global_de_novedades_de_los_afiliados
        AFTER INSERT OR UPDATE OF inscripcion
        ON unidades_de_alta_de_datos
        FOR EACH STATEMENT
        EXECUTE PROCEDURE modificar_vista_global_de_novedades_de_los_afiliados();
    "

    execute "
      UPDATE unidades_de_alta_de_datos SET inscripcion = inscripcion, facturacion = facturacion WHERE id = 2;
    "
  end

  def down
  end
end
