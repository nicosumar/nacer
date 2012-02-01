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
    Departamento.where(:provincia_id => Provincia.find_by_nombre("Mendoza").id)
  end
end
