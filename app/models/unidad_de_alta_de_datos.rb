class UnidadDeAltaDeDatos < ActiveRecord::Base

  # Asociaciones
  has_and_belongs_to_many :centros_de_inscripcion
  has_many :unidades_de_alta_de_datos_users
  has_many :users, :through => :unidades_de_alta_de_datos_users

  # En forma predeterminada, sólo se devuelven los registros activos
  default_scope where(:activa => true)

  # Devuelve el id asociado con el código pasado
  def self.id_del_codigo(codigo)
    if !codigo || codigo.strip.empty?
      return nil
    end

    # Buscar el código en la tabla y devolver su ID (si es un código nuevo existente)
    unidad_de_alta_de_datos = self.find_by_codigo(codigo.strip)

    if unidad_de_alta_de_datos
      return unidad_de_alta_de_datos.id
    else
      return nil
    end
  end

  # uad_actual
  # Devuelve la UnidadDeAltaDeDatos con la que se está trabajando actualmente.
  def self.actual
    # Cada UAD trabaja con un 'schema_search_path' distinto, por lo que usamos ese dato para ver
    # cuál UAD está seleccionada actualmente
    UnidadDeAltaDeDatos.find_by_schema_search_path(ActiveRecord::Base.connection.schema_search_path)
  end

end
