class CreateInformesParaPagos < ActiveRecord::Migration
  def up
    create_table :informes_para_pagos do |t|
      t.references :liquidacion_informe
      t.references :pago_sumar
      t.column :monto_aprobado, "numeric(15,4)"

      t.timestamps
    end
    add_index :informes_para_pagos, :liquidacion_informe_id
    add_index :informes_para_pagos, :pago_sumar_id

    execute <<-SQL
      ALTER TABLE "public"."informes_para_pagos"
        ALTER COLUMN "liquidacion_informe_id" SET NOT NULL,
        ALTER COLUMN "pago_sumar_id" SET NOT NULL,
        ALTER COLUMN "monto_aprobado" SET NOT NULL,
        ADD FOREIGN KEY ("liquidacion_informe_id") REFERENCES "public"."liquidaciones_informes" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
        ADD FOREIGN KEY ("pago_sumar_id") REFERENCES "public"."pagos_sumar" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION;
    SQL
  end

  def down
    drop_table :informes_para_pagos
  end
end
