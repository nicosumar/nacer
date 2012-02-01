class CreateSexos < ActiveRecord::Migration
  def change
    create_table :sexos do |t|
      t.string :descripcion
    end
  end
end
