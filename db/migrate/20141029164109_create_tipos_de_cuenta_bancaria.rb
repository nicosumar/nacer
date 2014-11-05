class CreateTiposDeCuentaBancaria < ActiveRecord::Migration
  def up
    create_table :tipos_de_cuenta_bancaria do |t|
      t.string :nombre
      t.column :nombre_corto, "varchar(15)"
      t.column :codigo, "char(3)"

      t.timestamps
    end

    # ID: 1
    TipoDeCuentaBancaria.create({
      nombre: "Caja de Ahorro",
      nombre_corto: "Caja Ah\\",
      codigo: "CAH"
      }, :without_protection => true)

    # ID: 2
    TipoDeCuentaBancaria.create({
      nombre: "Cuenta Corriente",
      nombre_corto: "Cta. Cte.",
      codigo: "CCT"
      }, :without_protection => true)
  end

  def down
    drop_table :tipos_de_cuenta_bancaria
  end
end
