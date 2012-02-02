class ChangeReferenteConstraints < ActiveRecord::Migration
  def up
    execute "
      UPDATE referentes
        SET fecha_de_inicio = '2007-01-01'
        WHERE fecha_de_inicio IS NULL;
    "
    execute "
      ALTER TABLE referentes
        ALTER COLUMN fecha_de_inicio SET NOT NULL;
    "
  end

  def down
    execute "
      ALTER TABLE referentes
        ALTER COLUMN fecha_de_inicio DROP NOT NULL;
    "
    execute "
      UPDATE referentes
        SET fecha_de_inicio = NULL
        WHERE fecha_de_inicio IS '2007-01-01';
    "
  end
end
