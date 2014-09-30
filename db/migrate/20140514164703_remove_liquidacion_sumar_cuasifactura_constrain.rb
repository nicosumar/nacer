class RemoveLiquidacionSumarCuasifacturaConstrain < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas"
        DROP CONSTRAINT "liquidaciones_sumar_cuasifact_liquidacion_sumar_id_efector__key" ;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas"
        ADD CONSTRAINT "liquidaciones_sumar_cuasifact_liquidacion_sumar_id_efector__key" UNIQUE ("liquidacion_sumar_id", "efector_id");
    SQL
  end
end
