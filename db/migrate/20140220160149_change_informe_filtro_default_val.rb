class ChangeInformeFiltroDefaultVal < ActiveRecord::Migration
  def up
  	execute <<-SQL
      ALTER TABLE "public"."informes_filtros"
        ALTER COLUMN "valor_por_defecto" TYPE text;
  	SQL
  end

  def down
  	execute <<-SQL
      ALTER TABLE "public"."informes_filtros"
        ALTER COLUMN "valor_por_defecto" TYPE varchar(255);
  	SQL
  end
end
