class CreateFormulas < ActiveRecord::Migration
  def up
    create_table :formulas do |t|
      t.string :descripcion
      t.text :formula
      t.text :observaciones
      t.boolean :activa, default: true

      t.timestamps
    end
  end

  def down
  	drop_table :formulas
  end

end
