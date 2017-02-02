# -*- encoding : utf-8 -*-
class RenameColumnDescripcionFromSexos < ActiveRecord::Migration
  def change
    rename_column :sexos, :descripcion, :nombre
  end
end
