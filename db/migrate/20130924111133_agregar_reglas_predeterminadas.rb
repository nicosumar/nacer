class AgregarReglasPredeterminadas < ActiveRecord::Migration
  def up
    load 'db/ReglasPredeterminadas_seed.rb'
  end

  def down
    PlantillaDeReglas.delete_all
    Regla.delete_all
  end
end
