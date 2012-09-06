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
end
