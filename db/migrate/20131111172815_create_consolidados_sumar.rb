class CreateConsolidadosSumar < ActiveRecord::Migration
  def change
    create_table :consolidados_sumar do |t|
      t.string :numero_de_consolidado
      t.date :fecha
      t.references :efector
      t.references :firmate
      t.references :periodo
      t.references :liquidacion_sumar

      t.timestamps
    end
    add_index :consolidados_sumar, :efector_id
    add_index :consolidados_sumar, :firmate_id
    add_index :consolidados_sumar, :periodo_id
    add_index :consolidados_sumar, :liquidacion_sumar_id

    execute <<-SQL

      ALTER TABLE "public"."consolidados_sumar"
      ADD FOREIGN KEY ("efector_id") REFERENCES "public"."efectores" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD FOREIGN KEY ("firmate_id") REFERENCES "public"."contactos" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD FOREIGN KEY ("periodo_id") REFERENCES "public"."periodos" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD FOREIGN KEY ("liquidacion_sumar_id") REFERENCES "public"."liquidaciones_sumar" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD UNIQUE ("numero_de_consolidado"),
      ADD UNIQUE ("efector_id", "periodo_id"),
      ADD UNIQUE ("efector_id", "liquidacion_sumar_id");

    SQL
  end
end
