class CreateLiquidacionesSumarCuasifacturasDetalles < ActiveRecord::Migration
  def up
    create_table :liquidaciones_sumar_cuasifacturas_detalles do |t|
      
      t.references :liquidaciones_sumar_cuasifacturas
      t.references :prestacion_incluida
      t.references :estado_de_la_prestacion
      t.column :monto, "numeric(15,4)"
      t.text :observaciones
 
      t.timestamps
    end
    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas_detalles"
      ADD FOREIGN KEY ("liquidaciones_sumar_cuasifacturas_id") 
        REFERENCES "public"."liquidaciones_sumar_cuasifacturas" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD FOREIGN KEY ("prestacion_incluida_id") 
        REFERENCES "public"."prestaciones_incluidas" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD FOREIGN KEY ("estado_de_la_prestacion_id") 
        REFERENCES "public"."estados_de_las_prestaciones" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
      CREATE INDEX  ON "public"."liquidaciones_sumar_cuasifacturas_detalles" ("liquidaciones_sumar_cuasifacturas_id");
    SQL

  end
  def down

    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas_detalles"
      DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_cuasifactur_estado_de_la_prestacion_id_fkey",
      DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_cuasifacturas_d_prestacion_incluida_id_fkey",
      DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_cuasifact_liquidaciones_sumar_cuasifac_fkey";

      DROP INDEX "public"."liquidaciones_sumar_cuasifact_liquidaciones_sumar_cuasifact_idx";
    SQL
    
    drop_table :liquidaciones_sumar_cuasifacturas_detalles
  end
  
end
