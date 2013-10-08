class CreateLiquidacionesSumarAnexosAdministrativos < ActiveRecord::Migration
  def change
    create_table :liquidaciones_sumar_anexos_administrativos do |t|
      t.estados_de_los_procesos :references
      t.fecha_de_inicio :date
      t.fecha_de_finalizacion :date

      t.timestamps
    end
  end
end
