class CreateLiquidacionesInformes < ActiveRecord::Migration
  def up
    create_table :liquidaciones_informes do |t|
      t.string     :numero_de_expediente
      t.text       :observaciones
      t.references :efector
      t.references :liquidacion_sumar
      t.references :liquidacion_sumar_cuasifactura
      t.references :liquidacion_sumar_anexo_administrativo
      t.references :liquidacion_sumar_anexo_medico
      t.references :estado_del_proceso

      t.timestamps
    end
    
    # 
    execute <<-SQL
      ALTER TABLE "public"."liquidaciones_informes"
        ADD FOREIGN KEY ("liquidacion_sumar_id") 
          REFERENCES "public"."liquidaciones_sumar" ("id") 
          ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD FOREIGN KEY ("liquidacion_sumar_cuasifactura_id") 
          REFERENCES "public"."liquidaciones_sumar_cuasifacturas" ("id") 
          ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD FOREIGN KEY ("liquidacion_sumar_anexo_administrativo_id") 
          REFERENCES "public"."liquidaciones_sumar_anexos_administrativos" ("id") 
          ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD FOREIGN KEY ("liquidacion_sumar_anexo_medico_id") 
          REFERENCES "public"."liquidaciones_sumar_anexos_medicos" ("id") 
          ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD FOREIGN KEY ("estado_del_proceso_id") 
          REFERENCES "public"."estados_de_los_procesos" ("id") 
          ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD FOREIGN KEY ("efector_id") 
          REFERENCES "public"."efectores" ("id") 
          ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD UNIQUE ("liquidacion_sumar_id", "liquidacion_sumar_cuasifactura_id");

      CREATE INDEX  ON "public"."liquidaciones_informes" ("liquidacion_sumar_id");
      CREATE INDEX  ON "public"."liquidaciones_informes" ("liquidacion_sumar_cuasifactura_id");
      CREATE INDEX  ON "public"."liquidaciones_informes" ("liquidacion_sumar_anexo_administrativo_id");
      CREATE INDEX  ON "public"."liquidaciones_informes" ("liquidacion_sumar_anexo_medico_id");
      CREATE INDEX  ON "public"."liquidaciones_informes" ("estado_del_proceso_id");
      CREATE INDEX  ON "public"."liquidaciones_informes" ("efector_id");
    SQL

    #cargo las cuasifacturas que ya existen
    execute <<-SQL
      INSERT INTO "public"."liquidaciones_informes" 
      ("efector_id", "liquidacion_sumar_id", "liquidacion_sumar_cuasifactura_id", "estado_del_proceso_id", "created_at", "updated_at") 
      SELECT lc.efector_id, ls.id, lc.id, (select id from estados_de_los_procesos where codigo = 'N'), now(), now()
      from liquidaciones_sumar ls
        join liquidaciones_sumar_cuasifacturas lc on lc.liquidacion_sumar_id = ls.id
    SQL

  end

  def down
    drop_table :liquidaciones_informes
  end
end
