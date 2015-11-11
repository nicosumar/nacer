class CreateRendiciones < ActiveRecord::Migration
  def change
    create_table :rendiciones do |t|
      t.references :efector_id, null: false
      t.references :periodo_de_rendicion_id
      t.references :estado_de_rendicion_id
      t.text :observaciones

      t.timestamps
    end
    add_index :rendiciones, :efector_id_id
    add_index :rendiciones, :periodo_de_rendicion_id_id
    add_index :rendiciones, :estado_de_rendicion_id_id
  end
end
