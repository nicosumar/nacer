# -*- encoding : utf-8 -*-
class AddCodigoToUnidadesDeMedida < ActiveRecord::Migration
  def change
    add_column :unidades_de_medida, :codigo, :string
    add_column :unidades_de_medida, :solo_enteros, :boolean

    UnidadDeMedida.find(1).update_attributes({:nombre => 'Prestación única, o cantidad unitaria', :codigo => 'U', :solo_enteros => true})
    UnidadDeMedida.find(2).update_attributes({:nombre => 'Días de internación', :codigo => 'D', :solo_enteros => true})
    UnidadDeMedida.find(3).update_attributes({:nombre => 'Kilómetros (excedentes de 50 km)', :codigo => 'K', :solo_enteros => true})
  end
end
