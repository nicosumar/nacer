# -*- encoding : utf-8 -*-

class ModificarTriggerPrestacionBrindadaFts < ActiveRecord::Migration
  def up
    load 'db/sp/trigger_prestaciones_brindadas_fts.rb'

    UnidadDeAltaDeDatos.where(facturacion: true).order(:codigo).each do |uad|
      ActiveRecord::Base.connection.execute "
        UPDATE uad_#{uad.codigo}.prestaciones_brindadas
          SET estado_de_la_prestacion_id = 11, observaciones_de_liquidacion = 'Prestación duplicada'
          WHERE id IN (
            SELECT id
              FROM uad_#{uad.codigo}.prestaciones_brindadas pb1
              WHERE EXISTS (
                SELECT *
                  FROM uad_#{uad.codigo}.prestaciones_brindadas pb2
                  WHERE
                    pb1.clave_de_beneficiario = pb2.clave_de_beneficiario
                    AND pb1.prestacion_id = pb2.prestacion_id
                    AND pb1.fecha_de_la_prestacion = pb2.fecha_de_la_prestacion
                    AND pb1.estado_de_la_prestacion_id = pb2.estado_de_la_prestacion_id
                    AND pb1 > pb2
              )
          );
      "
      ActiveRecord::Base.connection.execute "
        DELETE FROM uad_#{uad.codigo}.busquedas_locales
          WHERE
            modelo_type = 'PrestacionBrindada'
            AND modelo_id IN (
              SELECT pb.id
                FROM
                  uad_#{uad.codigo}.prestaciones_brindadas pb
                  JOIN estados_de_las_prestaciones ep ON (ep.id = pb.estado_de_la_prestacion_id)
                WHERE NOT ep.indexable
            );
      "
      ActiveRecord::Base.connection.execute "
        INSERT INTO uad_#{uad.codigo}.busquedas_locales (modelo_type, modelo_id, titulo, texto, vector_fts)
          SELECT 'PrestacionBrindada'::text, pb.id, ''::text, ''::text, ''::tsvector
            FROM
              uad_#{uad.codigo}.prestaciones_brindadas pb
              JOIN estados_de_las_prestaciones ep ON (ep.id = pb.estado_de_la_prestacion_id)
            WHERE
              ep.indexable
              AND NOT EXISTS (
                SELECT *
                  FROM uad_#{uad.codigo}.busquedas_locales bl
                  WHERE bl.modelo_type = 'PrestacionBrindada' AND bl.modelo_id = pb.id
              );
      "
      ActiveRecord::Base.connection.execute "
        UPDATE uad_#{uad.codigo}.prestaciones_brindadas SET estado_de_la_prestacion_id = estado_de_la_prestacion_id;
      "
    end
  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
