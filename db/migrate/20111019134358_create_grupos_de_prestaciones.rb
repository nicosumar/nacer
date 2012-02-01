class CreateGruposDePrestaciones < ActiveRecord::Migration
  def change
    create_table :grupos_de_prestaciones do |t|
      t.string :nombre, :null => false
    end
  end
end
