class AlterColumnCuieFromEfectores < ActiveRecord::Migration
  def change
    execute "
      ALTER TABLE efectores
        ALTER COLUMN cuie DROP NOT NULL;
    "
  end
end
