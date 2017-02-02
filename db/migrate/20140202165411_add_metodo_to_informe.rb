class AddMetodoToInforme < ActiveRecord::Migration
  def up
  	execute <<-SQL
	  	ALTER TABLE "public"."informes"
		ADD COLUMN "metodo" varchar(255);
    SQL
  end

  def down
  	execute <<-SQL
	  	ALTER TABLE "public"."informes"
		DROP COLUMN "metodo";
    SQL
  end
end
