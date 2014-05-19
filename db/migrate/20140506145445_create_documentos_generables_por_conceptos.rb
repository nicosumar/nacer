class CreateDocumentosGenerablesPorConceptos < ActiveRecord::Migration
  def up
    create_table :documentos_generables_por_conceptos do |t|
      t.references :concepto_de_facturacion, null: false
      t.references :documento_generable, null: false
      t.references :tipo_de_agrupacion, null: false
      t.string :report_layout
      t.boolean :genera_numeracion, null: false, default: false
      t.string  :funcion_de_numeracion

      t.timestamps
    end
    execute <<-SQL
      ALTER TABLE "public"."documentos_generables_por_conceptos"
        ADD FOREIGN KEY ("concepto_de_facturacion_id") REFERENCES "public"."conceptos_de_facturacion" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD FOREIGN KEY ("documento_generable_id") REFERENCES "public"."documentos_generables" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD FOREIGN KEY ("tipo_de_agrupacion_id") REFERENCES "public"."tipos_de_agrupacion" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
        ADD UNIQUE ("concepto_de_facturacion_id", "documento_generable_id");


      CREATE INDEX  ON "public"."documentos_generables_por_conceptos" ("concepto_de_facturacion_id"  );
      CREATE INDEX  ON "public"."documentos_generables_por_conceptos" ("documento_generable_id"  );
      CREATE INDEX  ON "public"."documentos_generables_por_conceptos" ("tipo_de_agrupacion_id"  );
    SQL

    concepto_id =  ConceptoDeFacturacion.find(1).id
    agrupacion_efector = TipoDeAgrupacion.find(2).id
    agrupacion_efector_administrador = TipoDeAgrupacion.find(1).id
    
    documento_cuasi_id = DocumentoGenerable.find(1).id
    documento_consolidado_id = DocumentoGenerable.find(2).id
    documento_expediente_id = DocumentoGenerable.find(3).id
    documento_informe_id = DocumentoGenerable.find(4).id

    DocumentoGenerablePorConcepto.create([
      { #ID: 1
        concepto_de_facturacion_id: concepto_id,
        documento_generable_id: documento_cuasi_id,
        tipo_de_agrupacion_id: agrupacion_efector,
        report_layout: "cuasifactura_bas",
        genera_numeracion: true,
        funcion_de_numeracion: "generar_numero_cuasifactura"
      },
      { #ID: 2
        concepto_de_facturacion_id: concepto_id,
        documento_generable_id: documento_consolidado_id,
        tipo_de_agrupacion_id: agrupacion_efector,
        report_layout: "consolidado_bas",
        genera_numeracion: true,
        funcion_de_numeracion: "generar_numero_consolidado"
      },
      { #ID: 3
        concepto_de_facturacion_id: concepto_id,
        documento_generable_id: documento_expediente_id,
        tipo_de_agrupacion_id: agrupacion_efector_administrador,
        report_layout: "expediente_sumar_bas",
        genera_numeracion: true,
        funcion_de_numeracion: "generar_numero_de_expediente"
      },
      { #ID: 4
        concepto_de_facturacion_id: concepto_id,
        documento_generable_id: documento_informe_id,
        tipo_de_agrupacion_id: agrupacion_efector,
        report_layout: nil,
        genera_numeracion: false,
        funcion_de_numeracion: ""
      }
    ])

  end

  def down
    execute <<-SQL
      ALTER TABLE "public"."documentos_generables_por_conceptos"
        DROP CONSTRAINT "documentos_generables_por_conceptos_tipo_de_agrupacion_id_fkey",
        DROP CONSTRAINT "documentos_generables_por_conceptos_documento_generable_id_fkey",
        DROP CONSTRAINT "documentos_generables_por_conce_concepto_de_facturacion_id_fkey";

        DROP INDEX "public"."documentos_generables_por_concep_concepto_de_facturacion_id_idx";
        DROP INDEX "public"."documentos_generables_por_conceptos_documento_generable_id_idx";
        DROP INDEX "public"."documentos_generables_por_conceptos_tipo_de_agrupacion_id_idx";
    SQL
    drop_table :documentos_generables_por_conceptos
  end
end
