class CreateSirge < ActiveRecord::Migration
  def up

    create_table :sirge do |t|
      t.references :efector
      t.date :fecha_gasto
      t.column :periodo, "varchar(7)"
      t.column :numero_comprobante_gasto, "varchar(7)", null: true
      t.column :codigo_gasto, "char(3)"
      t.references :efector_cesion
      t.column :monto, "numeric(15,4)"
      t.column :concepto, "varchar(200)", null: true

      t.timestamps
    end
  end

  def down
    drop_table :sirge
  end
end
