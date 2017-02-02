class AddDatosNomencladores < ActiveRecord::Migration
  def up
  	add_column :nomencladores, :nomenclador_sumar, :boolean, default: true
  	add_column :nomencladores, :fecha_de_finalizacion, :date
  	execute <<-SQL
  		CREATE INDEX  ON "public"."nomencladores" ("fecha_de_inicio"  , "nomenclador_sumar"  , "fecha_de_finalizacion"  , "activo"  );
		CREATE INDEX  ON "public"."nomencladores" ("fecha_de_inicio"  );
		CREATE INDEX  ON "public"."nomencladores" ("fecha_de_finalizacion"  );
		CREATE INDEX  ON "public"."nomencladores" ("nomenclador_sumar"  );
		CREATE INDEX  ON "public"."nomencladores" ("activo"  );

		UPDATE nomencladores
		set nomenclador_sumar = 'f'
		where nombre not ilike '%sumar%'
		;


  	SQL
  end

  def down
  	execute <<-SQL
		DROP INDEX "public"."nomencladores_activo_idx";
		DROP INDEX "public"."nomencladores_fecha_de_finalizacion_idx";
		DROP INDEX "public"."nomencladores_fecha_de_inicio_idx";
		DROP INDEX "public"."nomencladores_fecha_de_inicio_nomenclador_sumar_fecha_de_fi_idx";
		DROP INDEX "public"."nomencladores_nomenclador_sumar_idx";
	SQL
  	

  	remove_column :nomencladores, :nomenclador_sumar
  	remove_column :nomencladores, :fecha_de_finalizacion
  end
end
