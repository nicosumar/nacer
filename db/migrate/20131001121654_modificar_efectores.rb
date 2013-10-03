# -*- encoding : utf-8 -*-
class ModificarEfectores < ActiveRecord::Migration
  def up
    add_column :efectores, :banco_cuenta_principal, :string
    add_column :efectores, :numero_de_cuenta_principal, :string
    add_column :efectores, :denominacion_cuenta_principal, :string
    add_column :efectores, :sucursal_cuenta_principal, :string
    add_column :efectores, :banco_cuenta_secundaria, :string
    add_column :efectores, :numero_de_cuenta_secundaria, :string
    add_column :efectores, :denominacion_cuenta_secundaria, :string
    add_column :efectores, :sucursal_cuenta_secundaria, :string
  end

  def down
    remove_column :efectores, :banco_cuenta_principal
    remove_column :efectores, :numero_de_cuenta_principal
    remove_column :efectores, :denominacion_cuenta_principal
    remove_column :efectores, :sucursal_cuenta_principal
    remove_column :efectores, :banco_cuenta_secundaria
    remove_column :efectores, :numero_de_cuenta_secundaria
    remove_column :efectores, :denominacion_cuenta_secundaria
    remove_column :efectores, :sucursal_cuenta_secundaria
  end
end
