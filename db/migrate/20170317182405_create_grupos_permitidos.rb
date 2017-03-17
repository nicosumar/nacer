class AddTableGruposPermitidos < ActiveRecord::Migration
  def change
    create_table :grupos_permitidos do |t|
      t.references :grupo_poblacional
      t.references :grupo_pdss
      t.references :sexo

      t.timestamps
    end
    add_index :grupos_permitidos, :grupo_poblacional_id
    add_index :grupos_permitidos, :grupo_pdss_id
    add_index :grupos_permitidos, :sexo_id
  end
end
