class CreateTribusOriginarias < ActiveRecord::Migration
  def change
    create_table :tribus_originarias do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
