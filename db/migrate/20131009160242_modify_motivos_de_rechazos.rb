class ModifyMotivosDeRechazos < ActiveRecord::Migration
  def up
  	add_column :motivos_de_rechazos, :categoria, :string
  	load 'db/MotivosDeRechazos_liquidaciones_seed.rb'
  end

  def down
    execute <<-SQL
      DELETE FROM motivos_de_rechazos
      where categoria is not null
    SQL
 
  	remove_column :motivos_de_rechazos, :categoria
  end
end
