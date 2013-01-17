class CreateTiposDePrestaciones < ActiveRecord::Migration
  def change
    create_table :tipos_de_prestaciones do |t|
      t.string :nombre
      t.string :codigo
    end
  end
end
