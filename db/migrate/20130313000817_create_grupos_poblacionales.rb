class CreateGruposPoblacionales < ActiveRecord::Migration
  def change
    create_table :grupos_poblacionales do |t|
      t.string :nombre
      t.string :codigo

      t.timestamps
    end
  end
end
