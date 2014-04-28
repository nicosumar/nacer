class CreateTiposDeNotasDebito < ActiveRecord::Migration
  def up
    create_table :tipos_de_notas_debito do |t|
      t.string :nombre
      t.column :codigo, "char(3)"
      t.text :nombre_de_secuencia
      t.text :mascara

      t.timestamps
    end

    execute <<-SQL
      CREATE SEQUENCE "public"."notas_de_debito_numero_seq"
        INCREMENT 1
        MINVALUE 1
        START 1;

      ALTER TABLE "public"."notas_de_debito_numero_seq" OWNER TO "nacer_adm";
    SQL



    TipoDeNotaDebito.create([
      { #ID: 1
      	codigo: "DP",
        nombre: "Nota de debito prestacional",
        nombre_de_secuencia: "notas_de_debito_numero_seq",
        mascara: "00000000"
      },
      { #ID: 2
      	codigo: "M",
        nombre: "Multa formal",
        nombre_de_secuencia: "notas_de_debito_numero_seq",
        mascara: "00000000"
      }]
    )

  end

  def down
  	drop_table :tipos_de_notas_debito

    execute <<-SQL
      DROP SEQUENCE "public"."notas_de_debito_numero_seq";
    SQL
  end
end
