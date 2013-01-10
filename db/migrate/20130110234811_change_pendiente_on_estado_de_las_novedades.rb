class ChangePendienteOnEstadoDeLasNovedades < ActiveRecord::Migration
  def up
    execute "UPDATE estados_de_las_novedades SET pendiente = 'f' WHERE codigo = 'P';"
  end
end
