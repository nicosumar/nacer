class CreateCentrosDeInscripcionUnidadesDeAltaDeDatosJoinTable < ActiveRecord::Migration
  def change
    create_table :centros_de_inscripcion_unidades_de_alta_de_datos, :id => false do |t|
      t.references :centro_de_inscripcion
      t.references :unidad_de_alta_de_datos
    end
  end
end
