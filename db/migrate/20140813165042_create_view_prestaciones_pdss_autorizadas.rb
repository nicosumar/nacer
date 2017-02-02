class CreateViewPrestacionesPdssAutorizadas < ActiveRecord::Migration
  def up
    # Crea la vista para el modelo falso PrestacionPdssAutorizada
    execute "
      CREATE OR REPLACE VIEW prestaciones_pdss_autorizadas AS
        SELECT DISTINCT ON (pa.autorizante_al_alta_type, pa.autorizante_al_alta_id, ppp.prestacion_pdss_id)
            pa.efector_id, ppp.prestacion_pdss_id, pa.fecha_de_inicio, pa.autorizante_al_alta_id, pa.autorizante_al_alta_type,
            pa.fecha_de_finalizacion, pa.autorizante_de_la_baja_id, pa.autorizante_de_la_baja_type, pa.created_at, pa.updated_at,
            pa.creator_id, pa.updater_id
          FROM
            prestaciones_autorizadas pa
            JOIN prestaciones_prestaciones_pdss ppp
              ON ppp.prestacion_id = pa.prestacion_id;
    "

    # Crea la regla que reescribe la eliminación de un registro de la vista para que se eliminen de la tabla "real" (prestaciones_autorizadas)
    # todos los registros existentes que están asociados con la prestación PDSS eliminada para ese autorizante_al_alta.
    execute "
      CREATE RULE eliminar_prestacion_pdss_autorizada AS ON DELETE TO prestaciones_pdss_autorizadas
        DO INSTEAD
          DELETE FROM prestaciones_autorizadas pa
            WHERE
              pa.autorizante_al_alta_type = OLD.autorizante_al_alta_type
              AND pa.autorizante_al_alta_id = OLD.autorizante_al_alta_id
              AND pa.prestacion_id IN (
                SELECT ppp.prestacion_id
                  FROM prestaciones_prestaciones_pdss ppp
                  WHERE ppp.prestacion_pdss_id = OLD.prestacion_pdss_id
              );
    "

    # Crea la regla que reescribe la modificación de un registro de la vista para que se modifiquen de la tabla "real" (prestaciones_autorizadas)
    # todos los registros existentes que están asociados con la prestación PDSS modificada para ese autorizante_al_alta.
    # NO SE PERMITE MODIFICAR el ID de prestacion_pdss.
    execute "
      CREATE OR REPLACE RULE actualizar_prestacion_pdss_autorizada AS ON UPDATE TO prestaciones_pdss_autorizadas
        DO INSTEAD
          UPDATE prestaciones_autorizadas
            SET
              efector_id = NEW.efector_id,
              fecha_de_inicio = NEW.fecha_de_inicio,
              autorizante_al_alta_id = NEW.autorizante_al_alta_id,
              autorizante_al_alta_type = NEW.autorizante_al_alta_type,
              fecha_de_finalizacion = NEW.fecha_de_finalizacion,
              autorizante_de_la_baja_id = NEW.autorizante_de_la_baja_id,
              autorizante_de_la_baja_type = NEW.autorizante_de_la_baja_type,
              created_at = NEW.created_at,
              updated_at = NEW.updated_at,
              creator_id = NEW.creator_id,
              updater_id = NEW.updater_id
            FROM prestaciones_prestaciones_pdss ppp
            WHERE
              prestaciones_autorizadas.autorizante_al_alta_type = OLD.autorizante_al_alta_type
              AND prestaciones_autorizadas.autorizante_al_alta_id = OLD.autorizante_al_alta_id
              AND prestaciones_autorizadas.prestacion_id = ppp.prestacion_id
              AND ppp.prestacion_pdss_id = OLD.prestacion_pdss_id;
    "

    # Crea la regla que reescribe la inserción de un registro de la vista para que se inserten en la tabla "real" (prestaciones_autorizadas)
    # todos los registros que están asociados con la prestación PDSS insertada para ese autorizante_al_alta.
    execute "
      CREATE OR REPLACE RULE insertar_prestacion_pdss_autorizada AS ON INSERT TO prestaciones_pdss_autorizadas
        DO INSTEAD
          INSERT INTO prestaciones_autorizadas (
              efector_id, prestacion_id, fecha_de_inicio, autorizante_al_alta_id, autorizante_al_alta_type,
              fecha_de_finalizacion, autorizante_de_la_baja_id, autorizante_de_la_baja_type, created_at, updated_at,
              creator_id, updater_id
            )
            SELECT
                NEW.efector_id, ppp.prestacion_id, NEW.fecha_de_inicio, NEW.autorizante_al_alta_id, NEW.autorizante_al_alta_type,
                NEW.fecha_de_finalizacion, NEW.autorizante_de_la_baja_id, NEW.autorizante_de_la_baja_type,
                NEW.created_at, NEW.updated_at, NEW.creator_id, NEW.updater_id
              FROM prestaciones_prestaciones_pdss ppp
              WHERE ppp.prestacion_pdss_id = NEW.prestacion_pdss_id;
    "

    # Crear la regla que, cuando se inserta un nuevo registro en la tabla de join prestaciones_prestaciones_pdss que relaciona una nueva prestacion_id con
    # una prestacion_pdss_id existente, inserta esa misma prestacion en la tabla prestaciones_autorizadas para cada autorizante que habilitaba esa
    # prestacion_pdss
    execute "
      CREATE OR REPLACE RULE insertar_prestacion_prestacion_pdss AS ON INSERT TO prestaciones_prestaciones_pdss
        DO ALSO
          INSERT INTO prestaciones_autorizadas (
              efector_id, prestacion_id, fecha_de_inicio, autorizante_al_alta_id, autorizante_al_alta_type, fecha_de_finalizacion,
              autorizante_de_la_baja_id, autorizante_de_la_baja_type, created_at, updated_at, creator_id, updater_id
            )
            SELECT
                ppa.efector_id, ppp.prestacion_id, ppa.fecha_de_inicio, ppa.autorizante_al_alta_id, ppa.autorizante_al_alta_type,
                ppa.fecha_de_finalizacion, ppa.autorizante_de_la_baja_id, ppa.autorizante_de_la_baja_type, now(), now(),
                ppa.creator_id, ppa.updater_id
              FROM
                prestaciones_pdss_autorizadas ppa
                JOIN prestaciones_prestaciones_pdss ppp ON ppa.prestacion_pdss_id = ppp.prestacion_pdss_id
                LEFT JOIN prestaciones_autorizadas pa ON (
                  pa.autorizante_al_alta_type = ppa.autorizante_al_alta_type
                  AND pa.autorizante_al_alta_id = ppa.autorizante_al_alta_id
                  AND pa.prestacion_id = ppp.prestacion_id
                )
              WHERE
                ppp.prestacion_pdss_id = NEW.prestacion_pdss_id
                AND pa.id IS NULL;
    "

    # Por única vez, modificar la tabla de prestaciones_autorizadas añadiendo las prestaciones que estén faltando, relacionadas con las
    # prestaciones PDSS.
    execute "
      INSERT INTO prestaciones_autorizadas (
          efector_id, prestacion_id, fecha_de_inicio, autorizante_al_alta_id, autorizante_al_alta_type, fecha_de_finalizacion,
          autorizante_de_la_baja_id, autorizante_de_la_baja_type, created_at, updated_at, creator_id, updater_id
        )
        SELECT
            ppa.efector_id, ppp.prestacion_id, ppa.fecha_de_inicio, ppa.autorizante_al_alta_id, ppa.autorizante_al_alta_type,
            ppa.fecha_de_finalizacion, ppa.autorizante_de_la_baja_id, ppa.autorizante_de_la_baja_type, now(), now(),
            ppa.creator_id, ppa.updater_id
          FROM
            prestaciones_pdss_autorizadas ppa
            JOIN prestaciones_prestaciones_pdss ppp ON ppa.prestacion_pdss_id = ppp.prestacion_pdss_id
            LEFT JOIN prestaciones_autorizadas pa ON (
              pa.autorizante_al_alta_type = ppa.autorizante_al_alta_type
              AND pa.autorizante_al_alta_id = ppa.autorizante_al_alta_id
              AND pa.prestacion_id = ppp.prestacion_id
            )
          WHERE pa.id IS NULL;
    "
  end

  def down
    execute "
      DROP VIEW IF EXISTS prestaciones_pdss_autorizadas CASCADE;
    "
  end
end
