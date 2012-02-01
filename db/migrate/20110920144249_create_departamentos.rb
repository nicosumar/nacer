class CreateDepartamentos < ActiveRecord::Migration
  def change
    create_table :departamentos do |t|
      t.string :nombre, :null => false
      t.references :provincia, :null => false
      t.integer :departamento_bio_id
      t.string :departamento_indec_id
      t.integer :departamento_insc_id
    end
  end
end
