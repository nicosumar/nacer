class CreateDiagnosticosEstadios < ActiveRecord::Migration
  def change
    create_table :diagnosticos_estadios do |t|
      t.text :codigo
      t.text :nombre
      t.integer :codigo_sirge

      t.timestamps
    end
  end
end
