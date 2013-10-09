class CreateLiquidacionesSumarAnexosAdministrativos < ActiveRecord::Migration
  def change
    create_table :liquidaciones_sumar_anexos_administrativos do |t|
      t.references :estados_de_los_procesos
      t.date :fecha_de_inicio
      t.date :fecha_de_finalizacion

      t.timestamps
    end
  end
end
