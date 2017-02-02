class CreateParametrosLiquidacionesSumar < ActiveRecord::Migration
  def up
    create_table :parametros_liquidaciones_sumar do |t|
      t.integer :dias_de_prestacion, default: 120
      t.references :nomenclador
      t.references :formula

      t.timestamps
    end

    add_column :liquidaciones_sumar, :parametro_liquidacion_sumar_id, :integer

    execute <<-SQL
    	ALTER TABLE "public"."liquidaciones_sumar"
			ADD FOREIGN KEY ("parametro_liquidacion_sumar_id") 
				REFERENCES "public"."parametros_liquidaciones_sumar" ("id") 
				ON DELETE RESTRICT ON UPDATE CASCADE;
		CREATE INDEX  ON "public"."liquidaciones_sumar" USING btree ("parametro_liquidacion_sumar_id");
    	
    	ALTER TABLE "public"."liquidaciones_sumar"
    		DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_formula_id_fkey";
		DROP INDEX "public"."liquidaciones_sumar_formula_id_idx";
    SQL
    remove_column :liquidaciones_sumar, :formula_id



  end

  def down
  	add_column :liquidaciones_sumar, :formula_id, :integer

  	execute <<-SQL
		ALTER TABLE "public"."liquidaciones_sumar"
	        ADD FOREIGN KEY ("formula_id") 
	          REFERENCES "public"."formulas" ("id") 
	          ON DELETE NO ACTION ON UPDATE NO ACTION;
	    CREATE INDEX  ON "public"."liquidaciones_sumar" USING btree ("formula_id"  );

	    ALTER TABLE "public"."liquidaciones_sumar"
			DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_parametro_liquidacion_sumar_id_fkey";

		DROP INDEX "public"."liquidaciones_sumar_parametro_liquidacion_sumar_id_idx";

  	SQL
  	remove_column :liquidaciones_sumar, :parametro_liquidacion_sumar_id


  	drop_table :parametros_liquidaciones_sumar
  end
end
