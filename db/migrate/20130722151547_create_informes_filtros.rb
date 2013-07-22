class CreateInformesFiltros < ActiveRecord::Migration
  def self.up
    create_table :informes_filtros do |t|
      t.integer "informe_id"
      t.string "nombre"
      t.string "valor_por_defecto"
      t.integer "informe_filtro_tipo_ui_id"
      t.timestamps
    end
    add_index("informes_filtros", "informe_id")
  end

  def self.down
  	drop_table :informes_filtros
  end
end
