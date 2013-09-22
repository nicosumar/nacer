# -*- encoding : utf-8 -*-
class ModifyPrestacionesOtraVez < ActiveRecord::Migration
  def up
    # Añado una columna para registrar si una prestación es o no catastrófica, en vez de registrarlo en el objeto de la prestación
    # Añado otra columna para tipificar el tratamiento relacionado con la prestación
   execute "
      ALTER TABLE prestaciones
        ADD COLUMN es_catastrofica boolean DEFAULT 'f',
        ADD COLUMN tipo_de_tratamiento_id integer;
    "

    # Crear nuevas restricciones de claves foráneas
    execute "
      ALTER TABLE prestaciones
        ADD CONSTRAINT fk_prestaciones_tipos_de_tratamientos
          FOREIGN KEY (tipo_de_tratamiento_id) REFERENCES tipos_de_tratamientos(id);
    "

    # Actualizamos el valor de la nueva columna es_catastrofica con los datos de la tabla objetos_de_las_prestaciones
    execute "
      UPDATE prestaciones p
        SET es_catastrofica = (
          SELECT o.es_catastrofica
            FROM objetos_de_las_prestaciones o WHERE p.objeto_de_la_prestacion_id = o.id
        )
        WHERE EXISTS (
          SELECT *
            FROM objetos_de_las_prestaciones o2
            WHERE o2.id = p.objeto_de_la_prestacion_id AND o2.define_si_es_catastrofica = 't'
        );
    "

    load 'db/PrestacionesSumarFaltantes_seed.rb'
  end

  def down
    execute "
      ALTER TABLE prestaciones
        DROP COLUMN es_catastrofica boolean,
        DROP COLUMN tipo_de_tratamiento_id;
    "
  end
end
