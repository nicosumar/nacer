# -*- encoding : utf-8 -*-
class ModificarTriggerParaGenerarSecuenciasCuasifacturas < ActiveRecord::Migration
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
              AND sequence_name = ('cuasi_factura_sumar_seq_efector_id_' || NEW.id::text)
            INTO existe;

          IF (NEW.unidad_de_alta_de_datos_id IS NOT NULL AND NOT existe) THEN
            EXECUTE 'CREATE SEQUENCE public.cuasi_factura_sumar_seq_efector_id_' || NEW.id::text;
          END IF;
          RETURN NEW;
        END;
      $$ LANGUAGE plpgsql;
    "

    execute "
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_115
        RENAME TO cuasi_factura_sumar_seq_efector_id_115;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_116
        RENAME TO cuasi_factura_sumar_seq_efector_id_116;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_118
        RENAME TO cuasi_factura_sumar_seq_efector_id_118;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_119
        RENAME TO cuasi_factura_sumar_seq_efector_id_119;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_149
        RENAME TO cuasi_factura_sumar_seq_efector_id_149;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_150
        RENAME TO cuasi_factura_sumar_seq_efector_id_150;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_151
        RENAME TO cuasi_factura_sumar_seq_efector_id_151;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_152
        RENAME TO cuasi_factura_sumar_seq_efector_id_152;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_153
        RENAME TO cuasi_factura_sumar_seq_efector_id_153;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_154
        RENAME TO cuasi_factura_sumar_seq_efector_id_154;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_155
        RENAME TO cuasi_factura_sumar_seq_efector_id_155;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_156
        RENAME TO cuasi_factura_sumar_seq_efector_id_156;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_157
        RENAME TO cuasi_factura_sumar_seq_efector_id_157;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_158
        RENAME TO cuasi_factura_sumar_seq_efector_id_158;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_18
        RENAME TO cuasi_factura_sumar_seq_efector_id_18;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_188
        RENAME TO cuasi_factura_sumar_seq_efector_id_188;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_189
        RENAME TO cuasi_factura_sumar_seq_efector_id_189;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_191
        RENAME TO cuasi_factura_sumar_seq_efector_id_191;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_31
        RENAME TO cuasi_factura_sumar_seq_efector_id_31;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_314
        RENAME TO cuasi_factura_sumar_seq_efector_id_314;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_315
        RENAME TO cuasi_factura_sumar_seq_efector_id_315;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_317
        RENAME TO cuasi_factura_sumar_seq_efector_id_317;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_32
        RENAME TO cuasi_factura_sumar_seq_efector_id_32;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_33
        RENAME TO cuasi_factura_sumar_seq_efector_id_33;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_337
        RENAME TO cuasi_factura_sumar_seq_efector_id_337;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_338
        RENAME TO cuasi_factura_sumar_seq_efector_id_338;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_34
        RENAME TO cuasi_factura_sumar_seq_efector_id_34;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_343
        RENAME TO cuasi_factura_sumar_seq_efector_id_343;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_345
        RENAME TO cuasi_factura_sumar_seq_efector_id_345;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_35
        RENAME TO cuasi_factura_sumar_seq_efector_id_35;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_355
        RENAME TO cuasi_factura_sumar_seq_efector_id_355;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_357
        RENAME TO cuasi_factura_sumar_seq_efector_id_357;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_36
        RENAME TO cuasi_factura_sumar_seq_efector_id_36;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_37
        RENAME TO cuasi_factura_sumar_seq_efector_id_37;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_43
        RENAME TO cuasi_factura_sumar_seq_efector_id_43;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_54
        RENAME TO cuasi_factura_sumar_seq_efector_id_54;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_55
        RENAME TO cuasi_factura_sumar_seq_efector_id_55;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_56
        RENAME TO cuasi_factura_sumar_seq_efector_id_56;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_59
        RENAME TO cuasi_factura_sumar_seq_efector_id_59;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_62
        RENAME TO cuasi_factura_sumar_seq_efector_id_62;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_72
        RENAME TO cuasi_factura_sumar_seq_efector_id_72;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_79
        RENAME TO cuasi_factura_sumar_seq_efector_id_79;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_84
        RENAME TO cuasi_factura_sumar_seq_efector_id_84;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_90
        RENAME TO cuasi_factura_sumar_seq_efector_id_90;
      ALTER SEQUENCE cuasifactura_sumar_seq_efector_id_93
        RENAME TO cuasi_factura_sumar_seq_efector_id_93;
    "

  end
end
