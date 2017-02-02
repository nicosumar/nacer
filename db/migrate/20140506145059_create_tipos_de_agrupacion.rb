class CreateTiposDeAgrupacion < ActiveRecord::Migration
  def up
    create_table :tipos_de_agrupacion do |t|

      t.string :nombre, null: false
      t.column :codigo, "char(3)", null: false

      t.timestamps
    end

    TipoDeAgrupacion.create([
      { #ID: 1
        nombre: "Efector Administrador/Hospital",
        codigo: "EAH"
      },
      { #ID: 2
        nombre: "Efector",
        codigo: "E"
      },
      { #ID: 3
        nombre: "Efector y Afiliado",
        codigo: "EA"
      },
      { #ID: 4
        nombre: "Solo Efectores Administradores",
        codigo: "SEA"
      }
    ])
  end

  def down
    drop_table :tipos_de_agrupacion
  end
end
