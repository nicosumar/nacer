class CreateProcesosDeSistemas < ActiveRecord::Migration
  def change
    create_table :procesos_de_sistemas do |t|
      t.string :descripcion
      t.text :descripcion_ultimo_error
      t.text :parametros_dinamicos
      t.string :fecha_completado
      t.references :tipo_proceso_de_sistema
      t.references :estado_proceso_de_sistema
      t.references :user
      t.integer :entidad_relacionada_id
      t.timestamps
    end
    add_index :procesos_de_sistemas, :tipo_proceso_de_sistema_id
    add_index :procesos_de_sistemas, :estado_proceso_de_sistema_id
    add_index :procesos_de_sistemas, :entidad_relacionada_id
  end
end
