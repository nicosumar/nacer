# Crear las funciones adicionales en la base de datos
class ModificarCentrosDeInscripcionUnidadesDeAltaDeDatos < ActiveRecord::Migration

  # Crear las funciones y disparadores que se encargan de modificar la estructura de la BB.DD.
  # cada vez que se agrega un centro de inscripción a una unidad de alta de datos
  execute "
    -- Ejecutar todo dentro de una transacción
    BEGIN TRANSACTION;

    -- FUNCTION: crear_secuencia_clave_de_beneficiario
    -- La función se encarga de crear una secuencia en el esquema de la UAD a la que se ha asignado un centro
    -- de inscripción, para generar incrementalmente los números de beneficiario (últimos 6 dígitos de la clave)

    CREATE OR REPLACE FUNCTION crear_secuencia_clave_de_beneficiario() RETURNS trigger AS $$
      DECLARE
        codigo_de_uad text;
        codigo_de_ci text;
        existe bool;
      BEGIN
        SELECT codigo FROM unidades_de_alta_de_datos WHERE id = NEW.unidad_de_alta_de_datos_id INTO codigo_de_uad;
        SELECT codigo FROM centros_de_inscripcion WHERE id = NEW.centro_de_inscripcion_id INTO codigo_de_ci;
        SELECT COUNT(*) > 0
          FROM information_schema.sequences
          WHERE
            sequence_schema = ('uad_' || codigo_de_uad)
            AND sequence_name = ('ci_' || codigo_de_ci || '_clave_seq')
        INTO existe;

        IF NOT existe THEN
          EXECUTE 'CREATE SEQUENCE uad_' || codigo_de_uad || '.ci_' || codigo_de_ci || '_clave_seq';
          EXECUTE 'CREATE SEQUENCE uad_' || codigo_de_uad || '.ci_' || codigo_de_ci || '_archivo_a_seq';
        END IF;
        RETURN NEW;
      END;
    $$ LANGUAGE plpgsql;

    -- TRIGGER: agregar_ci_a_uad
    -- Disparador que se activa cada vez que se realiza un INSERT en la tabla que asocia las UADs con los CIs y
    -- se encarga de llamar la función que crea la secuencia necesaria para generar los números de beneficiario
    -- en cada nueva inscripción.

    CREATE TRIGGER agregar_ci_a_uad
      AFTER INSERT ON centros_de_inscripcion_unidades_de_alta_de_datos
      FOR EACH ROW EXECUTE PROCEDURE crear_secuencia_clave_de_beneficiario();

    -- Completar la transacción
    COMMIT TRANSACTION;
  "

end
