class ModifyFkeyConstraintOnPrestacionesLiquidadas < ActiveRecord::Migration
  def up
    execute "
      ALTER TABLE prestaciones_liquidadas DROP CONSTRAINT prestaciones_liquidadas_liquidacion_id_fkey;
      ALTER TABLE prestaciones_liquidadas ADD CONSTRAINT prestaciones_liquidadas_liquidacion_id_fkey
        FOREIGN KEY (liquidacion_id) REFERENCES liquidaciones_sumar (id);
    "
  end
end
