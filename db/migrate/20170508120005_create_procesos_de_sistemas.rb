class CreateProcesosDeSistemas < ActiveRecord::Migration
  def change
    create_table :procesos_de_sistemas do |t|
      t.string :descripcion
      t.text :descripcion_ultimo_error
      t.string :fecha_completado
      t.references :tipo_proceso_de_sistema
      t.references :estado_proceso_de_sistema

      t.timestamps
    end
    add_index :procesos_de_sistemas, :tipo_proceso_de_sistema_id
    add_index :procesos_de_sistemas, :estado_proceso_de_sistema_id
  end
end
