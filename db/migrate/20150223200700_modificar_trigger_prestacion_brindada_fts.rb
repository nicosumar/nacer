class ModificarTriggerPrestacionBrindadaFts < ActiveRecord::Migration
  def up
    load 'db/sp/trigger_prestaciones_brindadas_fts.rb'

    UnidadDeAltaDeDatos.where(facturacion: true).each do |uad|
      ActiveRecord::Base.connection.execute ""+
        "DELETE FROM uad_#{uad.codigo}.busquedas_locales WHERE modelo_type = 'PrestacionBrindada' AND modelo_id IN (\n"+
        "          SELECT pb.id FROM uad_#{uad.codigo}.prestaciones_brindadas pb JOIN estados_de_las_prestaciones ep ON (ep.id = pb.estado_de_la_prestacion_id)\n"+
        "            WHERE NOT ep.indexable);\n"+
        "INSERT INTO uad_#{uad.codigo}.busquedas_locales (modelo_type, modelo_id)\n"+
        "  SELECT 'PrestacionBrindada', pb.id FROM\n"+
        "  uad_#{uad.codigo}.prestaciones_brindadas pb JOIN estados_de_las_prestaciones ep ON (ep.id = pb.estado_de_la_prestacion_id)\n"+
        "  WHERE ep.indexable AND NOT EXISTS (\n"+
        "    SELECT * FROM uad_#{uad.codigo}.busquedas_locales bl WHERE bl.modelo_type = 'PrestacionBrindada' AND bl.modelo_id = pb.id\n"+
        "            );\n"+
        "UPDATE uad_#{uad.codigo}.prestaciones_brindadas SET estado_de_la_prestacion_id = estado_de_la_prestacion_id;"
    end
      


  end

  def down
    #raise ActiveRecord::IrreversibleMigration
  end
end
