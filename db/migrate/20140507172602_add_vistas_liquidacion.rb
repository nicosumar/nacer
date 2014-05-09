# -*- encoding : utf-8 -*-
class AddVistasLiquidacion < ActiveRecord::Migration
  def up
    execute "
      CREATE OR REPLACE FUNCTION modificar_vista_global_de_datos_reportables_asociados() RETURNS trigger AS
      $BODY$
        DECLARE
          sql_text text;
          esquemas_de_uads CURSOR FOR
            SELECT DISTINCT table_schema
              FROM information_schema.tables
              WHERE table_name = 'datos_reportables_asociados' ORDER BY table_schema;
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
                '\".\"datos_reportables_asociados\"';
            ELSE
              sql_text :=
                'SELECT ''' ||
                uad.table_schema ||
                '''::text AS esquema, * FROM \"' ||
                uad.table_schema ||
                '\".\"datos_reportables_asociados\"';
            END IF;
          END LOOP;
          EXECUTE '
            -- Creamos la vista que trae los datos completos de todas las datos reportables registradas
            CREATE OR REPLACE VIEW \"public\".\"vista_global_de_datos_reportables_asociados\" AS
              ' || sql_text || ';';
          RETURN NULL;
        END;
      $BODY$
      LANGUAGE plpgsql;

      CREATE TRIGGER trg_modificar_vista_global_de_datos_reportables_asociados
        AFTER INSERT OR UPDATE OF facturacion
        ON unidades_de_alta_de_datos
        FOR EACH STATEMENT
        EXECUTE PROCEDURE modificar_vista_global_de_datos_reportables_asociados();
    "

    execute "
      CREATE OR REPLACE FUNCTION modificar_vista_global_de_metodos_de_validacion_fallados() RETURNS trigger AS
      $BODY$
        DECLARE
          sql_text text;
          esquemas_de_uads CURSOR FOR
            SELECT DISTINCT table_schema
              FROM information_schema.tables
              WHERE table_name = 'metodos_de_validacion_fallados' ORDER BY table_schema;
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
                '\".\"metodos_de_validacion_fallados\"';
            ELSE
              sql_text :=
                'SELECT ''' ||
                uad.table_schema ||
                '''::text AS esquema, * FROM \"' ||
                uad.table_schema ||
                '\".\"metodos_de_validacion_fallados\"';
            END IF;
          END LOOP;
          EXECUTE '
            -- Creamos la vista que trae los datos completos de todas las metodos de validación fallados registrados
            CREATE OR REPLACE VIEW \"public\".\"vista_global_de_metodos_de_validacion_fallados\" AS
              ' || sql_text || ';';
          RETURN NULL;
        END;
      $BODY$
      LANGUAGE plpgsql;

      CREATE TRIGGER trg_modificar_vista_global_de_metodos_de_validacion_fallados
        AFTER INSERT OR UPDATE OF facturacion
        ON unidades_de_alta_de_datos
        FOR EACH STATEMENT
        EXECUTE PROCEDURE modificar_vista_global_de_metodos_de_validacion_fallados();

      UPDATE unidades_de_alta_de_datos SET facturacion = facturacion WHERE id = 2;
    "

  end

  def down

  end
end
