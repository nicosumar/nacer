class CreateTiposDeExpedientes < ActiveRecord::Migration
  def up
    create_table :tipos_de_expedientes do |t|
      t.text :nombre
      t.text :codigo
      t.text :nombre_de_secuencia
      t.text :mascara

      t.timestamps
    end

    TipoDeExpediente.create([
      { #:id => 1,
        :nombre => "Paquete Basico",
        :codigo => "S/",
        :nombre_de_secuencia => "secuencia_expediente_paquete_basico",
        :mascara => "00000000"
      },
      { #:id => 2,
        :nombre => "Cardiopatias",
        :codigo => "CCC-",
        :nombre_de_secuencia => "secuencia_expediente_cardiopatias",
        :mascara => "00000"
      },
      { #:id => 3,
        :nombre => "Paquete Perinatal",
        :codigo => "PPAC-",
        :nombre_de_secuencia => "secuencia_expediente_ppac",
        :mascara => "00000"
      }
    ])

    execute <<-SQL
      CREATE SEQUENCE "public"."secuencia_expediente_paquete_basico"
       INCREMENT 1
       START 256;
      CREATE SEQUENCE "public"."secuencia_expediente_cardiopatias"
       INCREMENT 1;
      CREATE SEQUENCE "public"."secuencia_expediente_ppac"
       INCREMENT 1;
      
      ALTER TABLE "public"."secuencia_expediente_paquete_basico" OWNER TO "nacer_adm";
      ALTER TABLE "public"."secuencia_expediente_cardiopatias" OWNER TO "nacer_adm";
      ALTER TABLE "public"."secuencia_expediente_ppac" OWNER TO "nacer_adm";

    SQL
  end

  def down
    drop_table :tipos_de_expedientes 

  end
end
