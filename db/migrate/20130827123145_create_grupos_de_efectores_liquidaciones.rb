class CreateGruposDeEfectoresLiquidaciones < ActiveRecord::Migration
  def change
    create_table :grupos_de_efectores_liquidaciones do |t|
      t.string :grupo
      t.string :descripcion

      t.timestamps
    end

    change_table :efectores do |t|
      t.references :grupos_de_efectores_liquidaciones, index: true
    end

    change_table :liquidaciones_sumar do |t|
      t.references :grupos_de_efectores_liquidaciones, index: true
    end

  end
end
