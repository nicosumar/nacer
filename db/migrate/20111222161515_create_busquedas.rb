class CreateBusquedas < ActiveRecord::Migration
  def change
    create_table :busquedas do |t|
      t.references :modelo, :polymorphic => true, :null => false
      t.string :titulo, :null => false
      t.text :texto, :null => false
      t.column :vector_fts, :tsvector, :null => false
    end
  end
end
