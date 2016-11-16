class CreateDiagnosticosTamanos < ActiveRecord::Migration
  def change
    create_table :diagnosticos_tamanos do |t|
      t.text :codigo
      t.text :nombre
      t.integer :codigo_sirge

      t.timestamps
    end
  end
end
