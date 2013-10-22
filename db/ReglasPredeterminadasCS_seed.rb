# -*- encoding : utf-8 -*-
# Ejecutar dentro de una transacción para evitar dejar la base en un estado incongruente
ActiveRecord::Base.transaction do
  metodos_a_admitir = MetodoDeValidacion.where(:id => [1,12])

  efectores_seleccionados =
    Efector.where(grupo_de_efectores_liquidacion_id: [3,4] )

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
end
