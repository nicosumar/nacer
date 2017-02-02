class CreateNotasDeDebito < ActiveRecord::Migration
  def up
    create_table :notas_de_debito do |t|
      t.string :numero, null: false
      t.references :efector, null: false
      t.references :concepto_de_facturacion, null: false
      t.references :tipo_de_nota_debito, null: false
      t.text :observaciones, null: false
      t.column :monto, "numeric(15,4)", null: false
      t.column :remanente, "numeric(15,4)", null: false
      t.column :reservado, "numeric(15,4)", default: 0, null: false

      t.timestamps
    end

    add_index :notas_de_debito, :efector_id
    add_index :notas_de_debito, :concepto_de_facturacion_id
    add_index :notas_de_debito, :tipo_de_nota_debito_id

    execute <<-SQL
      CREATE OR REPLACE FUNCTION "public"."notas_de_debito_remanente_x_defecto"()
        RETURNS "pg_catalog"."trigger" AS $BODY$DECLARE 
      BEGIN
        NEW.remanente = NEW.monto;
        RETURN NEW;
      END ; $BODY$
      LANGUAGE 'plpgsql' VOLATILE;

      CREATE OR REPLACE FUNCTION "public"."generar_numero_de_nota_debito"()
        RETURNS "pg_catalog"."trigger" AS $BODY$DECLARE 
        v_query TEXT ; 
        v_secuencia_nombre VARCHAR ; 
        v_mascara tipos_de_notas_debito.mascara%TYPE; 
        v_secuencia BIGINT;
      BEGIN
        v_query := 'select  nombre_de_secuencia, mascara from tipos_de_notas_debito' || 
                   ' where id =' || NEW.tipo_de_nota_debito_id; 
        EXECUTE v_query INTO v_secuencia_nombre,  v_mascara ; 

        v_secuencia = nextval(v_secuencia_nombre::TEXT); 
        NEW.numero = TRIM(to_char(v_secuencia, v_mascara)); 

        RETURN NEW;
      END ; $BODY$
      LANGUAGE 'plpgsql' VOLATILE;

      CREATE TRIGGER "generar_numero_de_nota" BEFORE INSERT ON "public"."notas_de_debito"
        FOR EACH ROW
        EXECUTE PROCEDURE "public"."generar_numero_de_nota_debito"();
      CREATE TRIGGER "notas_de_debito_remanente_x_defecto" BEFORE INSERT OR UPDATE ON "public"."notas_de_debito"
        FOR EACH ROW
        EXECUTE PROCEDURE "public"."notas_de_debito_remanente_x_defecto"();

      /* Constrains FK */
      ALTER TABLE "public"."notas_de_debito"
        ADD FOREIGN KEY ("efector_id") REFERENCES "public"."efectores" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD FOREIGN KEY ("concepto_de_facturacion_id") REFERENCES "public"."conceptos_de_facturacion" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD FOREIGN KEY ("tipo_de_nota_debito_id") REFERENCES "public"."tipos_de_notas_debito" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
    SQL

  end

  def down
    drop_table :notas_de_debito
  end
end
