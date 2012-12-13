# -*- encoding : utf-8 -*-
class AddSexoIdToContacto < ActiveRecord::Migration
  def change
    add_column :contactos, :sexo_id, :integer
  end
end
