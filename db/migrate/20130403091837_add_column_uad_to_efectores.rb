# -*- encoding : utf-8 -*-
class AddColumnUadToEfectores < ActiveRecord::Migration
  def change
    add_column :efectores, :unidad_de_alta_de_datos_id, :integer

    execute "
      ALTER TABLE efectores
        ADD CONSTRAINT fk_efectores_unidades_de_alta_de_datos
        FOREIGN KEY (unidad_de_alta_de_datos_id) REFERENCES unidades_de_alta_de_datos(id);
    "
  end
end
