class AddPlantillasLiquidacionRef < ActiveRecord::Migration
  def up

  	#Agrego la referencia a la plantilla de reglas y la IR
  	execute <<-SQL
  	  ALTER TABLE "public"."liquidaciones_sumar"
	    ADD COLUMN "plantilla_de_reglas_id" int4,
		  ADD FOREIGN KEY ("plantilla_de_reglas_id") 
  		  REFERENCES "public"."plantillas_de_reglas" ("id") 
  		  ON DELETE NO ACTION ON UPDATE NO ACTION;
	  CREATE INDEX  ON "public"."liquidaciones_sumar" USING btree ("plantilla_de_reglas_id"  );

	  ALTER TABLE "public"."liquidaciones_sumar"
        ADD FOREIGN KEY ("formula_id") 
          REFERENCES "public"."formulas" ("id") 
          ON DELETE NO ACTION ON UPDATE NO ACTION,
        ADD FOREIGN KEY ("concepto_de_facturacion_id") 
          REFERENCES "public"."conceptos_de_facturacion" ("id") 
          ON DELETE NO ACTION ON UPDATE NO ACTION,
        ADD FOREIGN KEY ("grupo_de_efectores_liquidacion_id") 
          REFERENCES "public"."grupos_de_efectores_liquidaciones" ("id") 
          ON DELETE NO ACTION ON UPDATE NO ACTION;
      CREATE INDEX  ON "public"."liquidaciones_sumar" USING btree ("formula_id"  );
      CREATE INDEX  ON "public"."liquidaciones_sumar" USING btree ("concepto_de_facturacion_id"  );
      CREATE INDEX  ON "public"."liquidaciones_sumar" USING btree ("grupo_de_efectores_liquidacion_id"  );
  	SQL

  end

  def down
  	execute <<-SQL
	  	ALTER TABLE "public"."liquidaciones_sumar"
		  DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_plantilla_de_reglas_id_fkey";
        DROP INDEX "public"."liquidaciones_sumar_plantilla_de_reglas_id_idx";

	    ALTER TABLE "public"."liquidaciones_sumar"
		  DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_grupo_de_efectores_liquidacion_id_fkey",
		  DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_concepto_de_facturacion_id_fkey",
		  DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_formula_id_fkey";

		DROP INDEX "public"."liquidaciones_sumar_concepto_de_facturacion_id_idx";
		DROP INDEX "public"."liquidaciones_sumar_formula_id_idx";
		DROP INDEX "public"."liquidaciones_sumar_grupo_de_efectores_liquidacion_id_idx";
  	SQL
  end

end
