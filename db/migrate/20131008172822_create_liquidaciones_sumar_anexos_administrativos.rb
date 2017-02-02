class CreateLiquidacionesSumarAnexosAdministrativos < ActiveRecord::Migration
  def up
    create_table :liquidaciones_sumar_anexos_administrativos do |t|
      t.references :estado_del_proceso
      t.date :fecha_de_inicio
      t.date :fecha_de_finalizacion

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar_anexos_administrativos"
				ADD FOREIGN KEY ("estado_del_proceso_id") REFERENCES "public"."estados_de_los_procesos" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

			CREATE INDEX  ON "public"."liquidaciones_sumar_anexos_administrativos" ("estado_del_proceso_id");
    SQL
  end

  def down
  	drop_table :liquidaciones_sumar_anexos_administrativos
  end
end
