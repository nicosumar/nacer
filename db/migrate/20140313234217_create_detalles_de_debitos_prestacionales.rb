class CreateDetallesDeDebitosPrestacionales < ActiveRecord::Migration
  def up
    create_table :detalles_de_debitos_prestacionales do |t|
      t.references :prestacion_liquidada
      t.references :motivo_de_rechazo
      t.references :afiliado
      t.boolean :procesado_para_debito
      t.boolean :informado_sirge, default: false
      t.text :observaciones, default: false

      t.timestamps
    end         

    execute <<-SQL
      ALTER TABLE "public"."detalles_de_debitos_prestacionales"
        ADD FOREIGN KEY ("prestacion_liquidada_id") REFERENCES "public"."prestaciones_liquidadas" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
        ADD FOREIGN KEY ("motivo_de_rechazo_id") REFERENCES "public"."motivos_de_rechazos" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION,
        ADD FOREIGN KEY ("afiliado_id") REFERENCES "public"."afiliados" ("afiliado_id") ON DELETE RESTRICT ON UPDATE NO ACTION,
        ADD UNIQUE ("prestacion_liquidada_id");

      CREATE UNIQUE INDEX  ON "public"."detalles_de_debitos_prestacionales" ("prestacion_liquidada_id");
      CREATE INDEX  ON "public"."detalles_de_debitos_prestacionales" ("motivo_de_rechazo_id");
      CREATE INDEX  ON "public"."detalles_de_debitos_prestacionales" ("afiliado_id");
    SQL
  end

  def down
    drop_table :detalles_de_debitos_prestacionales
  end
end
