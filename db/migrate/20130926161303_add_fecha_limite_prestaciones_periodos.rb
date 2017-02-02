class AddFechaLimitePrestacionesPeriodos < ActiveRecord::Migration
  def up

  	add_column :periodos, :fecha_limite_prestaciones, :date

  	execute <<-SQL
  	update periodos
		SET
		fecha_limite_prestaciones = pl.utlimo_dia_habil
		from periodos p
			join liquidaciones_sumar ls on ls.periodo_id = p.id
			join parametros_liquidaciones_sumar pl on pl.id = ls.parametro_liquidacion_sumar_id
		where p.id = periodos.id

  	SQL
  	

  	remove_column :parametros_liquidaciones_sumar, :utlimo_dia_habil
  end

  def down
  	add_column :parametros_liquidaciones_sumar, :utlimo_dia_habil, :date
  	
  	execute <<-SQL
  	update parametros_liquidaciones_sumar
		SET
		utlimo_dia_habil = p.fecha_limite_prestaciones
		from periodos p
			join liquidaciones_sumar ls on ls.periodo_id = p.id
			join parametros_liquidaciones_sumar pl on pl.id = ls.parametro_liquidacion_sumar_id
		where ls.id = parametros_liquidaciones_sumar.id
  	SQL

  	remove_column :periodos, :fecha_limite_prestaciones
  end
end
