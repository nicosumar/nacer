# -*- encoding : utf-8 -*-
class AddObservacionesToAddenda < ActiveRecord::Migration
  def change
    add_column :addendas, :observaciones, :text
  end
end
