class AddIrDocumentacionRespaldatoria < ActiveRecord::Migration
  def up
  	drop_table :documentaciones_respaldatorias_prestaciones

  	create_table :documentaciones_respaldatorias_prestaciones  do |t|
      t.references :documentacion_respaldatoria
      t.references :prestacion
      t.timestamps
    end 

  	execute <<-SQL
		ALTER TABLE "public"."documentaciones_respaldatorias_prestaciones"
		ADD FOREIGN KEY ("documentacion_respaldatoria_id") 
			REFERENCES "public"."documentaciones_respaldatorias" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
		ADD FOREIGN KEY ("prestacion_id") 
			REFERENCES "public"."prestaciones" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

		CREATE INDEX  ON "public"."documentaciones_respaldatorias_prestaciones" ("documentacion_respaldatoria_id"  , "prestacion_id"  );
		CREATE INDEX  ON "public"."documentaciones_respaldatorias_prestaciones" ("documentacion_respaldatoria_id"  );
		CREATE INDEX  ON "public"."documentaciones_respaldatorias_prestaciones" ("prestacion_id"  );
  	SQL

  	load 'db/DocumentacionesRespaldatorias_seed.rb'
  end

  def down
  	drop_table :documentaciones_respaldatorias_prestaciones

    create_table :documentaciones_respaldatorias_prestaciones, :id => false do |t|
      t.references :documentacion_respaldatoria
      t.references :prestacion
    end
    
    load 'db/DocumentacionesRespaldatorias_seed.rb'
  end
end
