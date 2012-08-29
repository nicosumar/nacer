class Departamento < ActiveRecord::Base
  belongs_to :provincia
  has_many :distritos

  validates_presence_of :nombre, :provincia_id

  def nombre_corto
    if nombre.length > 80 then
      nombre.first(77) + "..."
    else
      nombre
    end
  end

  def self.de_esta_provincia
    Departamento.where(:provincia_id => Parametro.valor_del_parametro(:id_de_esta_provincia))
  end

  # Devuelve el id asociado con el nombre pasado
  def self.id_del_nombre(nombre)
    if !nombre || nombre.strip.empty?
      return nil
    end

    # Buscar el nombre en la tabla y devolver su ID (si existe)
    departamento = self.where("nombre ILIKE ? AND provincia_id = ?",
      nombre.strip, Parametro.valor_del_parametro(:id_de_esta_provincia))
    if departamento.size == 1
      return departamento.first.id
    else
      return nil
    end
  end

end
