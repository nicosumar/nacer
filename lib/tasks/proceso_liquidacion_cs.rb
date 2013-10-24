#~~ encoding: utf-8 ~~
ActiveRecord::Base.transaction do

  # Crear los nuevos grupos de efectores de liquidación
  cs_provinciales_junio =
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE
          EXISTS (
            SELECT *
              FROM convenios_de_gestion_sumar
              WHERE
                efectores.id = convenios_de_gestion_sumar.efector_id
                AND fecha_de_inicio = '2013-06-01'
          )
          AND dependencia_administrativa_id = 1
          AND unidad_de_alta_de_datos_id IS NOT NULL;"
    )

  cs_municipales_junio =
    Efector.find_by_sql("
      SELECT *
        FROM efectores
        WHERE
          EXISTS (
            SELECT *
              FROM convenios_de_gestion_sumar
              WHERE
                efectores.id = convenios_de_gestion_sumar.efector_id
                AND fecha_de_inicio = '2013-06-01'
          )
          AND dependencia_administrativa_id = 2
          AND unidad_de_alta_de_datos_id IS NOT NULL;"
    )

  grupo = GrupoDeEfectoresLiquidacion.new({
    :grupo => "Centros de salud provinciales",
    :descripcion => "Centros de salud que dependen del Ministerio de Salud provincial"
  })
  grupo.efectores = cs_provinciales_junio
  grupo.save

  grupo = GrupoDeEfectoresLiquidacion.new({
    :grupo => "Centros de salud municipales",
    :descripcion => "Centros de salud que dependen de las direcciones municipales de salud"
  })
  grupo.efectores = cs_municipales_junio
  grupo.save


  # Modificar la plantilla de reglas para admitir los métodos con IDs 1 y 12 en los nuevos efectores a liquidar
  metodos_a_admitir = MetodoDeValidacion.where(:id => [1,12])

  efectores_seleccionados = cs_provinciales_junio + cs_municipales_junio

  nomenclador = Nomenclador.find_by_nombre("PDSS Sumar Agosto de 2012")

  efectores_seleccionados.each do |e|
    metodos_a_admitir.each do |m|
      m.prestaciones.each do |p|
        Regla.create!({
          :nombre => "Permitir '#{m.metodo}' para '#{p.codigo} (id: #{p.id})' en '#{e.nombre_corto}'",
          :permitir => true,
          :efector_id => e.id,
          :metodo_de_validacion_id => m.id,
          :nomenclador_id => nomenclador.id,
          :prestacion_id => p.id
        })
      end
    end
  end

  plantilla = PlantillaDeReglas.find(1)
  plantilla.reglas = Regla.find(:all)
  plantilla.save

  # Modificar la descripcion y añadir un nuevo estado de prestación para las prestaciones pagadas
  EstadoDeLaPrestacion.find_by_codigo('L').update_attributes({:nombre => 'Aprobada, pendiente de pago'})
  estado_pagada = EstadoDeLaPrestacion.create!({
    :nombre => "Pagada",
    :codigo => "G",
    :pendiente => false,
    :indexable => false
  })

  # Marcar las prestaciones liquidadas en el periodo 2013-08 como pagadas, excepto las bajas y devoluciones pasadas por
  # el área de facturación
  UnidadDeAltaDeDatos.where(:facturacion => true).each do |uad|
    ActiveRecord::Base.connection.execute "
      SET SEARCH_PATH TO uad_#{uad.codigo}, public;
      UPDATE prestaciones_brindadas SET estado_de_la_prestacion_id = #{estado_pagada.id}
        WHERE estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('L')};
    "
  end

  ActiveRecord::Base.connection.execute "
    SET SEARCH_PATH TO uad_025, public;
    UPDATE uad_025.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('Z')} WHERE id = 1708;
    UPDATE uad_025.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('Z')} WHERE id = 1153;
    UPDATE uad_025.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('Z')} WHERE id = 699;
    UPDATE uad_025.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 702;
    SET SEARCH_PATH TO uad_012, public;
    UPDATE uad_012.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 551;
    UPDATE uad_012.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 620;
    UPDATE uad_012.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 424;
    SET SEARCH_PATH TO uad_018, public;
    UPDATE uad_018.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 1394;
    UPDATE uad_018.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 1389;
    UPDATE uad_018.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 739;
    UPDATE uad_018.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 1393;
    UPDATE uad_018.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 742;
    UPDATE uad_018.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 1396;
    UPDATE uad_018.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 1400;
    UPDATE uad_018.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 743;
    SET SEARCH_PATH TO uad_027, public;
    UPDATE uad_027.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 1047;
    UPDATE uad_027.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 3410;
    UPDATE uad_027.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 3360;
    SET SEARCH_PATH TO uad_014, public;
    UPDATE uad_014.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 1614;
    SET SEARCH_PATH TO uad_010, public;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 631;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 230;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 638;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 630;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 632;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 653;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 642;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 641;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 639;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 634;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 633;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 644;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 643;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 635;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 228;
    UPDATE uad_010.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('V')} WHERE id = 636;
    SET SEARCH_PATH TO uad_008, public;
    UPDATE uad_008.prestaciones_brindadas SET estado_de_la_prestacion_id = #{EstadoDeLaPrestacion.id_del_codigo!('Z')} WHERE id = 1090;
  "

end
