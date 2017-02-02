# -*- encoding : utf-8 -*-
class AddColumnEmailToConveniosDeAdministracionSumar < ActiveRecord::Migration
  def change
    add_column :convenios_de_administracion_sumar, :email, :string
  end
end
