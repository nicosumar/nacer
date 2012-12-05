class UnidadDeAltaDeDatos < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :codigo, :nombre, :inscripcion, :facturacion, :activa, :observaciones

  # Los atributos siguientes solo pueden asignarse durante la creación
  attr_readonly :codigo

  # Asociaciones
  has_and_belongs_to_many :centros_de_inscripcion
  has_many :unidades_de_alta_de_datos_users
  has_many :users, :through => :unidades_de_alta_de_datos_users

  # En forma predeterminada, sólo se devuelven los registros activos
  default_scope where(:activa => true)

  # Validaciones
  validates_presence_of :nombre, :codigo
  validates_uniqueness_of :codigo
  validates_length_of :codigo, :is => 3

  #
  # schema
  # Devuelve el esquema de la base de datos asociado con esta UAD
  def schema
    'uad_' + codigo
  end

  #
  # self.id_del_codigo
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

  #
  # self.actual
  # Devuelve la UnidadDeAltaDeDatos con la que se está trabajando actualmente.
  def self.actual
    # Cada UAD trabaja con un 'schema_search_path' distinto, por lo que usamos ese dato para ver
    # cuál UAD está seleccionada actualmente
    UnidadDeAltaDeDatos.find_by_codigo(ActiveRecord::Base.connection.schema_search_path.split(',')[0].chomp.split('_')[1])
  end

end
