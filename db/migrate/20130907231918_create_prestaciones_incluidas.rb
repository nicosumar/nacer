class CreatePrestacionesIncluidas < ActiveRecord::Migration
  def up
    create_table :prestaciones_incluidas do |t|
      # Liquidacion
      t.references :liquidacion
      # Nomencladores
      t.references :nomenclador
      t.string :nomenclador_nombre
      # Prestaciones
      t.references :prestacion
      t.string :prestacion_nombre
      t.string :prestacion_codigo
      t.boolean :prestacion_cobertura
      t.boolean :prestacion_comunitaria
      t.boolean :prestacion_requiere_hc
      t.string :prestacion_concepto_nombre

      t.timestamps
    end

    execute <<-SQL
      CREATE UNIQUE INDEX "unq_ll_nn_pp_on_prestaciones_incluidas"
        ON "public"."prestaciones_incluidas" ("liquidacion_id", "nomenclador_id", "prestacion_id");
      ALTER TABLE "public"."prestaciones_incluidas"
      ADD FOREIGN KEY ("nomenclador_id")
        REFERENCES "public"."nomencladores" ("id")
        ON DELETE NO ACTION ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("prestacion_id")
       REFERENCES "public"."prestaciones" ("id")
       ON DELETE NO ACTION ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("liquidacion_id")
        REFERENCES "public"."liquidaciones_sumar" ("id")
        ON DELETE RESTRICT ON UPDATE CASCADE,
      ADD UNIQUE USING INDEX "unq_ll_nn_pp_on_prestaciones_incluidas";

      CREATE INDEX  ON "public"."prestaciones_incluidas" USING btree ("liquidacion_id");
      CREATE INDEX  ON "public"."prestaciones_incluidas" ("nomenclador_id");
      CREATE INDEX  ON "public"."prestaciones_incluidas" ("prestacion_id");
    SQL

  end

  def down
    execute <<-SQL
    ALTER TABLE "public"."prestaciones_incluidas"
      DROP CONSTRAINT IF EXISTS "prestaciones_incluidas_prestacion_id_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_incluidas_nomenclador_id_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_incluidas_liquidacion_id_fkey";
      DROP INDEX "public"."prestaciones_incluidas_nomenclador_id_idx";
      DROP INDEX "public"."prestaciones_incluidas_prestacion_id_idx";
      DROP INDEX "public"."prestaciones_incluidas_liquidacion_id_idx";
    SQL

    drop_table :prestaciones_incluidas
  end
end
