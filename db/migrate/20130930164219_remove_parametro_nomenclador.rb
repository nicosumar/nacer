class RemoveParametroNomenclador < ActiveRecord::Migration
  def up
  	remove_column :parametros_liquidaciones_sumar, :nomenclador_id
  end

  def down
  	add_column :parametros_liquidaciones_sumar, :nomenclador_id, " int4"
  end
end
