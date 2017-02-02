class CrearFuncionCodigoDePrestacionConDiagnosticos < ActiveRecord::Migration
  def up
    load 'db/sp/function_codigo_de_prestacion_con_diagnosticos.rb'
  end

  def down
    execute <<-SQL
      DROP FUNCTION codigo_de_prestacion_con_diagnosticos(integer);
    SQL
  end
end
