class CreatePagosSumar < ActiveRecord::Migration
  def up
    create_table :pagos_sumar do |t|
      t.references :efector
      t.references :concepto_de_facturacion
      t.references :cuenta_bancaria_origen
      t.references :cuenta_bancaria_destino
      t.references :estado_del_proceso, default: 2 # Estado "En curso" lo agrego al modelo para no olvidar q existe
      t.date :fecha_de_proceso
      t.boolean :informado_sirge, default: false
      t.date :fecha_informado_sirge
      t.boolean :notificado, default: false
      t.date :fecha_de_notificacion
      t.column :monto, "numeric(15,4)"

      t.timestamps
    end
    add_index :pagos_sumar, :efector_id
    add_index :pagos_sumar, :concepto_de_facturacion_id
    add_index :pagos_sumar, :cuenta_bancaria_origen_id
    add_index :pagos_sumar, :cuenta_bancaria_destino_id

    execute <<-SQL

    ALTER TABLE "public"."pagos_sumar"
      ALTER COLUMN "efector_id" SET NOT NULL,
      ALTER COLUMN "concepto_de_facturacion_id" SET NOT NULL,
      ALTER COLUMN "cuenta_bancaria_origen_id" SET NOT NULL,
      ALTER COLUMN "cuenta_bancaria_destino_id" SET NOT NULL,
      ALTER COLUMN "estado_del_proceso_id" SET NOT NULL,
      ALTER COLUMN "informado_sirge" SET NOT NULL,
      ALTER COLUMN "notificado" SET NOT NULL,
      ADD FOREIGN KEY ("efector_id") REFERENCES "public"."efectores" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("concepto_de_facturacion_id") REFERENCES "public"."conceptos_de_facturacion" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("cuenta_bancaria_origen_id") REFERENCES "public"."cuentas_bancarias" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("cuenta_bancaria_destino_id") REFERENCES "public"."cuentas_bancarias" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
      ADD FOREIGN KEY ("estado_del_proceso_id") REFERENCES "public"."estados_de_los_procesos" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION;
    SQL
  end

  def down
    drop_table :pagos_sumar
  end
end
