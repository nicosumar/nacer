class CreateConsolidadosSumarDetalles < ActiveRecord::Migration
  def up
    create_table :consolidados_sumar_detalles do |t|
      t.references :consolidado_sumar
      t.references :efector
      t.references :convenio_de_administracion_sumar
      t.references :convenio_de_gestion_sumar
      t.column :total, "numeric(15,4)"

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE "public"."consolidados_sumar_detalles"
      ADD FOREIGN KEY ("consolidado_sumar_id") REFERENCES "public"."consolidados_sumar" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD FOREIGN KEY ("efector_id") REFERENCES "public"."efectores" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD FOREIGN KEY ("convenio_de_administracion_sumar_id") REFERENCES "public"."convenios_de_administracion_sumar" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
      ADD FOREIGN KEY ("convenio_de_gestion_sumar_id") REFERENCES "public"."convenios_de_gestion_sumar" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

      CREATE INDEX  ON "public"."consolidados_sumar_detalles" ("consolidado_sumar_id");
      CREATE INDEX  ON "public"."consolidados_sumar_detalles" ("efector_id");
      CREATE INDEX  ON "public"."consolidados_sumar_detalles" ("convenio_de_administracion_sumar_id");
      CREATE INDEX  ON "public"."consolidados_sumar_detalles" ("convenio_de_gestion_sumar_id");

      ALTER TABLE "public"."consolidados_sumar_detalles"
      ADD UNIQUE ("consolidado_sumar_id", "efector_id");
    SQL
  end

  def down
    drop_table :consolidados_sumar_detalles
  end
end
