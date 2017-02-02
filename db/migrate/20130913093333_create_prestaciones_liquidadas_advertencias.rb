class CreatePrestacionesLiquidadasAdvertencias < ActiveRecord::Migration
  def change
    create_table :prestaciones_liquidadas_advertencias do |t|
      t.references :liquidacion
      t.references :prestacion_liquidada
      t.references :metodo_de_validacion
      t.string :comprobacion
      t.string :mensaje

      t.timestamps
    end
    add_index :prestaciones_liquidadas_advertencias, :prestacion_liquidada_id, name: 'presta_liquida_adver_presta_id_idx'
    add_index :prestaciones_liquidadas_advertencias, :metodo_de_validacion_id, name: 'presta_liquida_adver_metodo_id_idx'
    add_index :prestaciones_liquidadas_advertencias, :liquidacion_id, name: 'presta_liquida_adver_liquidacion_id_idx'
  end
end
