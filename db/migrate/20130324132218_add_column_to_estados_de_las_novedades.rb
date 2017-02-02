# -*- encoding : utf-8 -*-
class AddColumnToEstadosDeLasNovedades < ActiveRecord::Migration
  def change
    add_column :estados_de_las_novedades, :indexable, :boolean, :default => false
    execute "
      UPDATE estados_de_las_novedades SET indexable = 't' WHERE codigo IN ('I', 'R', 'P');
    "
  end
end
