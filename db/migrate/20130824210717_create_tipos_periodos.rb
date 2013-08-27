class CreateTiposPeriodos < ActiveRecord::Migration
  def change
    create_table :tipos_periodos do |t|
      t.column :tipo, "char(1)"
      t.string :descripcion

      t.timestamps
    end
  end
end
