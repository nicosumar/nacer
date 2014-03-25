# -*- encoding : utf-8 -*-
class HabilitacionDePracticasYLaboratorios < ActiveRecord::Migration
  def up
    # Precargamos ciertos datos útiles para no ejecutar tantas consultas a la base
    sexo_femenino = Sexo.find_by_codigo!("F")
    sexo_masculino = Sexo.find_by_codigo!("M")
    menores_de_6 = GrupoPoblacional.find_by_codigo!("A")
    de_6_a_9 = GrupoPoblacional.find_by_codigo!("B")
    adolescentes = GrupoPoblacional.find_by_codigo!("C")
    mujeres_20_a_64 = GrupoPoblacional.find_by_codigo!("D")

    # Obtener el nomenclador
    nomenclador_sumar = Nomenclador.find(5)

    # Área rural
    rural_id = AreaDePrestacion.id_del_codigo!("R")

    prestacion = Prestacion.where(:codigo => "PRP001").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [menores_de_6, de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")

    # Añado A97 a los códigos de ECG en menores de 6 años
    prestacion = Prestacion.where(:id => 483, :codigo => "PRP004").first
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")

    prestacion = Prestacion.where(:id => 621, :codigo => "PRP004").first
    prestacion.sexos << [sexo_femenino, sexo_masculino]
    prestacion.grupos_poblacionales << [de_6_a_9, adolescentes, mujeres_20_a_64]
    prestacion.diagnosticos << Diagnostico.find_by_codigo!("A97")

  end

  def down
  end
end
