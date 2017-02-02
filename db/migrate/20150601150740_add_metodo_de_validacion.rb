#encoding: utf-8
class AddMetodoDeValidacion < ActiveRecord::Migration
  def up
  	MetodoDeValidacion.create!(
      :nombre => "Verificar que la prestación no se brinde posterior al mes de vida",
      :metodo => "antes_del_mes?",
      :mensaje => "La prestacion debe brindarse antes del mes de vida",
      :genera_error => true
    )
  end
end
