class CreateDiagnosticosMetastasis < ActiveRecord::Migration
  def change
    create_table :diagnosticos_metastasis do |t|
      t.text :codigo
      t.text :nombre
      t.integer :codigo_sirge

      t.timestamps
    end
  end
end
