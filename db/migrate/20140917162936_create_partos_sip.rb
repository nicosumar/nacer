class CreatePartosSip < ActiveRecord::Migration
  def change
    create_table :partos_sip do |t|
      t.references :efector, :null => false
      t.string :id01, :null => false, :unique => true
      t.string :nombre
      t.string :apellido
      t.string :numero_de_documento
      t.date :fecha_de_terminacion
      t.integer :edad_materna
      t.integer :gestas_previas
      t.string :embarazo_planeado, :limit => 1
      t.string :fracaso_de_mac, :limit => 1
      t.string :chagas, :limit => 1
      t.string :sifilis_antes_20_semanas, :limit => 1
      t.string :sifilis_despues_20_semanas, :limit => 1
      t.integer :consultas_prenatales
      t.string :corticoides_antenatales, :limit => 1
      t.integer :edad_gestacional_al_parto
      t.string :nacimiento, :limit => 1
      t.string :terminacion, :limit => 1
      t.string :ocitocicos_prealumbramiento, :limit => 1
      t.integer :peso_al_nacer
      t.string :egreso_del_rn, :limit => 1
      t.string :anticoncepcion_consejeria, :limit => 1
      t.string :anticoncepcion_mac, :limit => 1
      t.string :att_actual, :limit => 1
      t.integer :att_1a_dosis
      t.integer :att_2a_dosis
      t.string :nivel_educativo, :limit => 1
      t.integer :apgar_1
      t.integer :apgar_5
    end
    add_index :partos_sip, :efector_id
    add_index :partos_sip, :id01
  end
end
