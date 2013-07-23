class CreateInformes < ActiveRecord::Migration
  def self.up
    create_table :informes do |t|
      t.string "titulo"
      t.text "sql"
      t.string "metodo_en_controller"
      t.timestamps
    end
  end

  def self.down
	drop_table :informes
  end
end
