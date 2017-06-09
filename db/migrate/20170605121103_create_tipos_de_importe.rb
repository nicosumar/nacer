class CreateTiposDeImporte < ActiveRecord::Migration
  def change
    create_table :tipos_de_importe do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
