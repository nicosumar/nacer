class CreateNotasDeDebito < ActiveRecord::Migration
  def up
    create_table :notas_de_debito do |t|
      t.string :numero
      t.references :efector
      t.references :concepto_de_facturacion
      t.references :tipo_de_nota_debito
      t.text :observaciones
      t.column :monto, "numeric(15,4)"
      t.column :remanente, "numeric(15,4)"
      t.column :reservado, "numeric(15,4)"

      t.timestamps
    end
    add_index :notas_de_debito, :efector_id
    add_index :notas_de_debito, :concepto_de_facturacion_id
    add_index :notas_de_debito, :tipo_de_nota_debito_id

    execute <<-SQL
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

      CREATE TRIGGER "generar_numero_de_nota" AFTER INSERT ON "public"."notas_de_debito"
      FOR EACH ROW
      EXECUTE PROCEDURE "public"."generar_numero_de_nota_debito"();
    SQL

  end

  def down
    drop_table :notas_de_debito
  end
end
