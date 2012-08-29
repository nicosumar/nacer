class CreateCentrosDeInscripcion < ActiveRecord::Migration
  def change
    create_table :centros_de_inscripcion do |t|
      t.string :nombre, :null => false
      t.string :codigo, :null => false
      t.references :efector, :null => false
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
  end
end
