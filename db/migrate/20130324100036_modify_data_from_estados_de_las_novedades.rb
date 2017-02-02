# -*- encoding : utf-8 -*-
class ModifyDataFromEstadosDeLasNovedades < ActiveRecord::Migration
  def change
    execute "
      UPDATE estados_de_las_novedades SET nombre = 'Aprobada y activa' WHERE codigo = 'A';
      INSERT INTO estados_de_las_novedades (nombre, codigo, pendiente) VALUES ('Aprobada pero inactiva', 'N', 'f');
    "
  end
end
