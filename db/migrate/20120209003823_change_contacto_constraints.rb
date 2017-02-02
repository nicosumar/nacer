# -*- encoding : utf-8 -*-
class ChangeContactoConstraints < ActiveRecord::Migration
  def up
    execute "
      ALTER TABLE contactos
        ALTER COLUMN apellidos DROP NOT NULL;
    "
    execute "
      ALTER TABLE contactos
        ALTER COLUMN nombres DROP NOT NULL;
    "
  end

  def down
    execute "
      ALTER TABLE contactos
        ALTER COLUMN apellidos SET NOT NULL;
    "
    execute "
      ALTER TABLE contactos
        ALTER COLUMN nombres SET NOT NULL;
    "
  end
end
