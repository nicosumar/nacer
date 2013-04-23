# -*- encoding : utf-8 -*-
class CreatePeriodosDeEmbarazo < ActiveRecord::Migration
  def change
    create_table :periodos_de_embarazo do |t|
      t.references :afiliado
      t.date :fecha_de_inicio
      t.date :fecha_de_finalizacion
      t.date :fecha_de_la_ultima_menstruacion
      t.date :fecha_de_diagnostico_del_embarazo
      t.integer :semanas_de_embarazo
      t.date :fecha_probable_de_parto
      t.date :fecha_efectiva_de_parto
      t.references :unidad_de_alta_de_datos
      t.references :centro_de_inscripcion
      t.timestamps
    end
  end
end
