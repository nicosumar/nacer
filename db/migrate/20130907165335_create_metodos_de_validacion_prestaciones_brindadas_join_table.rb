# -*- encoding : utf-8 -*-
class CreateMetodosDeValidacionPrestacionesBrindadasJoinTable < ActiveRecord::Migration
  def change

    # Convertimos las validaciones generales de prestaciones brindadas en objetos MetodoDeValidacion asociados
    # con todas las prestaciones

# TODO: cleanup
# Estas advertencias no deberían persistirse, ya que la vigencia de la prestación y la actividad del beneficiario se deberían verificar
# durante la liquidación
#    metodo = MetodoDeValidacion.create!(
#      :nombre => "Verificar que la prestación esté vigente",
#      :metodo => "prestacion_vigente?",
#      :mensaje => "La prestación se encuentra vencida, ya que tiene más de 120 días de antigüedad con respecto a hoy",
#      :genera_error => false
#    )
#    metodo.prestaciones = Prestacion.where("objeto_de_la_prestacion_id IS NOT NULL")
#
#    metodo = MetodoDeValidacion.create!(
#      :nombre => "Verificar que la persona estuviera activa al momento de la prestación",
#      :metodo => "beneficiario_activo?",
#      :mensaje => "La persona a la que se le brindó la prestación no se encontraba activa para esa fecha.",
#      :genera_error => false
#    )
#    metodo.prestaciones = Prestacion.where("objeto_de_la_prestacion_id IS NOT NULL")

    metodo = MetodoDeValidacion.create!(
      :nombre => "Verificar que todos los datos reportables obligatorios estén completos",
      :metodo => "datos_reportables_asociados_completos?",
      :mensaje => "Hay atributos reportables obligatorios que no se han completado",
      :genera_error => false
    )
    # Este método solo lo asocio con las prestaciones que poseen datos reportables obligatorios
    metodo.prestaciones = Prestacion.where("
      EXISTS
        (SELECT *
          FROM datos_reportables_requeridos
          WHERE datos_reportables_requeridos.prestacion_id = prestaciones.id AND datos_reportables_requeridos.obligatorio)
    ")

    # Crear una función de tipo trigger que verifique que no se dupliquen prestaciones
    execute "
      CREATE OR REPLACE FUNCTION verificar_duplicacion_de_prestaciones() RETURNS trigger AS $$
        DECLARE
          duplicada bool;
        BEGIN
          -- Si el estado de la prestación que se inserta/modifica es un estado anulado dejamos que continúe
          IF NEW.estado_de_la_prestacion_id IN (SELECT id FROM estados_de_las_prestaciones WHERE codigo IN ('U', 'S')) THEN
            RETURN NEW;
          END IF;

          -- Para todos los otros estados verificamos que la operación no cree un duplicado
          IF (TG_OP = 'INSERT') THEN
            SELECT COUNT(*) > 0
              FROM prestaciones_brindadas pb
              WHERE
                pb.clave_de_beneficiario = NEW.clave_de_beneficiario
                AND pb.fecha_de_la_prestacion = NEW.fecha_de_la_prestacion
                AND pb.prestacion_id = NEW.prestacion_id
                AND estado_de_la_prestacion_id NOT IN (
                  SELECT id FROM estados_de_las_prestaciones WHERE codigo IN ('U', 'S')
                )
              INTO duplicada;
          ELSIF (TG_OP = 'UPDATE') THEN
            SELECT COUNT(*) > 0
              FROM prestaciones_brindadas pb
              WHERE
                pb.clave_de_beneficiario = NEW.clave_de_beneficiario
                AND pb.fecha_de_la_prestacion = NEW.fecha_de_la_prestacion
                AND pb.prestacion_id = NEW.prestacion_id
                AND estado_de_la_prestacion_id NOT IN (
                  SELECT id FROM estados_de_las_prestaciones WHERE codigo IN ('U', 'S')
                )
                AND pb.id <> OLD.id
              INTO duplicada;
          END IF;

          IF duplicada THEN
            RAISE EXCEPTION 'El % falló debido a que duplicaría una prestación ya registrada (clave: ''%'', fecha: ''%'', prestacion: ''%'')',
              TG_OP, NEW.clave_de_beneficiario, NEW.fecha_de_la_prestacion, NEW.prestacion_id;
            RETURN NULL;
          END IF;

          -- No se encontraron duplicados, se puede proceder a la inserción o actualización
          RETURN NEW;
        END;
      $$ LANGUAGE plpgsql;
    "

    UnidadDeAltaDeDatos.find(:all).each do |uad|
      if uad.facturacion
        ActiveRecord::Base.connection.schema_search_path = "uad_#{uad.codigo}, public"
        create_table :metodos_de_validacion_fallados, :id => false do |t|
          t.references :prestacion_brindada
          t.references :metodo_de_validacion
        end

        add_index(:metodos_de_validacion_fallados, [:prestacion_brindada_id, :metodo_de_validacion_id],
          :unique => true, :name => "unq_metodo_de_validacion_fallado")

        execute "
          ALTER TABLE ONLY uad_#{uad.codigo}.metodos_de_validacion_fallados
            ADD CONSTRAINT fk_uad_#{uad.codigo}_mm_vv_pp_bb_prestaciones_brindadas
            FOREIGN KEY (prestacion_brindada_id) REFERENCES prestaciones_brindadas (id);
          ALTER TABLE ONLY uad_#{uad.codigo}.metodos_de_validacion_fallados
            ADD CONSTRAINT fk_uad_#{uad.codigo}_mm_vv_pp_bb_metodos_de_validacion
            FOREIGN KEY (metodo_de_validacion_id) REFERENCES public.metodos_de_validacion (id);
        "

        # Marcar como anuladas las prestaciones que puedan haberse duplicado debido a la falta de validaciones
        execute "
          UPDATE prestaciones_brindadas pb1 SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!("S")}
            WHERE EXISTS (
              SELECT * FROM prestaciones_brindadas pb2
                WHERE
                  pb1.clave_de_beneficiario = pb2.clave_de_beneficiario
                  AND pb1.fecha_de_la_prestacion = pb2.fecha_de_la_prestacion
                  AND pb1.prestacion_id = pb2.prestacion_id
                  AND pb1.id > pb2.id
            );
        "

        # Crear el trigger de validación para que no vuelvan a duplicarse prestaciones
        execute "
          CREATE TRIGGER trg_uad_#{uad.codigo}_antes_de_cambiar_prestacion_brindada
            BEFORE INSERT OR UPDATE ON prestaciones_brindadas
            FOR EACH ROW EXECUTE PROCEDURE verificar_duplicacion_de_prestaciones();
        "

        PrestacionBrindada.where(:estado_de_la_prestacion_id => EstadoDeLaPrestacion.where(:codigo => %w(I F R)).collect{|e| e.id}).each do |p|
          if p.actualizar_metodos_de_validacion_fallados
            p.estado_de_la_prestacion_id = 2
          else
            p.estado_de_la_prestacion_id = 3
          end
          p.save
        end

      end
    end

    ActiveRecord::Base.connection.schema_search_path = "public"
  end
end
