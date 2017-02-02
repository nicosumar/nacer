class AddIrDatosYAdvertencias < ActiveRecord::Migration
  def up

  	#Agrega FK a la tabla de prestaciones liquidadas datos
  	execute <<-SQL
  		ALTER TABLE "public"."prestaciones_liquidadas_datos"
			ADD FOREIGN KEY ("liquidacion_id") 
				REFERENCES "public"."liquidaciones_sumar" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
			ADD FOREIGN KEY ("prestacion_liquidada_id") 
				REFERENCES "public"."prestaciones_liquidadas" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
			ADD FOREIGN KEY ("dato_reportable_id") 
				REFERENCES "public"."datos_reportables" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
			ADD FOREIGN KEY ("dato_reportable_requerido_id") 
				REFERENCES "public"."datos_reportables_requeridos" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
  	SQL

  	#Agrega las FK a la tabla de prestaciones liquidadas advertencias
  	execute <<-SQL
		ALTER TABLE "public"."prestaciones_liquidadas_advertencias"
			ADD FOREIGN KEY ("liquidacion_id") 
				REFERENCES "public"."liquidaciones_sumar" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
			ADD FOREIGN KEY ("prestacion_liquidada_id") 
				REFERENCES "public"."prestaciones_liquidadas" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT,
			ADD FOREIGN KEY ("metodo_de_validacion_id") 
				REFERENCES "public"."metodos_de_validacion" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
  	SQL
  end

  def down
  	execute <<-SQL
		ALTER TABLE "public"."prestaciones_liquidadas_datos"
			DROP CONSTRAINT "prestaciones_liquidadas_datos_dato_reportable_requerido_id_fkey",
			DROP CONSTRAINT "prestaciones_liquidadas_datos_dato_reportable_id_fkey",
			DROP CONSTRAINT "prestaciones_liquidadas_datos_prestacion_liquidada_id_fkey",
			DROP CONSTRAINT "prestaciones_liquidadas_datos_liquidacion_id_fkey";
  	SQL

  	execute <<-SQL
		ALTER TABLE "public"."prestaciones_liquidadas_advertencias"
		DROP CONSTRAINT "prestaciones_liquidadas_advertenci_metodo_de_validacion_id_fkey",
		DROP CONSTRAINT "prestaciones_liquidadas_advertenci_prestacion_liquidada_id_fkey",
		DROP CONSTRAINT "prestaciones_liquidadas_advertencias_liquidacion_id_fkey";
  	SQL
  end
end
