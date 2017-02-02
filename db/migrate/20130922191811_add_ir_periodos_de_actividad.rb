class AddIrPeriodosDeActividad < ActiveRecord::Migration
  def up
  	execute <<-SQL
  	ALTER TABLE "public"."periodos_de_actividad"
		ADD FOREIGN KEY ("afiliado_id") 
			REFERENCES "public"."afiliados" ("afiliado_id") 
			ON DELETE RESTRICT ON UPDATE NO ACTION;

		CREATE INDEX  ON "public"."periodos_de_actividad" ("afiliado_id");
		CREATE INDEX  ON "public"."periodos_de_actividad" ("fecha_de_inicio", "fecha_de_finalizacion");
		CREATE INDEX  ON "public"."periodos_de_actividad" ("fecha_de_finalizacion");
		CREATE INDEX  ON "public"."periodos_de_actividad" ("fecha_de_inicio");

  	SQL
  end

  def down
  	execute <<-SQL
		ALTER TABLE "public"."periodos_de_actividad"
		DROP CONSTRAINT "periodos_de_actividad_afiliado_id_fkey";

		DROP INDEX "public"."periodos_de_actividad_afiliado_id_idx";
		DROP INDEX "public"."periodos_de_actividad_fecha_de_finalizacion_idx";
		DROP INDEX "public"."periodos_de_actividad_fecha_de_inicio_fecha_de_finalizacion_idx";
		DROP INDEX "public"."periodos_de_actividad_fecha_de_inicio_idx";
  	SQL
  end
end
