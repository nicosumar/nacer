class CreateCuasiFacturas < ActiveRecord::Migration
  def change
    create_table :cuasi_facturas do |t|
      t.references :liquidacion, :null => false
      t.references :efector, :null => false
      t.references :nomenclador, :null => false
      t.date :fecha_de_presentacion, :null => false
      t.string :numero_de_liquidacion, :null => false
      t.decimal :total_informado, :precision => 15, :scale => 4
      t.text :observaciones

      t.timestamps
    end
  end
end
