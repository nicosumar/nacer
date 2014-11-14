class CreateAplicacionesDeNotasDeDebito < ActiveRecord::Migration
  def up
    create_table :aplicaciones_de_notas_de_debito do |t|
      t.references :nota_de_debito
      t.references :pago_sumar
      t.date :fecha_de_aplicacion
      t.decimal :monto

      t.timestamps
    end
    add_index :aplicaciones_de_notas_de_debito, :nota_de_debito_id
    add_index :aplicaciones_de_notas_de_debito, :pago_sumar_id

    execute <<-SQL
      ALTER TABLE "public"."aplicaciones_de_notas_de_debito"
        ALTER COLUMN "nota_de_debito_id" SET NOT NULL,
        ALTER COLUMN "pago_sumar_id" SET NOT NULL,
        ALTER COLUMN "fecha_de_aplicacion" SET NOT NULL,
        ALTER COLUMN "monto" SET NOT NULL,
        ADD FOREIGN KEY ("nota_de_debito_id") REFERENCES "public"."notas_de_debito" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
        ADD FOREIGN KEY ("pago_sumar_id") REFERENCES "public"."pagos_sumar" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION;
    SQL
  end

  def down
    drop_table :aplicaciones_de_notas_de_debito
  end
end
