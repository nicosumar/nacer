class CreateDiscapacidades < ActiveRecord::Migration
  def change
    create_table :discapacidades do |t|
      t.string :nombre
      t.string :codigo_para_gestion
    end
  end
end
