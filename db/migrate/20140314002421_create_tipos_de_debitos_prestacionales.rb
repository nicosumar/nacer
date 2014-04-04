# -*- encoding : utf-8 -*-
class CreateTiposDeDebitosPrestacionales < ActiveRecord::Migration
  def up
    create_table :tipos_de_debitos_prestacionales do |t|
      t.string :nombre
    end

    add_column :detalles_de_debitos_prestacionales, :tipo_de_debito_prestacional_id, "int4"

    execute <<-SQL
      ALTER TABLE "public"."detalles_de_debitos_prestacionales"
        ADD FOREIGN KEY ("tipo_de_debito_prestacional_id") 
          REFERENCES "public"."tipos_de_debitos_prestacionales" ("id") 
          ON DELETE RESTRICT ON UPDATE NO ACTION;

        CREATE INDEX  ON "public"."detalles_de_debitos_prestacionales" ("tipo_de_debito_prestacional_id"  );
    SQL

    TipoDeDebitoPrestacional.create([
      { #ID: 1
        nombre: "Auditoría Concurrente Externa"
      },
      { #ID: 2
        nombre: "Auditoría Interna - Posterior al pago"
      }]
    )
    MotivoDeRechazo.create([
      { #ID: 16
        nombre: "La prestación no está autorizada para este efector.",
        categoria: "Auditoría Interna - Posterior al pago"
      },
      { #ID: 17
        nombre: "El efector no posee la documentación correspondiente.",
        categoria: "Auditoría Interna - Posterior al pago"
      },
      { #ID: 18
        nombre: "Otros",
        categoria: "Auditoría Interna - Posterior al pago"
      },
      { #ID: 19
        nombre: "La prestación no está autorizada para este efector.",
        categoria: "Auditoría Concurrente Externa"
      },
      { #ID: 20
        nombre: "El efector no posee la documentación correspondiente.",
        categoria: "Auditoría Concurrente Externa"
      },
      { #ID: 21
        nombre: "Otros",
        categoria: "Auditoría Concurrente Externa"
      },
    ])
  end

  def down
    execute <<-SQL
      DROP INDEX "public"."detalles_de_debitos_prestacio_tipo_de_debito_prestacional_i_idx";
      ALTER TABLE "public"."detalles_de_debitos_prestacionales"
        DROP CONSTRAINT "detalles_de_debitos_prestacio_tipo_de_debito_prestacional__fkey",
        DROP COLUMN "tipo_de_debito_prestacional_id";
    SQL

    execute <<-SQL
      DELETE from motivos_de_rechazos
      where categoria = 'Auditoría Concurrente Externa'
      or categoria = 'Auditoría Interna - Posterior al pago'
    SQL
    
    drop_table :tipos_de_debitos_prestacionales

  end
end
