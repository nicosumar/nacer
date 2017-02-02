# -*- encoding : utf-8 -*-
class CreateContactos < ActiveRecord::Migration
  def change
    create_table :contactos do |t|
      t.string :nombres
      t.string :apellidos
      t.string :mostrado, :null => false
      t.string :dni
      t.text :domicilio
      t.string :email
      t.string :email_adicional
      t.string :telefono
      t.string :telefono_movil
      t.text :observaciones
      t.timestamps
    end
  end
end
