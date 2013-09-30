class ModificarConveniosDeGestionSumar < ActiveRecord::Migration
  def up
    remove_column :convenios_de_gestion_sumar, :firmante
    add_column :convenios_de_gestion_sumar, :firmante_id, :integer 
  end

  def down
    remove_column :convenios_de_gestion_sumar, :firmante_id
    add_column :convenios_de_gestion_sumar, :firmante, :string
  end
end
