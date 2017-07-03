# -*- encoding : utf-8 -*-
class CargaDatosDeEntidades < ActiveRecord::Migration
  def up
    load 'db/entidades_seed.rb'
  end
end
