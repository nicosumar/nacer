# -*- encoding : utf-8 -*-
class AgregarTriggerParaGenerarSecuenciasCuasifacturas < ActiveRecord::Migration
  def up
    # Crear las funciones y disparadores que se encargan de modificar la estructura de la BB.DD.
    # cada vez que se agrega una nueva unidad de alta de datos
    execute "
      -- FUNCTION: crear_secuencia_de_cuasifacturas
      -- La función se encarga de crear las secuencias para generar los números correlativos de
      -- cuasifacturas.
      CREATE OR REPLACE FUNCTION crear_secuencia_de_cuasifacturas() RETURNS trigger AS $$
        DECLARE
          existe bool;
        BEGIN
          SELECT COUNT(*) > 0
            FROM information_schema.sequences
            WHERE
              sequence_schema = 'public'
              AND sequence_name = ('cuasifactura_sumar_seq_efector_id_' || NEW.id::text)
            INTO existe;

          IF (NEW.unidad_de_alta_de_datos_id IS NOT NULL AND NOT existe) THEN
            EXECUTE 'CREATE SEQUENCE public.cuasifactura_sumar_seq_efector_id_' || NEW.id::text;
          END IF;
          RETURN NEW;
        END;
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER cambio_de_uad_en_efectores
        AFTER INSERT OR UPDATE OF unidad_de_alta_de_datos_id ON efectores
        FOR EACH ROW EXECUTE PROCEDURE crear_secuencia_de_cuasifacturas();
    "
  end

  def down
    execute "
      DROP TRIGGER cambio_de_uad_en_efectores ON efectores;
      DROP FUNCTION crear_secuencia_de_cuasifacturas();
    "
  end
end
