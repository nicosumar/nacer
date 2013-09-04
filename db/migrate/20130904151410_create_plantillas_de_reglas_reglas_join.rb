class CreatePlantillasDeReglasReglasJoin < ActiveRecord::Migration
  def up
  	create_table :plantillas_de_reglas_reglas, id: false do |t|
  	  t.references :regla
  	  t.references :plantilla_de_reglas
  	end

  	add_index :plantillas_de_reglas_reglas, ["regla_id", "plantilla_de_reglas_id"], name: 'plantilla_reglas_reglas_idx'
  	execute <<-SQL
  	  ALTER TABLE "public"."plantillas_de_reglas_reglas"
  	    ADD FOREIGN KEY ("regla_id") REFERENCES "public"."reglas" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
  	    ADD FOREIGN KEY ("plantilla_de_reglas_id") REFERENCES "public"."plantillas_de_reglas" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
  	SQL
  end

  def down
  	execute <<-SQL
  	  ALTER TABLE "public"."plantillas_de_reglas_reglas"
  	    DROP CONSTRAINT IF EXISTS "plantillas_de_reglas_reglas_plantilla_de_reglas_id_fkey",
  	    DROP CONSTRAINT IF EXISTS "plantillas_de_reglas_reglas_regla_id_fkey";
  	SQL
  	drop_table :plantillas_de_reglas_reglas
  end
end
