# -*- encoding : utf-8 -*-
class CreateDatosReportablesRequeridos < ActiveRecord::Migration
  def change
    create_table :datos_reportables_requeridos do |t|
      # Asocia una prestación con un dato_reportable
      t.references :prestacion
      t.references :dato_reportable

      # Periodo de validez de esta asociación
      t.date :fecha_de_inicio
      t.date :fecha_de_finalizacion

      # Campos varios requeridos para validaciones
      t.boolean :necesario, :default => false                    # Los datos necesarios generan un error en el formulario si no se completan
      t.boolean :obligatorio, :default => false                  # Los datos obligatorios no completados hacen que el registro se considere incompleto
      t.decimal :minimo, :precision => 15, :scale => 4           # Valor mínimo (si existe) para datos numéricos
      t.decimal :maximo, :precision => 15, :scale => 4           # Valor máximo (si existe) para datos numéricos
    end
  end
end
