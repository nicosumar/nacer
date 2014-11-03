class LoadPdssSeed < ActiveRecord::Migration
  def up
    load 'db/PDSS_seed.rb'
  end

  def down
  end
end
