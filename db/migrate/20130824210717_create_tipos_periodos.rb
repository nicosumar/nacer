class CreateTiposPeriodos < ActiveRecord::Migration
  def up
    create_table :tipos_periodos do |t|
      t.column :tipo, "char(1)"
      t.string :descripcion

      t.timestamps
    end

    load 'db/TiposPeriodos_seed.rb'

  end

  def down
  	drop_table :tipos_periodos
  end
end
