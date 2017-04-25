class AddMotivoDeBajaIdToNovedadesDeLosAfiliados < ActiveRecord::Migration
  def up
    UnidadDeAltaDeDatos.unscoped.all.each do |uad|
    execute "
        SET search_path TO #{'uad_' + uad.codigo}, public;

        ALTER TABLE IF EXISTS #{'uad_' + uad.codigo}.novedades_de_los_afiliados
       		ADD COLUMN motivo_baja_beneficiario_id integer;

       	ALTER TABLE IF EXISTS #{'uad_' + uad.codigo}.novedades_de_los_afiliados
       		ADD CONSTRAINT fk_novedades_de_los_afiliados_motivo_baja_beneficiario_#{'uad_' + uad.codigo} FOREIGN KEY (motivo_baja_beneficiario_id) REFERENCES public.motivos_bajas_beneficiarios(id);	
    "
    end
    execute "
      SET search_path TO default;
    "
  end


  def down 
   UnidadDeAltaDeDatos.unscoped.all.each do |uad|
    execute "
        SET search_path TO #{'uad_' + uad.codigo}, public;

        ALTER TABLE IF EXISTS #{'uad_' + uad.codigo}.novedades_de_los_afiliados
          DROP CONSTRAINT fk_novedades_de_los_afiliados_motivo_baja_beneficiario_#{'uad_' + uad.codigo}; 


        ALTER TABLE IF EXISTS #{'uad_' + uad.codigo}.novedades_de_los_afiliados
          DROP COLUMN motivo_baja_beneficiario_id CASCADE;
    "
    end
    execute "
      SET search_path TO default;
    "
  end

end
      
