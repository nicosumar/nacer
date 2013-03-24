# -*- encoding : utf-8 -*-
class AddColumnsToNovedadesDeLosAfiliados < ActiveRecord::Migration
  def change
    UnidadDeAltaDeDatos.where(:inscripcion => true).each do |uad|
      execute "
        SET search_path TO #{'uad_' + uad.codigo}, public;
        ALTER TABLE #{'uad_' + uad.codigo}.novedades_de_los_afiliados
          ADD COLUMN mes_y_anio_de_proceso date;
        ALTER TABLE #{'uad_' + uad.codigo}.novedades_de_los_afiliados
          ADD COLUMN mensaje_de_la_baja text;
      "
    end
    execute "
      SET search_path TO default;
    "
  end
end
