class AgregarColumnaModificaLugarDeAtencionAPrestaciones < ActiveRecord::Migration
  def up
    add_column :prestaciones, :modifica_lugar_de_atencion, :boolean, :default => false
    execute "
      UPDATE prestaciones
        SET modifica_lugar_de_atencion = 't'
        WHERE id IN (258, 259, 267, 455, 456, 493, 494, 521, 522, 523, 560, 561, 562);
    "
  end

  def down
    remove_column :prestaciones, :modifica_lugar_de_atencion
  end
end
