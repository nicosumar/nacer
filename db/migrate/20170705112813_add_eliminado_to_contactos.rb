class AddEliminadoToContactos < ActiveRecord::Migration
  def change
     add_column :contactos, :eliminado, :boolean

    execute "
  		UPDATE contactos SET  eliminado = FALSE
   "
  end
  
end
