class CreateIndexesOnAfiliados < ActiveRecord::Migration
  def up
    add_index :afiliados, :numero_de_documento
    add_index :afiliados, :numero_de_documento_de_la_madre
    add_index :afiliados, :numero_de_documento_del_padre
    add_index :afiliados, :numero_de_documento_del_tutor
  end

  def down
    remove_index :afiliados, :numero_de_documento
    remove_index :afiliados, :numero_de_documento_de_la_madre
    remove_index :afiliados, :numero_de_documento_del_padre
    remove_index :afiliados, :numero_de_documento_del_tutor
  end
end
