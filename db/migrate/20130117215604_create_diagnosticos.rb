class CreateDiagnosticos < ActiveRecord::Migration
  def change
    create_table :diagnosticos do |t|
      t.string :nombre
      t.string :codigo
    end
  end
end
