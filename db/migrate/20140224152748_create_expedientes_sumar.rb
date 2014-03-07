class CreateExpedientesSumar < ActiveRecord::Migration
  def up
    create_table :expedientes_sumar do |t|
      t.text :numero
      t.references :tipo_de_expediente

      t.timestamps
    end
    add_index :expedientes_sumar, :tipo_de_expediente_id

    execute <<-SQL
      CREATE OR REPLACE FUNCTION "public"."generar_numero_de_expediente" () 
      RETURNS "pg_catalog"."trigger" AS $BODY$
      DECLARE 
        v_tipo_de_exp INT ; 
        v_query TEXT ; 
        v_secuencia_nombre VARCHAR ; 
        v_prefijo tipos_de_expedientes.codigo%TYPE; 
        v_mascara tipos_de_expedientes.mascara%TYPE; 
        v_secuencia BIGINT;
      BEGIN
        v_query := 'select  nombre_de_secuencia, codigo, mascara from tipos_de_expedientes' || 
             ' where id =' || NEW .tipo_de_expediente_id; 
        EXECUTE v_query INTO v_secuencia_nombre,  v_prefijo,  v_mascara ; 

        v_secuencia = nextval(v_secuencia_nombre::TEXT); 
        NEW.numero = v_prefijo || TRIM(to_char(v_secuencia, v_mascara)); 

        RETURN NEW;
      END ; $BODY$ LANGUAGE 'plpgsql' VOLATILE COST 100;

      CREATE TRIGGER "generar_numero_de_expediente" BEFORE INSERT ON "public"."expedientes_sumar"
        FOR EACH ROW
        EXECUTE PROCEDURE "public"."generar_numero_de_expediente"();
      ALTER TABLE "public"."expedientes_sumar" DISABLE TRIGGER "generar_numero_de_expediente";
      
    SQL
  end

  def down
    drop_table :expedientes_sumar
  end

end
