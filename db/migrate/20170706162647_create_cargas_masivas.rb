class CreateCargasMasivas < ActiveRecord::Migration
  def up
    create_table :cargas_masivas do |t|
      t.integer :numero
      t.date :fecha_del_proceso
      t.string :observaciones
      t.references :efector
      t.references :unidad_de_alta_de_datos
      t.references :estado_del_proceso
      t.references :usuario
      t.references :attachment
      t.string :archivo_file_name
      t.string :archivo_content_type
      t.string :archivo_file_fize
      t.date :archivo_updated_at


      t.timestamps
      
    end

    add_index :cargas_masivas, :efector_id
    add_index :cargas_masivas, :unidad_de_alta_de_datos_id


  end

  def down

  end
  
end
