class AddActivoToTipoDeDocumento < ActiveRecord::Migration
  def change
    add_column :tipos_de_documentos, :activo, :boolean
  end
end
