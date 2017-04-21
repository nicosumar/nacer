class CreateHistoricosPrestaciones < ActiveRecord::Migration
  def change
    create_table :historicos_prestaciones do |t|
      t.references :prestacion
      t.references :prestacion_anterior

      t.timestamps
    end
    add_index :historicos_prestaciones, :prestacion_id
    add_index :historicos_prestaciones, :prestacion_anterior_id
  end
end
