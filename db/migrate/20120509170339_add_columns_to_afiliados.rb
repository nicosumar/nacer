# -*- encoding : utf-8 -*-
class AddColumnsToAfiliados < ActiveRecord::Migration
  def change
    add_column :afiliados, :e_mail, :string
    add_column :afiliados, :numero_de_celular, :string
    add_column :afiliados, :fecha_de_ultima_menstruacion, :date
    add_column :afiliados, :observaciones_generales, :string
    add_column :afiliados, :discapacidad, :string
  end
end
