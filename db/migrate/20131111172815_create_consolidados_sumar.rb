class CreateConsolidadosSumar < ActiveRecord::Migration
  def up
    create_table :consolidados_sumar do |t|
      t.string :numero_de_consolidado
      t.date :fecha
      t.references :efector
      t.references :firmante
      t.references :periodo
      t.references :liquidacion_sumar

      t.timestamps
    end
    add_index :consolidados_sumar, :efector_id
    add_index :consolidados_sumar, :firmante_id
    add_index :consolidados_sumar, :periodo_id
    add_index :consolidados_sumar, :liquidacion_sumar_id

    execute <<-SQL

      ALTER TABLE "public"."consolidados_sumar"
      ADD FOREIGN KEY ("efector_id") REFERENCES "public"."efectores" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD FOREIGN KEY ("firmante_id") REFERENCES "public"."contactos" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD FOREIGN KEY ("periodo_id") REFERENCES "public"."periodos" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD FOREIGN KEY ("liquidacion_sumar_id") REFERENCES "public"."liquidaciones_sumar" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD UNIQUE ("numero_de_consolidado"),
      ADD UNIQUE ("efector_id", "periodo_id"),
      ADD UNIQUE ("efector_id", "liquidacion_sumar_id");

      --creo la funcion que genera el numero de consolidado
      CREATE OR REPLACE FUNCTION "public"."generar_numero_consolidado"()
      RETURNS "pg_catalog"."trigger" AS $BODY$DECLARE 
      v_secuencia INT;
      v_secuencia_nombre VARCHAR;
      v_anio VARCHAR;
      BEGIN 
        v_secuencia_nombre = 'consolidado_sumar_seq_efector_id_'||CAST(NEW.efector_id  as varchar);
        v_secuencia =  nextval(v_secuencia_nombre::text);

        NEW.numero_de_consolidado = trim(to_char(NEW.efector_id, '0000')) ||'-A-'|| trim(to_char(v_secuencia, '00000000'));
             
        RETURN NEW;
      END;$BODY$
        LANGUAGE 'plpgsql' VOLATILE COST 100
      ;

      --incluyo el trigger en la tabla
      CREATE TRIGGER "generar_numero_consolidado" BEFORE INSERT ON "public"."consolidados_sumar"
      FOR EACH ROW
      EXECUTE PROCEDURE "public"."generar_numero_consolidado"();

    SQL

    # genero las secuencias para los efectores cargados hasta el momento

    
    Efector.all.each do |e|
      if e.es_administrador?
        execute "CREATE SEQUENCE \"public\".\"consolidado_sumar_seq_efector_id_#{e.id}\"\n"+
              "INCREMENT 1\n"+
              "MINVALUE 1\n"+
              "MAXVALUE 9223372036854775807\n"+
              "START 1;\n"+
              "ALTER TABLE \"public\".\"consolidado_sumar_seq_efector_id_#{e.id}\" OWNER TO \"nacer_adm\";"
      end
    end
    
  end

  def down
    drop_table :consolidados_sumar
    execute <<-SQL
      DROP FUNCTION IF EXISTS generar_numero_consolidado();
    SQL
    Efector.all.each do |e|
      execute "DROP SEQUENCE IF EXISTS public.consolidado_sumar_seq_efector_id_#{e.id};"
    end

  end
end
