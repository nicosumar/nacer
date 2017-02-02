# -*- encoding : utf-8 -*-
class RenameColumnOnLiquidaciones < ActiveRecord::Migration
  def change
    rename_column :liquidaciones, :año_de_prestaciones, :anio_de_prestaciones
  end
end
