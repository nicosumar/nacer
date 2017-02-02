class AddColumnVisibleToMetodosDeValidacion < ActiveRecord::Migration
  def change
    add_column :metodos_de_validacion, :visible, :boolean, :default => true
    MetodoDeValidacion.where(:id => [15, 16]).each do |mv|
      mv.visible = false
      mv.save
    end
  end
end
