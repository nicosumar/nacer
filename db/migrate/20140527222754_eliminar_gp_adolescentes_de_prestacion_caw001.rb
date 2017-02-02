class EliminarGpAdolescentesDePrestacionCaw001 < ActiveRecord::Migration
  def up
    Prestacion.find_by_codigo!("CAW001").grupos_poblacionales.delete(GrupoPoblacional.find_by_codigo!("C"))
  end

  def down
    Prestacion.find_by_codigo!("CAW001").grupos_poblacionales << [GrupoPoblacional.find_by_codigo!("C")]
  end
end
