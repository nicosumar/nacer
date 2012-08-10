class CreateLenguasOriginarias < ActiveRecord::Migration
  def change
    create_table :lenguas_originarias do |t|
      t.string :nombre
    end
  end
end
