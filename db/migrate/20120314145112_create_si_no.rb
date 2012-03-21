class CreateSiNo < ActiveRecord::Migration
  def change
    create_table :si_no do |t|
      t.string :nombre
      t.string :codigo_para_prestaciones
      t.boolean :valor_bool

      t.timestamps
    end
  end
end
