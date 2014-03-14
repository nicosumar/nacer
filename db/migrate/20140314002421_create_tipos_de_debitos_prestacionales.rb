class CreateTiposDeDebitosPrestacionales < ActiveRecord::Migration
  def up
    create_table :tipos_de_debitos_prestacionales do |t|
      t.string :nombre
    end
  end

  def down
  	drop_table :tipos_de_debitos_prestacionales
  end
end
