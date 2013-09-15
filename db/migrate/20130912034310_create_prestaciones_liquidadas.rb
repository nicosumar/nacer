class CreatePrestacionesLiquidadas < ActiveRecord::Migration
  def up
    create_table :prestaciones_liquidadas do |t|
      t.references :liquidacion
      t.references :unidad_de_alta_de_datos
      t.references :efector
      t.references :prestacion_incluida
      t.date :fecha_de_la_prestacion
      t.references :estado_de_la_prestacion
      t.string :historia_clinica
      t.boolean :es_catastrofica
      t.references :diagnostico
      t.string :diagnostico_nombre
      t.integer :cantidad_de_unidades
      t.text :observaciones
      t.string :clave_de_beneficiario
      t.column :codigo_area_prestacion, "char(1)"
      t.string :nombre_area_de_prestacion
      t.references :prestacion_brindada

      t.timestamps
    end
    execute <<-SQL
    ALTER TABLE "public"."prestaciones_liquidadas"
      ADD FOREIGN KEY ("liquidacion_id") REFERENCES "public"."liquidaciones" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("unidad_de_alta_de_datos_id") REFERENCES "public"."unidades_de_alta_de_datos" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("efector_id") REFERENCES "public"."efectores" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("prestacion_incluida_id") REFERENCES "public"."prestaciones_incluidas" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("estado_de_la_prestacion_id") REFERENCES "public"."estados_de_las_prestaciones" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("diagnostico_id") REFERENCES "public"."diagnosticos" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("clave_de_beneficiario") REFERENCES "public"."afiliados" ("clave_de_beneficiario") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD UNIQUE ("liquidacion_id", "unidad_de_alta_de_datos_id", "efector_id", "prestacion_incluida_id", "fecha_de_la_prestacion", "clave_de_beneficiario");
    SQL

  end
  def down
    execute <<-SQL
      ALTER TABLE "public"."prestaciones_liquidadas"
      DROP CONSTRAINT IF EXISTS "prestaciones_liquidadas_estado_de_la_prestacion_id_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_liquidadas_prestacion_incluida_id_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_liquidadas_clave_de_beneficiario_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_liquidadas_unidad_de_alta_de_datos_id_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_liquidadas_liquidacion_id_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_liquidadas_efector_id_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_liquidadas_diagnostico_id_fkey",
      DROP CONSTRAINT IF EXISTS "prestaciones_liquidadas_liquidacion_id_unidad_de_alta_de_da_key" ;
    SQL

    drop_table :prestaciones_liquidadas
  end
end
