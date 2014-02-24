class CreateExpedientesSumar < ActiveRecord::Migration
  def up
    create_table :expedientes_sumar do |t|
      t.text :numero
      t.references :tipo_de_expediente

      t.timestamps
    end
    add_index :expedientes_sumar, :tipo_de_expediente_id
  end

  def down
    drop_table :expedientes_sumar
  end
  
end
