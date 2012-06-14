class AddUserIdColumnsToTables < ActiveRecord::Migration
  def change
    add_column :addendas, :created_by, :integer
    add_column :addendas, :updated_by, :integer
    add_column :contactos, :created_by, :integer
    add_column :contactos, :updated_by, :integer
    add_column :convenios_de_administracion, :created_by, :integer
    add_column :convenios_de_administracion, :updated_by, :integer
    add_column :convenios_de_gestion, :created_by, :integer
    add_column :convenios_de_gestion, :updated_by, :integer
    add_column :cuasi_facturas, :created_by, :integer
    add_column :cuasi_facturas, :updated_by, :integer
    add_column :efectores, :created_by, :integer
    add_column :efectores, :updated_by, :integer
    add_column :liquidaciones, :created_by, :integer
    add_column :liquidaciones, :updated_by, :integer
    add_column :prestaciones_autorizadas, :created_by, :integer
    add_column :prestaciones_autorizadas, :updated_by, :integer
    add_column :referentes, :created_by, :integer
    add_column :referentes, :updated_by, :integer
    add_column :registros_de_datos_adicionales, :created_by, :integer
    add_column :registros_de_datos_adicionales, :updated_by, :integer
    add_column :registros_de_prestaciones, :created_by, :integer
    add_column :registros_de_prestaciones, :updated_by, :integer
    add_column :renglones_de_cuasi_facturas, :created_by, :integer
    add_column :renglones_de_cuasi_facturas, :updated_by, :integer
  end
end
