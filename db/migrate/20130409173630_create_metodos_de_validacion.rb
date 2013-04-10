class CreateMetodosDeValidacion < ActiveRecord::Migration
  def change
    create_table :metodos_de_validacion do |t|
      t.string :nombre
      t.string :metodo
      t.string :mensaje

      t.timestamps
    end
  end
end
