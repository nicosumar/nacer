class AddColumnEfectorToUads < ActiveRecord::Migration
  def up
  	add_column :unidades_de_alta_de_datos, :efector_id, :integer
  	add_index :unidades_de_alta_de_datos, :efector_id

  	execute <<-SQL
      ALTER TABLE "public"."unidades_de_alta_de_datos"
        ADD UNIQUE ("efector_id");

      UPDATE unidades_de_alta_de_datos 
      SET
        efector_id = e.id 
      FROM unidades_de_alta_de_datos u
        join efectores e on u.nombre = e.nombre
      WHERE unidades_de_alta_de_datos.id = u.id;
  	SQL
  end

  def down
  	remove_column :unidades_de_alta_de_datos, :efector_id
  end
end
