class AddConceptoLiquidacionSumarCuasifactura < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas"
        ADD COLUMN "concepto_de_facturacion_id" int4;
      --Actualizo todas las cuasi que ahora tienen su concepto de facturacion      
      update liquidaciones_sumar_cuasifacturas
      set concepto_de_facturacion_id = 1;

      ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas"
        ALTER COLUMN "concepto_de_facturacion_id" SET NOT NULL;
    SQL

  end

  def down
      execute <<-SQL
      ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas"
        DROP COLUMN "concepto_de_facturacion_id";
    SQL
  end
end
