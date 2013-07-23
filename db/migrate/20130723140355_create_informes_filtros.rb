class CreateInformesFiltros < ActiveRecord::Migration
  def change
    create_table :informes_filtros do |t|
      t.references :informe
      t.references :informe_filtro_validador_ui
      t.string "nombre"
      t.string "valor_por_defecto"
      t.timestamps
    end
    add_index("informes_filtros", ["informe_id", "informe_filtro_validador_ui_id"], :name => 'indexfiltrosvalidadores')


  end

end
