class AddUserIdColumnsToTables < ActiveRecord::Migration
  def change
    add_column :addendas, :creator_id, :integer
    add_column :addendas, :updater_id, :integer
    add_column :contactos, :creator_id, :integer
    add_column :contactos, :updater_id, :integer
    add_column :convenios_de_administracion, :creator_id, :integer
    add_column :convenios_de_administracion, :updater_id, :integer
    add_column :convenios_de_gestion, :creator_id, :integer
    add_column :convenios_de_gestion, :updater_id, :integer
    add_column :cuasi_facturas, :creator_id, :integer
    add_column :cuasi_facturas, :updater_id, :integer
    add_column :efectores, :creator_id, :integer
    add_column :efectores, :updater_id, :integer
    add_column :liquidaciones, :creator_id, :integer
    add_column :liquidaciones, :updater_id, :integer
    add_column :prestaciones_autorizadas, :creator_id, :integer
    add_column :prestaciones_autorizadas, :updater_id, :integer
    add_column :referentes, :creator_id, :integer
    add_column :referentes, :updater_id, :integer
    add_column :registros_de_datos_adicionales, :creator_id, :integer
    add_column :registros_de_datos_adicionales, :updater_id, :integer
    add_column :registros_de_prestaciones, :creator_id, :integer
    add_column :registros_de_prestaciones, :updater_id, :integer
    add_column :renglones_de_cuasi_facturas, :creator_id, :integer
    add_column :renglones_de_cuasi_facturas, :updater_id, :integer
  end
end
