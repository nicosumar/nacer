class AddGestionableToOrganismosGubernamentales < ActiveRecord::Migration
  def up
    add_column :organismos_gubernamentales, :gestionable, :boolean, null: false, default: false

    execute <<-SQL
      UPDATE organismos_gubernamentales
      SET gestionable = 't'
      where id in (1,2)
    SQL
  end

  def down
    remove_column :organismos_gubernamentales, :gestionable
  end
end
