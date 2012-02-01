class CreateDistritos < ActiveRecord::Migration
  def change
    create_table :distritos do |t|
      t.string :nombre, :null => false
      t.references :departamento, :null => false
      t.string :codigo_postal
      t.integer :distrito_bio_id
      t.integer :distrito_insc_id
      t.string :distrito_indec_id
      t.integer :alias_id, :null => false

      t.timestamps
    end
  end
end
