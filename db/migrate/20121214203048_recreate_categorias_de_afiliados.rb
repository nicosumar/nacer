# -*- encoding : utf-8 -*-
class RecreateCategoriasDeAfiliados < ActiveRecord::Migration
  def change
    # Eliminamos la tabla anterior
    drop_table :categorias_de_afiliados
    # Parece que la secuencia se DROPea junto con la tabla...
    # execute "DROP SEQUENCE categorias_de_afiliados_id_seq;"

    # Creamos la tabla con la nueva estructura
    create_table :categorias_de_afiliados do |t|
      t.string :nombre, :null => false
      t.string :codigo, :null => false
    end
  end
end
