class AddUniqueLiquidacionesSumar < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar"
        ADD UNIQUE ("concepto_de_facturacion_id", "periodo_id", "grupo_de_efectores_liquidacion_id");
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar"
        DROP CONSTRAINT "liquidaciones_sumar_concepto_de_facturacion_id_periodo_id_g_key" ;
    SQL
  end
end
