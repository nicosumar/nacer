# -*- encoding : utf-8 -*-
class CreateRegistrosDePrestaciones < ActiveRecord::Migration
  def change
    create_table :registros_de_prestaciones do |t|
      t.date :fecha_de_prestacion
      t.string :apellido
      t.string :nombre
      t.references :clase_de_documento, :default => 1
      t.references :tipo_de_documento, :default => 1
      t.integer :numero_de_documento
      t.string :codigo_de_prestacion_informado
      t.references :prestacion
      t.integer :cantidad, :default => 1
      t.string :historia_clinica
      t.references :estado_de_la_prestacion
      t.references :motivo_de_rechazo
      t.references :cuasi_factura
      t.references :nomenclador
      t.references :afiliado
      t.text :observaciones

      t.timestamps
    end
  end
end
