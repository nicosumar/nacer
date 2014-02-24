class MigracionExpedientesSumar < ActiveRecord::Migration
  def up
    excecute <<-SQL
      ALTER TABLE "public"."liquidaciones_informes"
       ADD COLUMN "expediente_sumar_id" int4;
      CREATE INDEX  ON "public"."liquidaciones_informes" USING btree ("expediente_sumar_id"  );

      begin;
      INSERT INTO expedientes_sumar
      ( numero, tipo_de_expediente_id, created_at, updated_at)
      select  DISTINCT li.numero_de_expediente, 1 tipo_de_expediente, now(), now()
      from liquidaciones_informes li 
      where li.numero_de_expediente is not null;

      update liquidaciones_informes 
      set expediente_sumar_id = e.id 
      from expedientes_sumar e 
        join liquidaciones_informes l on l.numero_de_expediente = e.numero
      where l.id = liquidaciones_informes.id ;
      commit;

      ALTER TABLE "public"."liquidaciones_informes"
      DROP COLUMN "numero_de_expediente";
    SQL
  end

  def down
    excecute <<-SQL
      ALTER TABLE "public"."liquidaciones_informes"
      DROP COLUMN "expediente_sumar_id",
      ADD COLUMN "numero_de_expediente" text;
    SQL
  end
end
