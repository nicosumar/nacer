class CreateDiagnosticosGangliosLinfaticos < ActiveRecord::Migration
  def change
    create_table :diagnosticos_ganglios_linfaticos do |t|
      t.text :codigo
      t.text :nombre
      t.integer :codigo_sirge

      t.timestamps
    end
  end
end
