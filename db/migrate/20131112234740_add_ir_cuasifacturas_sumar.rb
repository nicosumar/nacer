class AddIrCuasifacturasSumar < ActiveRecord::Migration
  def up
    execute <<-SQL
    	ALTER TABLE "public"."liquidaciones_sumar_cuasifacturas"
  	  ADD UNIQUE ("liquidacion_sumar_id", "efector_id");
    SQL
  end

end
