# -*- encoding : utf-8 -*-
class UpdateCodigoFromPrestaciones < ActiveRecord::Migration

  def up
    execute "
      UPDATE prestaciones SET codigo = replace(codigo, ' ', '');
    "
  end

end
