# -*- encoding : utf-8 -*-
# Crear las restricciones adicionales en la base de datos
class ModificaRegistrosDePrestacionesr < ActiveRecord::Migration
  execute "
    ALTER TABLE registros_de_prestaciones
      ADD CONSTRAINT fk_regpp_clases_de_documentos
      FOREIGN KEY (clase_de_documento_id) REFERENCES clases_de_documentos (id);
  "
  execute "
    ALTER TABLE registros_de_prestaciones
      ADD CONSTRAINT fk_regpp_tipos_de_documentos
      FOREIGN KEY (tipo_de_documento_id) REFERENCES tipos_de_documentos (id);
  "
  execute "
    ALTER TABLE registros_de_prestaciones
      ADD CONSTRAINT fk_regpp_prestaciones
      FOREIGN KEY (prestacion_id) REFERENCES prestaciones (id);
  "
  execute "
    ALTER TABLE registros_de_prestaciones
      ADD CONSTRAINT fk_regpp_estados_de_las_prestaciones
      FOREIGN KEY (estado_de_la_prestacion_id) REFERENCES estados_de_las_prestaciones (id);
  "
  execute "
    ALTER TABLE registros_de_prestaciones
      ADD CONSTRAINT fk_regpp_motivos_de_rechazos
      FOREIGN KEY (motivo_de_rechazo_id) REFERENCES motivos_de_rechazos (id);
  "
  execute "
    ALTER TABLE registros_de_prestaciones
      ADD CONSTRAINT fk_regpp_cuasi_facturas
      FOREIGN KEY (cuasi_factura_id) REFERENCES cuasi_facturas (id);
  "
  execute "
    ALTER TABLE registros_de_prestaciones
      ADD CONSTRAINT fk_regpp_nomencladores
      FOREIGN KEY (nomenclador_id) REFERENCES nomencladores (id);
  "
end
