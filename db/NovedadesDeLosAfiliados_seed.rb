# Crear las restricciones adicionales en la base de datos
class ModificarNovedadesDeLosAfiliados < ActiveRecord::Migration
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_centros_de_inscripcion
      FOREIGN KEY (centro_de_inscripcion_id) REFERENCES centros_de_inscripcion (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_tipos_de_novedad
      FOREIGN KEY (tipo_de_novedad_id) REFERENCES tipos_de_novedades (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_estados_de_las_novedades
      FOREIGN KEY (estado_de_la_novedad_id) REFERENCES estados_de_las_novedades (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_tt_dd_beneficiario
      FOREIGN KEY (tipo_de_documento_id) REFERENCES tipos_de_documentos (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_cc_dd_beneficiario
      FOREIGN KEY (clase_de_documento_id) REFERENCES clases_de_documentos (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_sexo
      FOREIGN KEY (sexo_id) REFERENCES sexos (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_categorias_de_afiliados
      FOREIGN KEY (categoria_de_afiliado_id) REFERENCES categorias_de_afiliados (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_paises
      FOREIGN KEY (pais_de_nacimiento_id) REFERENCES paises (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_lenguas_originarias
      FOREIGN KEY (lengua_originaria_id) REFERENCES lenguas_originarias (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_tribus_originarias
      FOREIGN KEY (tribu_originaria_id) REFERENCES tribus_originarias (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_tt_dd_madre
      FOREIGN KEY (tipo_de_documento_de_la_madre_id) REFERENCES tipos_de_documentos (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_tt_dd_padre
      FOREIGN KEY (tipo_de_documento_del_padre_id) REFERENCES tipos_de_documentos (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_tt_dd_tutor
      FOREIGN KEY (tipo_de_documento_del_tutor_id) REFERENCES tipos_de_documentos (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_departamentos_domicilio
      FOREIGN KEY (domicilio_departamento_id) REFERENCES departamentos (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_distritos_domicilio
      FOREIGN KEY (domicilio_distrito_id) REFERENCES distritos (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_nn_ii_afiliado
      FOREIGN KEY (alfabetizacion_del_beneficiario_id) REFERENCES niveles_de_instruccion (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_nn_ii_madre
      FOREIGN KEY (alfabetizacion_de_la_madre_id) REFERENCES niveles_de_instruccion (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_nn_ii_padre
      FOREIGN KEY (alfabetizacion_del_padre_id) REFERENCES niveles_de_instruccion (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_nn_ii_tutor
      FOREIGN KEY (alfabetizacion_del_tutor_id) REFERENCES niveles_de_instruccion (id);
  "
  execute "
    ALTER TABLE novedades_de_los_afiliados
      ADD CONSTRAINT fk_novedades_discapacidades
      FOREIGN KEY (discapacidad_id) REFERENCES discapacidades (id);
  "

  # Funciones y disparadores para modificar los datos que se insertan/modifican en la tabla
  execute "
    CREATE OR REPLACE FUNCTION modificar_novedad() RETURNS trigger AS $$
      DECLARE
        new_apellido varchar;
        new_nombre varchar;
        new_numero_de_documento varchar;
        new_domicilio_calle varchar;
        new_domicilio_numero varchar;
        new_domicilio_piso varchar;
        new_domicilio_depto varchar;
        new_domicilio_manzana varchar;
        new_domicilio_entre_calle_1 varchar;
        new_domicilio_entre_calle_2 varchar;
        new_domicilio_barrio_o_paraje varchar;
        new_domicilio_codigo_postal varchar;
        new_apellido_de_la_madre varchar;
        new_nombre_de_la_madre varchar;
        new_apellido_del_padre varchar;
        new_nombre_del_padre varchar;
        new_apellido_del_tutor varchar;
        new_nombre_del_tutor varchar;
        new_nombre_del_agente_inscriptor varchar;
      BEGIN
        -- Modificar todos los campos tipo varchar del registro
        SELECT UPPER(NEW.apellido) INTO new_apellido;
        SELECT UPPER(NEW.nombre) INTO new_nombre;
        SELECT UPPER(NEW.numero_de_documento) INTO new_numero_de_documento;
        SELECT UPPER(NEW.domicilio_calle) INTO new_domicilio_calle;
        SELECT UPPER(NEW.domicilio_numero) INTO new_domicilio_numero;
        SELECT UPPER(NEW.domicilio_piso) INTO new_domicilio_piso;
        SELECT UPPER(NEW.domicilio_depto) INTO new_domicilio_depto;
        SELECT UPPER(NEW.domicilio_manzana) INTO new_domicilio_manzana;
        SELECT UPPER(NEW.domicilio_entre_calle_1) INTO new_domicilio_entre_calle_1;
        SELECT UPPER(NEW.domicilio_entre_calle_2) INTO new_domicilio_entre_calle_2;
        SELECT UPPER(NEW.domicilio_barrio_o_paraje) INTO new_domicilio_barrio_o_paraje;
        SELECT UPPER(NEW.domicilio_codigo_postal) INTO new_domicilio_codigo_postal;
        SELECT UPPER(NEW.apellido_de_la_madre) INTO new_apellido_de_la_madre;
        SELECT UPPER(NEW.nombre_de_la_madre) INTO new_nombre_de_la_madre;
        SELECT UPPER(NEW.apellido_del_padre) INTO new_apellido_del_padre;
        SELECT UPPER(NEW.nombre_del_padre) INTO new_nombre_del_padre;
        SELECT UPPER(NEW.apellido_del_tutor) INTO new_apellido_del_tutor;
        SELECT UPPER(NEW.nombre_del_tutor) INTO new_nombre_del_tutor;
        SELECT UPPER(NEW.nombre_del_agente_inscriptor) INTO new_nombre_del_agente_inscriptor;
        NEW.apellido = new_apellido;
        NEW.nombre = new_nombre;
        NEW.numero_de_documento = new_numero_de_documento;
        NEW.domicilio_calle = new_domicilio_calle;
        NEW.domicilio_numero = new_domicilio_numero;
        NEW.domicilio_piso = new_domicilio_piso;
        NEW.domicilio_depto = new_domicilio_depto;
        NEW.domicilio_manzana = new_domicilio_manzana;
        NEW.domicilio_entre_calle_1 = new_domicilio_entre_calle_1;
        NEW.domicilio_entre_calle_2 = new_domicilio_entre_calle_2;
        NEW.domicilio_barrio_o_paraje = new_domicilio_barrio_o_paraje;
        NEW.domicilio_codigo_postal = new_domicilio_codigo_postal;
        NEW.apellido_de_la_madre = new_apellido_de_la_madre;
        NEW.nombre_de_la_madre = new_nombre_de_la_madre;
        NEW.apellido_del_padre = new_apellido_del_padre;
        NEW.nombre_del_padre = new_nombre_del_padre;
        NEW.apellido_del_tutor = new_apellido_del_tutor;
        NEW.nombre_del_tutor = new_nombre_del_tutor;
        NEW.nombre_del_agente_inscriptor = new_nombre_del_agente_inscriptor;

        -- Devolver el registro modificado
        RETURN NEW;
      END;
    $$ LANGUAGE plpgsql;
  "
  execute "
    CREATE TRIGGER trg_modificar_novedad_del_afiliado
      BEFORE INSERT OR UPDATE ON novedades_de_los_afiliados
      FOR EACH ROW EXECUTE PROCEDURE modificar_novedad();
  "
end
