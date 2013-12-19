class AddPrestacionLiquidadaACuasifactura < ActiveRecord::Migration
  def up
  	execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas_detalles"
        ADD COLUMN "prestacion_liquidada_id" int4,
        ADD FOREIGN KEY ("prestacion_liquidada_id") REFERENCES "public"."prestaciones_liquidadas" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
  	SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas_detalles"
        DROP CONSTRAINT "liquidaciones_sumar_cuasifacturas__prestacion_liquidada_id_fkey",
        DROP COLUMN "prestacion_liquidada_id";
    SQL
  end
end
