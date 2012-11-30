class CreateBusquedasLocales < ActiveRecord::Migration
  def change

    create_table :busquedas_locales do |t|
      t.references :modelo, :polymorphic => true, :null => false
      t.string :titulo, :null => false
      t.text :texto, :null => false
      t.column :vector_fts, :tsvector, :null => false
    end

    # Creación de índices en la tabla de búsquedas
    execute "
      CREATE UNIQUE INDEX idx_unq_modelo_l ON busquedas_locales (modelo_type, modelo_id);
    "
    execute "
      CREATE INDEX idx_gin_on_vector_fts_l ON busquedas_locales USING gin (vector_fts);
    "

  end
end
