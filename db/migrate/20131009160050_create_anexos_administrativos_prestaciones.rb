class CreateAnexosAdministrativosPrestaciones < ActiveRecord::Migration
  def up
    create_table :anexos_administrativos_prestaciones do |t|
      t.references :liquidacion_sumar_anexo_administrativo
      t.references :prestacion_liquidada
      t.references :estado_de_la_prestacion
      t.references :motivo_de_rechazo
      t.text :observaciones

      t.timestamps
    end
    execute <<-SQL
      ALTER TABLE "public"."anexos_administrativos_prestaciones"
        ADD FOREIGN KEY ("liquidacion_sumar_anexo_administrativo_id") 
          REFERENCES "public"."liquidaciones_sumar_anexos_administrativos" ("id") 
          ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD FOREIGN KEY ("prestacion_liquidada_id") 
          REFERENCES "public"."prestaciones_liquidadas" ("id") 
          ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD FOREIGN KEY ("estado_de_la_prestacion_id") 
          REFERENCES "public"."estados_de_las_prestaciones" ("id") 
          ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD FOREIGN KEY ("motivo_de_rechazo_id") 
          REFERENCES "public"."motivos_de_rechazos" ("id") 
          ON DELETE RESTRICT ON UPDATE RESTRICT;

        CREATE INDEX  ON "public"."anexos_administrativos_prestaciones" ("liquidacion_sumar_anexo_administrativo_id");
        CREATE INDEX  ON "public"."anexos_administrativos_prestaciones" ("prestacion_liquidada_id");
        CREATE INDEX  ON "public"."anexos_administrativos_prestaciones" ("estado_de_la_prestacion_id");
        CREATE INDEX  ON "public"."anexos_administrativos_prestaciones" ("motivo_de_rechazo_id");
    SQL
  end

  def down
    drop_table :anexos_administrativos_prestaciones
  end
end
