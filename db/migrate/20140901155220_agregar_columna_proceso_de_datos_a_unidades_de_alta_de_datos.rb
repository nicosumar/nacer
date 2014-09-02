class AgregarColumnaProcesoDeDatosAUnidadesDeAltaDeDatos < ActiveRecord::Migration
  def change
    add_column :unidades_de_alta_de_datos, :proceso_de_datos, :boolean, :default => false
  end
end
