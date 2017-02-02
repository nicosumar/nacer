# -*- encoding : utf-8 -*-
class AgregarMetodoDeValidacionDeUnAnioOMas < ActiveRecord::Migration

  def up
    metodo = MetodoDeValidacion.create!(
      {
        :nombre => "Verificar si el beneficiario o la beneficiaria tienen un año o más de vida",
        :metodo => "de_un_anio_o_mas?",
        :mensaje => "La prestación debería haberse brindado después de cumplido el primer año de vida.",
        :genera_error => true
      }
    )
    Prestacion.where(:nombre => "Consulta pediátrica de 1 a 5 años").first.metodos_de_validacion << metodo
    MetodoDeValidacion.where(:metodo => "menor_de_un_anio?").first.update_attributes!({:genera_error => true})
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
