class CreateCategoriasDeAfiliadosPrestacionesJoinTable < ActiveRecord::Migration
  def change
    create_table :categorias_de_afiliados_prestaciones, :id => false do |t|
      t.references :categoria_de_afiliado
      t.references :prestacion
    end
  end
end
