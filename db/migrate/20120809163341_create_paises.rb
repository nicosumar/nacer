class CreatePaises < ActiveRecord::Migration
  def change
    create_table :paises do |t|
      t.integer :pais_bio_id
      t.string :nombre
    end
  end
end
