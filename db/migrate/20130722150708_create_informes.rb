class CreateInformes < ActiveRecord::Migration
  def self.up
    create_table :informes do |t|
      t.string "titulo"
      t.text "sql"
      t.string "formato"
      t.string "nombre_partial"
      t.timestamps
    end
  end

  def self.down
	drop_table :informes
  end
end
