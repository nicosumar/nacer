class ModificarTablaDiagnosticos < ActiveRecord::Migration
  def up
    add_column :diagnosticos, :grupo_de_diagnosticos_id, :integer
    add_index :diagnosticos, :grupo_de_diagnosticos_id
  end

  def down
  end
end
