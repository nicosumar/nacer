# -*- encoding : utf-8 -*-
# Ejecutar dentro de una transacción para evitar dejar la base en un estado incongruente
ActiveRecord::Base.transaction do
  metodos_a_admitir = MetodoDeValidacion.where(:id => [1,12])

  efectores_seleccionados =
    Efector.where(
      "nombre ILIKE '%hospital%' AND nombre NOT ILIKE '%micro%'
      OR nombre ILIKE '%casa%mujer%' OR nombre ILIKE '%centro%vacunatorio%central%'"
    )

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

  plantilla = PlantillaDeReglas.new({
    :nombre => "Plantilla predeterminada",
    :observaciones => "Plantilla para liquidación de agosto 2013 (hospitales, casa de la mujer y vacunatorio central)"
  })
  plantilla.reglas = Regla.find(:all)
  plantilla.save
end
