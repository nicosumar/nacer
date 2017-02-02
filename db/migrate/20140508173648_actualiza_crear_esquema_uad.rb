# -*- encoding : utf-8 -*-
class ActualizaCrearEsquemaUad < ActiveRecord::Migration
def change
	# Actualizo las tablas de prestaciones brindadas ya existentes agregando un indice para efectores 
  # y otro para los estados de las prestaciones
  execute <<-SQL
    DO $$
    DECLARE
      sql_text text;
      esquemas_de_uads CURSOR FOR
      SELECT DISTINCT table_schema
        FROM information_schema.tables
        WHERE table_name = 'prestaciones_brindadas' ORDER BY table_schema;
    BEGIN
      FOR uad IN esquemas_de_uads LOOP
        sql_text := 'ALTER TABLE "'||uad.table_schema||'"."prestaciones_brindadas" '||
          ' ADD COLUMN "estado_de_la_prestacion_liquidada_id" int4, '||
          ' ADD COLUMN "observaciones_de_liquidacion" text, '||
          ' ADD CONSTRAINT fk_uad_' || uad.table_schema || '_prestaciones_brindadas '||
          '    FOREIGN KEY (estado_de_la_prestacion_liquidada_id) REFERENCES estados_de_las_prestaciones(id);'||
          ' CREATE INDEX  ON "'||uad.table_schema||'"."prestaciones_brindadas" ("efector_id"  ); '||
          ' CREATE INDEX  ON "'||uad.table_schema||'"."prestaciones_brindadas" ("fecha_de_la_prestacion"  ); '||
          ' CREATE INDEX  ON "'||uad.table_schema||'"."prestaciones_brindadas" ("estado_de_la_prestacion_id"  ); ';
         --raise INFO 'texto: %',sql_text; 
         execute sql_text;
      END LOOP;
    END$$;
  SQL

  # Crear las funciones y disparadores que se encargan de modificar la estructura de la BB.DD.
  # cada vez que se agrega una nueva unidad de alta de datos
  load 'db/sp/trigger_crear_esquema_para_uad.rb'

    # Agrego el estado de vencida a los estados de las prestaciones

    EstadoDeLaPrestacion.create([
      { #ID: 13
        nombre: "Vencida",
        codigo: "W",
        pendiente: false,
        indexable: false
      }])
  end
end
