# -*- encoding : utf-8 -*-
class CreateUniqueIndexOnAfiliadosAfiliadoId < ActiveRecord::Migration
  def up
    add_index(:afiliados, :afiliado_id, :unique => true)
  end

  def down
    remove_index(:afiliados, :column => :afiliado_id)
  end
end
