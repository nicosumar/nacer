# -*- encoding : utf-8 -*-
# Ejecutar dentro de una transacción para evitar dejar la base en un estado incongruente
ActiveRecord::Base.transaction do
  hospitales =
    Efector.where(
      "nombre ILIKE '%hospital%' AND nombre NOT ILIKE '%micro%'"
    )

  programas =
    Efector.where(
      "nombre ILIKE '%casa%mujer%' OR nombre ILIKE '%centro%vacunatorio%central%'"
    )

  grupo = GrupoDeEfectoresLiquidacion.new({
    :grupo => "Hospitales",
    :descripcion => "Hospitales de referencia, regionales y departamentales"
  })
  grupo.efectores = hospitales
  grupo.save

  grupo = GrupoDeEfectoresLiquidacion.new({
    :grupo => "Programas",
    :descripcion => "Casa de la Mujer, Vacunatorio Central"
  })
  grupo.efectores = programas
  grupo.save

end
