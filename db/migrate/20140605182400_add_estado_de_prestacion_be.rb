class AddEstadoDePrestacionBe < ActiveRecord::Migration
  def up
    EstadoDeLaPrestacion.create!({nombre: "Beneficiario Inactivo al momento de la liquidacion",
                                   codigo: "B",
                                   pendiente: true,
                                   indexable: true
                                   })
    execute <<-SQL
      update unidades_de_alta_de_datos
      set facturacion = facturacion
      where id = 2
    SQL
  end

  def down
  end
end
