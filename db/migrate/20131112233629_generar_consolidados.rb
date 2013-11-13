class GenerarConsolidados < ActiveRecord::Migration
  def up
  	# Generlo los consolidados para los efectores que ya han sido liquidados
    LiquidacionSumar.all.each do |l|
      l.generar_consolidados
    end
  end

  def down
  	execute <<-SQL
  		DELETE FROM consolidados_sumar_detalles;
  		DELETE FROM consolidados_sumar;
  	SQL
  end
end
