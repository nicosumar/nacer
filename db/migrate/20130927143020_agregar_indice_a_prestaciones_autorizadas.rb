class AgregarIndiceAPrestacionesAutorizadas < ActiveRecord::Migration
  def up
    add_index(
      :prestaciones_autorizadas,
      [:autorizante_al_alta_type, :autorizante_al_alta_id, :prestacion_id ],
      :name => "index_prestaciones_autorizadas_unq",
      :unique => true)
  end

  def down
    remove_index :prestaciones_autorizadas, :name => "index_prestaciones_autorizadas_unq"
  end
end
