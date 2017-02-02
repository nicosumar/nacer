class CreateLiquidacionesSumarCuasifacturas < ActiveRecord::Migration
  def up
    create_table :liquidaciones_sumar_cuasifacturas do |t|
      
      t.references :liquidacion_sumar
      t.references :efector
      t.column :monto_total, "numeric(15,4)"
      t.string :numero_cuasifactura
      t.text :observaciones

      t.timestamps
    end

    execute <<-SQL
    -- Function: generar_numero_cuasifactura()
        CREATE OR REPLACE FUNCTION generar_numero_cuasifactura()
          RETURNS trigger AS
        $BODY$DECLARE 
          v_secuencia INT;
          v_secuencia_nombre VARCHAR;
          v_cuasifactura varchar;
          v_query varchar;
        BEGIN
          v_secuencia_nombre = 'cuasi_factura_sumar_seq_efector_id_'||CAST(NEW.efector_id  as varchar);
          v_query = 'SELECT ' ||
                      '(CASE ' ||
                      'WHEN is_called THEN last_value + 1 '||
                      'ELSE last_value ' ||
                      'END)  FROM ' || v_secuencia_nombre ;

          EXECUTE v_query INTO v_secuencia;

          v_secuencia =  nextval(v_secuencia_nombre::text);
          NEW.numero_cuasifactura = to_char(NEW.efector_id, '0000') ||'-'|| to_char(v_secuencia, '00000000');
               
          RETURN NEW;
        END;$BODY$
          LANGUAGE plpgsql VOLATILE
          COST 100;
        ALTER FUNCTION generar_numero_cuasifactura()
          OWNER TO nacer_adm;

    SQL
    execute <<-SQL
    ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas"
        ALTER COLUMN "created_at" SET DEFAULT now(),
        ALTER COLUMN "updated_at" SET DEFAULT now(),
        ADD FOREIGN KEY ("liquidacion_sumar_id") REFERENCES "public"."liquidaciones_sumar" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD FOREIGN KEY ("efector_id") REFERENCES "public"."efectores" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
        ADD UNIQUE ("numero_cuasifactura");

        CREATE INDEX  ON "public"."liquidaciones_sumar_cuasifacturas" ("liquidacion_sumar_id");
        CREATE INDEX  ON "public"."liquidaciones_sumar_cuasifacturas" ("efector_id");
        CREATE INDEX  ON "public"."liquidaciones_sumar_cuasifacturas" ("liquidacion_sumar_id", "efector_id");

        CREATE TRIGGER "generar_Cuasifactura" BEFORE INSERT ON "public"."liquidaciones_sumar_cuasifacturas"
          FOR EACH ROW
          EXECUTE PROCEDURE "public"."generar_numero_cuasifactura"();
    SQL

    #creo las secuencias para cada efector:
    efectores = Efector.where("unidad_de_alta_de_datos_id is not null")
    efectores.each do |e|
      execute "CREATE SEQUENCE \"public\".\"cuasi_factura_sumar_seq_efector_id_#{e.id}\"\n"+
              "INCREMENT 1\n"+
              "MINVALUE 1\n"+
              "MAXVALUE 9223372036854775807\n"+
              "START 1;\n"+
              "ALTER TABLE \"public\".\"cuasi_factura_sumar_seq_efector_id_#{e.id}\" OWNER TO \"nacer_adm\";"
    end

  end

  def down

    execute <<-SQL
    ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas"
      DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_cuasifacturas_efector_id_fkey",
      DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_cuasifacturas_liquidacion_sumar_id_fkey",
      DROP CONSTRAINT IF EXISTS "liquidaciones_sumar_cuasifacturas_numero_cuasifactura_key" ;

      DROP TRIGGER "generar_Cuasifactura" ON "public"."liquidaciones_sumar_cuasifacturas";

      DROP INDEX "public"."liquidaciones_sumar_cuasifact_liquidacion_sumar_id_efector__idx";
      DROP INDEX "public"."liquidaciones_sumar_cuasifacturas_efector_id_idx";
      DROP INDEX "public"."liquidaciones_sumar_cuasifacturas_liquidacion_sumar_id_idx";

      DROP FUNCTION IF EXISTS generar_numero_cuasifactura();
    SQL
    
    #Elimino las secuencias para cada efector
    efectores = Efector.where("unidad_de_alta_de_datos_id is not null")
    efectores.each do |e|
      execute "DROP SEQUENCE IF EXISTS public.cuasi_factura_sumar_seq_efector_id_#{e.id};"
    end

    drop_table :liquidaciones_sumar_cuasifacturas
    
  end

  
end
