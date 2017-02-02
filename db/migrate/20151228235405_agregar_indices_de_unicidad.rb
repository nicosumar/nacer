class AgregarIndicesDeUnicidad < ActiveRecord::Migration
  def up
    Prestacion.find(545).metodos_de_validacion.destroy(MetodoDeValidacion.find(15))
    Prestacion.find(545).metodos_de_validacion << MetodoDeValidacion.find(15)
    add_index :metodos_de_validacion, :metodo, unique: true
    add_index :metodos_de_validacion_prestaciones, [:metodo_de_validacion_id, :prestacion_id], unique: true,
      name: "idx_uniq_on_metodos_de_validacion_prestaciones_mmvv_pp"
  end

  def down
    remove_index :metodos_de_validacion, name: "index_metodos_de_validacion_on_metodo"
    remove_index :metodos_de_validacion_prestaciones, name: "idx_uniq_on_metodos_de_validacion_prestaciones_mmvv_pp"
  end
end
