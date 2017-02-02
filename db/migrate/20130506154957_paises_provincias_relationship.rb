class PaisesProvinciasRelationship < ActiveRecord::Migration
  def self.up
    add_column("provincias", "pais_id", :integer, :default => 1)
    add_index("provincias","pais_id")
  end

  def self.down
    remove_index("provincias","pais_id")
    remove_column("provincias", "pais_id")
  end
end
