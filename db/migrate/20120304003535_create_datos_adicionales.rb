class CreateDatosAdicionales < ActiveRecord::Migration
  def change
    create_table :datos_adicionales do |t|
      t.string :nombre, :null => false
      t.string :tipo_postgres, :null => false
      t.string :tipo_ruby, :null => false
      t.boolean :enumerable
      t.string :clase_para_enumeracion

      t.timestamps
    end
  end
end
