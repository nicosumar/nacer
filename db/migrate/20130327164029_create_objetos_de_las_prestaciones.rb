class CreateObjetosDeLasPrestaciones < ActiveRecord::Migration
  def change
    create_table :objetos_de_las_prestaciones do |t|
      t.references :tipo_de_prestacion, :null => false
      t.string :codigo, :null => false, :unique => true
      t.string :nombre, :null => false
      t.boolean :define_si_es_catastrofica, :default => true
      t.boolean :es_catastrofica, :default => false
    end
  end
end
