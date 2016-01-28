class CreateTratamientosInstauradosCu < ActiveRecord::Migration
  def up
    create_table :tratamientos_instaurados_cu do |t|
      t.string :nombre
      t.string :codigo
      t.integer :codigo_sirge
    end

    TratamientoInstauradoCu.create!([
        {
          #id: 1,
          nombre: "Cono o Leep",
          codigo: "C",
          codigo_sirge: 1
        },
        {
          #id: 2,
          nombre: "Cirugía",
          codigo: "Q",
          codigo_sirge: 2
        },
        {
          #id: 3,
          nombre: "Radioterapia",
          codigo: "R",
          codigo_sirge: 3
        }
      ])
  end

  def down
    drop_table :tratamientos_instaurados_cu
  end
end
