class AddVistaMigraPss < ActiveRecord::Migration
  def up
  	load 'db/sp/vista_migra_pss.rb'
  end
end
