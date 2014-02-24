class CreateTiposDeExpedientes < ActiveRecord::Migration
  def up
    create_table :tipos_de_expedientes do |t|
      t.text :nombre
      t.text :codigo
      t.text :nombre_de_secuencia

      t.timestamps
    end

    TipoDeExpediente.create([
      { #:id => 1,
        :nombre => "Paquete Basico",
        :codigo => "S",
        :nombre_de_secuencia => "secuencia_expediente_paquete_basico" 
      },
      { #:id => 2,
        :nombre => "Cardiopatias",
        :codigo => "CCC",
        :nombre_de_secuencia => "secuencia_expediente_cardiopatias" 
      },
      { #:id => 3,
        :nombre => "Paquete Perinatal",
        :codigo => "PPAC",
        :nombre_de_secuencia => "secuencia_expediente_ppac" 
      }
    ])
  end

  def down
    drop_table :tipos_de_expedientes 

  end
end
