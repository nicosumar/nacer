# -*- encoding : utf-8 -*-
class CreateEntidades < ActiveRecord::Migration
  def up
    create_table :entidades do |t|
      t.references :entidad, polymorphic: true
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE "public"."entidades"
        ADD UNIQUE ("entidad_id", "entidad_type");
    SQL

  end

  def down
    drop_table :entidades
  end
end
