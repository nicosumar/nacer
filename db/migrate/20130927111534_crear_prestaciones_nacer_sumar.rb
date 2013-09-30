class CrearPrestacionesNacerSumar < ActiveRecord::Migration
  def up
    create_table :prestaciones_nacer_sumar, :id => false do |t|
      t.references :prestacion_nacer, :null => false
      t.references :prestacion_sumar, :null => false
    end
    add_index :prestaciones_nacer_sumar, [:prestacion_nacer_id, :prestacion_sumar_id], :unique => true, :name => "index_prestaciones_nacer_sumar_unq"

    load 'db/PrestacionesNacerSumar_seed.rb'

  end

  def down
    drop_table :prestaciones_nacer_sumar
  end
end
