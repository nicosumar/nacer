class CreateGruposDeEfectoresLiquidaciones < ActiveRecord::Migration
  def self.up
    create_table :grupos_de_efectores_liquidaciones do |t|
      t.string :grupo
      t.string :descripcion

      t.timestamps
    end

    change_table :efectores do |t|
      t.references :grupo_de_efectores_liquidacion, index: true
    end

    change_table :liquidaciones_sumar do |t|
      t.references :grupo_de_efectores_liquidacion, index: true 
    end

  end

  def self.down
    remove_column :efectores, :grupo_de_efectores_liquidacion_id
    remove_column :liquidaciones_sumar, :grupo_de_efectores_liquidacion_id

    drop_table :grupos_de_efectores_liquidaciones

    
  end
end
