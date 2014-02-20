class AddIndexToMigraPrestacionesNacer < ActiveRecord::Migration
  def up 
  	execute <<-SQL
 		 CREATE INDEX  ON "public"."migra_prestaciones_liquidadas_nacer" ("fecha_de_la_prestacion"  );
  	SQL
  end

  def down
  	execute <<-SQL
     DROP INDEX "public"."migra_prestaciones_liquidadas_nacer_fecha_de_la_prestacion_idx";
    SQL
  end
end
