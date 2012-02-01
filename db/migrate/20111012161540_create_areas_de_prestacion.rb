class CreateAreasDePrestacion < ActiveRecord::Migration
  def change
    create_table :areas_de_prestacion do |t|
      t.string :nombre
    end
  end
end
