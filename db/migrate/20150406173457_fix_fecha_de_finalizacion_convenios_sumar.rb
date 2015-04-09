class FixFechaDeFinalizacionConveniosSumar < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.exec_query <<-SQL
      UPDATE convenios_de_administracion_sumar
      SET fecha_de_finalizacion = NULL;

      UPDATE convenios_de_gestion_sumar
      SET fecha_de_finalizacion = NULL;
    SQL
  end

end
