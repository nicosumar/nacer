class AddIndexToJoinTables < ActiveRecord::Migration
  def up
    execute <<-SQL

      CREATE INDEX  ON "public"."diagnosticos_prestaciones" ("prestacion_id"  );
      CREATE INDEX  ON "public"."diagnosticos_prestaciones" ("diagnostico_id"  );
      CREATE UNIQUE INDEX  ON "public"."diagnosticos_prestaciones" ("diagnostico_id"  , "prestacion_id"  );

      CREATE UNIQUE INDEX  ON "public"."prestaciones" USING btree ("id"  );



    SQL
  end
end
