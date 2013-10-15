class CreateAnexosMedicosPrestaciones < ActiveRecord::Migration
  def up
    create_table :anexos_medicos_prestaciones do |t|
      t.references :liquidacion_sumar_anexo_medico
      t.references :prestacion_liquidada
      t.references :estado_de_la_prestacion
      t.references :motivo_de_rechazo
      t.text :observaciones

      t.timestamps
    end
    execute <<-SQL
      ALTER TABLE "public"."anexos_medicos_prestaciones"
      ADD FOREIGN KEY ("liquidacion_sumar_anexo_medico_id") 
        REFERENCES "public"."liquidaciones_sumar_anexos_medicos" ("id") 
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

      CREATE INDEX  ON "public"."anexos_medicos_prestaciones" ("liquidacion_sumar_anexo_medico_id");
      CREATE INDEX  ON "public"."anexos_medicos_prestaciones" ("prestacion_liquidada_id");
      CREATE INDEX  ON "public"."anexos_medicos_prestaciones" ("estado_de_la_prestacion_id");
      CREATE INDEX  ON "public"."anexos_medicos_prestaciones" ("motivo_de_rechazo_id");
    SQL
  end

  def down
    drop_table :anexos_medicos_prestaciones
  end
end
