class MigraFormulaAConceptoDeFacturacion < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE "public"."conceptos_de_facturacion"
        ADD COLUMN "formula_id" int4,
        ADD FOREIGN KEY ("formula_id") REFERENCES "public"."formulas" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

      ALTER TABLE "public"."parametros_liquidaciones_sumar"
        DROP COLUMN "dias_de_prestacion",
        DROP COLUMN "formula_id";

    SQL

    execute <<-SQL
      ALTER TABLE "public"."periodos"
        ADD COLUMN "dias_de_prestacion" int4 DEFAULT 120;
    SQL
    c = ConceptoDeFacturacion.find(1)
    c.formula = Formula.find(1)
    c.save
    
    Periodo.all.each do |p|
      p.dias_de_prestacion = 120
      p.save
    end

  end

  def down
    execute <<-SQL
      ALTER TABLE "public"."conceptos_de_facturacion"
        DROP CONSTRAINT "conceptos_de_facturacion_formula_id_fkey",
        DROP COLUMN "formula_id",
        DROP COLUMN "dias_de_prestacion";

      ALTER TABLE "public"."parametros_liquidaciones_sumar"
        ADD COLUMN "formula_id" int4,
        ADD COLUMN "dias_de_prestacion" int4 DEFAULT 120,
        ADD FOREIGN KEY ("formula_id") REFERENCES "public"."formulas" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

    SQL

  end
end
