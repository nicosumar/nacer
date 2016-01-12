class CorregirTablasDePrestaciones < ActiveRecord::Migration
  def up
    # Hay un error en la definición de la prestación CTC012, emergencia hospitalaria en niños < 6 años
    # Tiene mal asignado el diagnóstico "S09" y falta el "R77"
    prestacion = Prestacion.find(482)
    prestacion.diagnosticos.destroy(Diagnostico.where(codigo: "S09").first)
    prestacion.diagnosticos << Diagnostico.where(codigo: "R77").first

    # Hay un error de asignación de sexo al diagnóstico "Muerte materna"
    diagnostico = Diagnostico.find(7)
    diagnostico.sexos.destroy(Sexo.where(codigo: "M").first)

    # Corregir el error en el cual el diagnóstico "P98" no quedó asociado a ninguna prestación activa,
    # porque parece ser que no tenía definido el grupo_de_diagnostico al momento de migrar las prestaciones
    # al PSS 2014
    # Uso las prestaciones asociadas al diagnóstico "P86"
    Prestacion.joins(:diagnosticos).where(diagnosticos: {id: 412}, activa: true).each do |prestacion|
      prestacion.diagnosticos << Diagnostico.where(codigo: "P98").first
    end
  end

  def down
    prestacion = Prestacion.find(482)
    prestacion.diagnosticos.destroy(Diagnostico.where(codigo: "R77").first)
    prestacion.diagnosticos << Diagnostico.where(codigo: "S09").first
    diagnostico = Diagnostico.find(7)
    diagnostico.sexos << Sexo.where(codigo: "M").first
    Prestacion.joins(:diagnosticos).where(diagnosticos: {id: 412}, activa: true).each do |prestacion|
      prestacion.diagnosticos.destroy(Diagnostico.where(codigo: "P98").first)
    end
  end
end
