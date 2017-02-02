class CreatePrestacionesLiquidadasDatos < ActiveRecord::Migration
  def change
    create_table :prestaciones_liquidadas_datos do |t|
      t.references :liquidacion
      t.integer :prestacion_liquidada_id
      t.string :dato_reportable_nombre
      t.column :precio_por_unidad, "numeric(15,4)"
      t.column :valor_integer, "integer"
      t.column :valor_big_decimal, "numeric(15,4)"
      t.date :valor_date
      t.string :valor_string
      t.column :adicional_por_prestacion, "numeric(15,4)"
      t.references :dato_reportable
      t.references :dato_reportable_requerido

      t.timestamps
    end
    add_index :prestaciones_liquidadas_datos, :liquidacion_id, name: 'indice_liquidacion_sumar_idx'

  end
end
