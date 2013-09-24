class AddDatosAEfectores < ActiveRecord::Migration
  def up
  	add_column :efectores, :cuit, :string
  	add_column :efectores, :condicion_iva, :string
  	add_column :efectores, :fecha_inicio_de_actividades, :date
  	add_column :efectores, :condicion_iibb, :string
  	add_column :efectores, :datos_bancarios, :string
  end

  def down
  	remove_column :efectores, :cuit
  	remove_column :efectores, :condicion_iva
  	remove_column :efectores, :fecha_inicio_de_actividades
  	remove_column :efectores, :condicion_iibb
  	remove_column :efectores, :datos_bancarios

  end
end
