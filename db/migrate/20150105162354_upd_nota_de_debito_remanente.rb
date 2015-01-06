class UpdNotaDeDebitoRemanente < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION "public"."notas_de_debito_remanente_x_defecto"()
          RETURNS "pg_catalog"."trigger" AS $BODY$DECLARE 
      BEGIN
        IF (TG_OP = 'INSERT') THEN
          NEW.remanente = NEW.monto;
        END IF;
        RETURN NEW;
      END ; $BODY$
      LANGUAGE 'plpgsql' VOLATILE;
    SQL
  end

  def down
    execute <<-SQL
      CREATE OR REPLACE FUNCTION "public"."notas_de_debito_remanente_x_defecto"()
          RETURNS "pg_catalog"."trigger" AS $BODY$DECLARE 
      BEGIN
        NEW.remanente = NEW.monto;
        RETURN NEW;
      END ; $BODY$
      LANGUAGE 'plpgsql' VOLATILE;
    SQL
  end
end
