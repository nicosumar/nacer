class CreateLiquidacionesSumarCuasifacturas < ActiveRecord::Migration
  def up
    create_table :liquidaciones_sumar_cuasifacturas do |t|
      
      t.references :liquidacion
      t.references :efector
      t.references :prestacion_incluida
      t.references :estado_de_la_prestacion
      t.column :monto, "numeric(15,4)"
      t.text :observaciones
      t.references :cuasifactura

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas"
        ADD FOREIGN KEY ("liquidacion_id") 
          REFERENCES "public"."liquidaciones_sumar" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD FOREIGN KEY ("efector_id") 
          REFERENCES "public"."efectores" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD FOREIGN KEY ("prestacion_incluida_id") 
          REFERENCES "public"."prestaciones_incluidas" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD FOREIGN KEY ("estado_de_la_prestacion_id") 
          REFERENCES "public"."estados_de_las_prestaciones" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

      CREATE INDEX  ON "public"."liquidaciones_sumar_cuasifacturas" USING btree ("liquidacion_id");
      CREATE INDEX  ON "public"."liquidaciones_sumar_cuasifacturas" USING btree ("efector_id");
      CREATE INDEX  ON "public"."liquidaciones_sumar_cuasifacturas" USING btree ("prestacion_incluida_id");
      CREATE INDEX  ON "public"."liquidaciones_sumar_cuasifacturas" USING btree ("estado_de_la_prestacion_id");
    SQL
    
  end
  def down
    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas"
        DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_cuasifactur_estado_de_la_prestacion_id_fkey",
        DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_cuasifacturas_prestacion_incluida_id_fkey",
        DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_cuasifacturas_efector_id_fkey",
        DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_cuasifacturas_liquidacion_id_fkey";

        DROP INDEX "public"."liquidaciones_sumar_cuasifactura_estado_de_la_prestacion_id_idx";
        DROP INDEX "public"."liquidaciones_sumar_cuasifacturas_efector_id_idx";
        DROP INDEX "public"."liquidaciones_sumar_cuasifacturas_liquidacion_id_idx";
        DROP INDEX "public"."liquidaciones_sumar_cuasifacturas_prestacion_incluida_id_idx";
    SQL
    drop_table :liquidaciones_sumar_cuasifacturas
  end
end
