class CreateInformesDebitosPrestacionales < ActiveRecord::Migration
  def up
    create_table :informes_debitos_prestacionales do |t|
      t.boolean :informado_sirge
      t.boolean :procesado_para_debito
      t.references :concepto_de_facturacion
      t.references :efector
      t.references :tipo_de_debito_prestacional
      t.references :estado_del_proceso

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE "public"."informes_debitos_prestacionales"
        ADD FOREIGN KEY ("concepto_de_facturacion_id") REFERENCES "public"."conceptos_de_facturacion" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
        ADD FOREIGN KEY ("efector_id") REFERENCES "public"."efectores" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
        ADD FOREIGN KEY ("tipo_de_debito_prestacional_id") REFERENCES "public"."tipos_de_debitos_prestacionales" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
        ADD FOREIGN KEY ("estado_del_proceso_id") REFERENCES "public"."estados_de_los_procesos" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
        ALTER COLUMN "informado_sirge" SET DEFAULT false,
        ALTER COLUMN "procesado_para_debito" SET DEFAULT false,
        ALTER COLUMN "estado_del_proceso_id" SET DEFAULT 1;

      CREATE INDEX  ON "public"."informes_debitos_prestacionales" ("concepto_de_facturacion_id"  );
      CREATE INDEX  ON "public"."informes_debitos_prestacionales" ("efector_id"  );
      CREATE INDEX  ON "public"."informes_debitos_prestacionales" ("tipo_de_debito_prestacional_id"  );
      CREATE INDEX  ON "public"."informes_debitos_prestacionales" ("estado_del_proceso_id"  );
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE "public"."informes_debitos_prestacionales"
        DROP CONSTRAINT "informes_debitos_prestacionales_estado_del_proceso_id_fkey",
        DROP CONSTRAINT "informes_debitos_prestacional_tipo_de_debito_prestacional__fkey",
        DROP CONSTRAINT "informes_debitos_prestacionales_efector_id_fkey",
        DROP CONSTRAINT "informes_debitos_prestacionales_concepto_de_facturacion_id_fkey";

      DROP INDEX "public"."informes_debitos_prestacional_tipo_de_debito_prestacional_i_idx";
      DROP INDEX "public"."informes_debitos_prestacionales_concepto_de_facturacion_id_idx";
      DROP INDEX "public"."informes_debitos_prestacionales_efector_id_idx";
      DROP INDEX "public"."informes_debitos_prestacionales_estado_del_proceso_id_idx";
    SQL
    drop_table :informes_debitos_prestacionales
  end
end
