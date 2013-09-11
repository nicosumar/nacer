# -*- encoding : utf-8 -*-
class CreateMetodosDeValidacionPrestacionesBrindadasJoinTable < ActiveRecord::Migration
  def change

    # Convertimos las validaciones generales de prestaciones brindadas en objetos MetodoDeValidacion asociados
    # con todas las prestaciones
    metodo = MetodoDeValidacion.create!(
      :nombre => "Verificar que la prestación esté vigente",
      :metodo => "prestacion_vigente?",
      :mensaje => "La prestación se encuentra vencida, ya que tiene más de 120 días de antigüedad con respecto a hoy",
      :genera_error => false
    )
    metodo.prestaciones = Prestacion.where("objeto_de_la_prestacion_id IS NOT NULL")

    metodo = MetodoDeValidacion.create!(
      :nombre => "Verificar que la persona estuviera activa al momento de la prestación",
      :metodo => "beneficiario_activo?",
      :mensaje => "La persona a la que se le brindó la prestación no se encontraba activa para esa fecha.",
      :genera_error => false
    )
    metodo.prestaciones = Prestacion.where("objeto_de_la_prestacion_id IS NOT NULL")

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

    UnidadDeAltaDeDatos.find(:all).each do |uad|
      if uad.facturacion
        ActiveRecord::Base.connection.schema_search_path = "uad_#{uad.codigo}, public"
        create_table :metodos_de_validacion_prestaciones_brindadas, :id => false do |t|
          t.references :prestacion_brindada
          t.references :metodo_de_validacion
        end

        execute "
          ALTER TABLE ONLY uad_#{uad.codigo}.metodos_de_validacion_prestaciones_brindadas
            ADD CONSTRAINT fk_uad_#{uad.codigo}_mm_vv_pp_bb_prestaciones_brindadas
            FOREIGN KEY (prestacion_brindada_id) REFERENCES prestaciones_brindadas (id);
          ALTER TABLE ONLY uad_#{uad.codigo}.metodos_de_validacion_prestaciones_brindadas
            ADD CONSTRAINT fk_uad_#{uad.codigo}_mm_vv_pp_bb_metodos_de_validacion
            FOREIGN KEY (metodo_de_validacion_id) REFERENCES public.metodos_de_validacion (id);
        "
        #TODO:sacar el id 40 del lago.
        if uad.id == 2
          PrestacionBrindada.find(:all).each do |p|
            if p.actualizar_metodos_de_validacion_fallados
              p.estado_de_la_prestacion_id = 2
            else
              p.estado_de_la_prestacion_id = 3
            end
          end
        end
      end
    end
  end
end
