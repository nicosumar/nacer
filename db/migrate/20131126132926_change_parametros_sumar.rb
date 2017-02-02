class ChangeParametrosSumar < ActiveRecord::Migration
  def up
  	execute <<-SQL
  	ALTER TABLE "public"."parametros_liquidaciones_sumar"
		ALTER COLUMN "aceptar_estado_de_la_prestacion_id" SET DEFAULT 4,
		ALTER COLUMN "excepcion_estado_de_la_prestacion_id" SET DEFAULT 4;
  	SQL
  end

  def down
  	execute <<-SQL
		ALTER TABLE "public"."parametros_liquidaciones_sumar"
		ALTER COLUMN "aceptar_estado_de_la_prestacion_id" SET DEFAULT 5,
		ALTER COLUMN "excepcion_estado_de_la_prestacion_id" SET DEFAULT 5;
  	SQL
  end
end
