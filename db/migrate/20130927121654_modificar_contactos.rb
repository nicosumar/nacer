class ModificarContactos < ActiveRecord::Migration
  def up
    add_column :contactos, :tipo_de_documento_id, :integer
    add_column :contactos, :firma_primera_linea, :string
    add_column :contactos, :firma_segunda_linea, :string
    add_column :contactos, :firma_tercera_linea, :string
  end

  def down
    remove_column :contactos, :tipo_de_documento_id
    remove_column :contactos, :firma_primera_linea
    remove_column :contactos, :firma_segunda_linea
    remove_column :contactos, :firma_tercera_linea
  end
end
