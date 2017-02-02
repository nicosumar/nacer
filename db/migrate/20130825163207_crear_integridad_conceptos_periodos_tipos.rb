class CrearIntegridadConceptosPeriodosTipos < ActiveRecord::Migration
  def up
    #Periodos
  	#agrego restriccion de fk y el indice de la nueva fk
  	execute <<-SQL
  	  ALTER TABLE "public"."periodos"
	    ADD FOREIGN KEY ("tipo_periodo_id") 
	    REFERENCES "public"."tipos_periodos" ("id") 
	    ON DELETE RESTRICT ON UPDATE NO ACTION;
      CREATE INDEX  ON "public"."periodos" USING btree ("tipo_periodo_id");
  	SQL

    execute <<-SQL
      ALTER TABLE "public"."periodos"
      ADD FOREIGN KEY ("concepto_de_facturacion_id") 
      REFERENCES "public"."conceptos_de_facturacion" ("id") 
      ON DELETE RESTRICT ON UPDATE NO ACTION;
      CREATE INDEX  ON "public"."periodos" USING btree ("concepto_de_facturacion_id");
    SQL

    #Prestaciones
    #agrego referencia a prestaciones
    add_column :prestaciones, :concepto_de_facturacion_id, :integer

    #Creo la fk para la integridad referencial y agrego un indice para la fk. 
  	execute <<-SQL
	  ALTER TABLE "public"."prestaciones"
        ADD FOREIGN KEY ("concepto_de_facturacion_id") 
        REFERENCES "public"."conceptos_de_facturacion" ("id") 
        ON DELETE NO ACTION ON UPDATE NO ACTION;
        CREATE INDEX  ON "public"."prestaciones" USING btree ("concepto_de_facturacion_id");
  	SQL
  end

  def down
  	execute <<-SQL
  	  ALTER TABLE "public"."periodos"
	    DROP CONSTRAINT IF EXISTS "periodos_tipo_periodo_id_fkey";
  	SQL
    
    execute <<-SQL
      ALTER TABLE "public"."periodos"
      DROP CONSTRAINT IF EXISTS "periodos_concepto_de_facturacion_id_fkey";
    SQL

    execute <<-SQL
      ALTER TABLE "public"."prestaciones"
      DROP CONSTRAINT IF EXISTS "prestaciones_concepto_de_facturacion_id_fkey";
    SQL


    change_table :prestaciones do |t|
      t.remove :concepto_de_facturacion_id
    end

  end
end
