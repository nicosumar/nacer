class RenameColumnCodigoParaPrestacionesFromSiNo < ActiveRecord::Migration
  def change
    rename_column :si_no, :codigo_para_prestaciones, :codigo
  end
end
