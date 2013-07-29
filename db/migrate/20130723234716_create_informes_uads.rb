class CreateInformesUads < ActiveRecord::Migration
  def change
    create_table :informes_uads do |t|
      t.references :informe
      t.references :unidad_de_alta_de_datos
      t.integer 'incluido' # 0= Excluido; 1 = Incluido; 
      t.timestamps
    end

    add_index :informes_uads, ['informe_id', 'unidad_de_alta_de_datos_id'], :name => 'informes_uads_idx'
  end
end
