class CreatePrestacionesIncluidas < ActiveRecord::Migration
  def up
    create_table :prestaciones_incluidas do |t|
      # Liquidacion
      t.references :liquidacion
      # Unidades de Alta de Datos
      t.references :unidad_de_alta_de_datos
      t.string :uad_nombre
      # Efectores
      t.references :efector
      t.string :efector_nombre
      # Nomencladores
      t.references :nomenclador
      t.string :nomenclador_nombre
      # Prestaciones
      t.references :pretsacion
      t.string :prestacion_nombre
      t.string :prestacion_codigo
      t.string :prestacion_grupo_nombre
      t.string :prestacion_subgrupo_nombre
      t.string :prestacion_area_nombre
      t.boolean :prestacion_cobertura
      t.boolean :prestacion_comunitaria
      t.boolean :prestacion_requiere_hc
      t.string :prestacion_concepto_nombre
      # Calculado
      t.decimal :monto

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE "public"."prestaciones_incluidas"
      ADD FOREIGN KEY ("unidad_de_alta_de_datos_id") 
        REFERENCES "public"."unidades_de_alta_de_datos" ("id") 
        ON DELETE NO ACTION ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("efector_id") 
        REFERENCES "public"."efectores" ("id") 
        ON DELETE NO ACTION ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("nomenclador_id") 
        REFERENCES "public"."nomencladores" ("id") 
        ON DELETE NO ACTION ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("pretsacion_id")
       REFERENCES "public"."prestaciones" ("id") 
       ON DELETE NO ACTION ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("liquidacion_id") 
        REFERENCES "public"."liquidaciones_sumar" ("id") 
        ON DELETE RESTRICT ON UPDATE CASCADE;

      CREATE INDEX  ON "public"."prestaciones_incluidas" USING btree ("liquidacion_id");
      CREATE INDEX  ON "public"."prestaciones_incluidas" ("efector_id");
      CREATE INDEX  ON "public"."prestaciones_incluidas" ("unidad_de_alta_de_datos_id");
      CREATE INDEX  ON "public"."prestaciones_incluidas" ("nomenclador_id");
      CREATE INDEX  ON "public"."prestaciones_incluidas" ("pretsacion_id");
    SQL

  end

  def down
    execute <<-SQL
    ALTER TABLE "public"."prestaciones_incluidas"
      DROP CONSTRAINT IF EXISTS "prestaciones_incluidas_pretsacion_id_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_incluidas_nomenclador_id_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_incluidas_efector_id_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_incluidas_unidad_de_alta_de_datos_id_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_incluidas_liquidacion_id_fkey";
      DROP INDEX "public"."prestaciones_incluidas_efector_id_idx";
      DROP INDEX "public"."prestaciones_incluidas_nomenclador_id_idx";
      DROP INDEX "public"."prestaciones_incluidas_pretsacion_id_idx";
      DROP INDEX "public"."prestaciones_incluidas_unidad_de_alta_de_datos_id_idx";
      DROP INDEX "public"."prestaciones_incluidas_liquidacion_id_idx";


    SQL

    drop_table :prestaciones_incluidas
  end
end
