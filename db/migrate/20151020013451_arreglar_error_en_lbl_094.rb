class ArreglarErrorEnLbl094 < ActiveRecord::Migration
  def up
    prestacion = Prestacion.find(868)
    prestacion.sexos << Sexo.find_by_codigo("M")
    prestacion.grupos_poblacionales << GrupoPoblacional.find_by_codigo("B")
    prestacion.diagnosticos << Diagnostico.where("grupo_de_diagnosticos_id = 19 AND codigo NOT ILIKE 'Z35%'")
  end
end
