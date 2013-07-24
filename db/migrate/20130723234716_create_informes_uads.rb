class CreateInformesUads < ActiveRecord::Migration
  def change
    create_table :informes_uads do |t|
      t.references :informe
      t.references :unidad_de_alta_de_datos
      t.integer 'incluido' # 0= Excluido; 1 = Incluido; 
      t.timestamps
    end
  end
end
