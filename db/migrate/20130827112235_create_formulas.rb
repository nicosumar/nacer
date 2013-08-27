class CreateFormulas < ActiveRecord::Migration
  def change
    create_table :formulas do |t|
      t.string :descripcion
      t.text :formula
      t.text :observaciones
      t.boolean :activa, default: true

      t.timestamps
    end
  end
end
