class CreateReglas < ActiveRecord::Migration
  def up
    create_table :reglas do |t|
      t.string :nombre
      t.boolean :permitir
      t.string :observaciones
      t.references :efector
      t.references :metodo_de_validacion
      t.references :nomenclador
      t.references :prestacion

      t.timestamps
    end

    add_index :reglas, :efector_id
    add_index :reglas, :metodo_de_validacion_id
    add_index :reglas, :nomenclador_id
    add_index :reglas, :prestacion_id

    #Agregar claves foraneas
    execute <<-SQL
      ALTER TABLE "public"."reglas"
		ADD FOREIGN KEY ("efector_id") REFERENCES "public"."efectores" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
		ADD FOREIGN KEY ("metodo_de_validacion_id") REFERENCES "public"."metodos_de_validacion" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
		ADD FOREIGN KEY ("nomenclador_id") REFERENCES "public"."nomencladores" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
		ADD FOREIGN KEY ("prestacion_id") REFERENCES "public"."prestaciones" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
    SQL

  end

  def down
  	execute <<-SQL
  	ALTER TABLE "public"."reglas"
		DROP CONSTRAINT IF EXISTS "reglas_prestacion_id_fkey",
		DROP CONSTRAINT IF EXISTS "reglas_nomenclador_id_fkey",
		DROP CONSTRAINT IF EXISTS "reglas_metodo_de_validacion_id_fkey",
		DROP CONSTRAINT IF EXISTS "reglas_efector_id_fkey";
  	SQL
  	drop_table :reglas
  end


end
