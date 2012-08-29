class Distrito < ActiveRecord::Base
  belongs_to :departamento

  validates_presence_of :nombre, :departamento_id, :alias_id

  def nombre_corto
    if nombre.length > 80 then
      nombre.first(77) + "..."
    else
      nombre
    end
  end

  # Devuelve el id asociado con el nombre de distrito pasado, para el departamento indicado
  def self.id_del_nombre(nombre_departamento, nombre_distrito)
    if !nombre_departamento || !nombre_distrito ||
       nombre_departamento.strip.empty? || nombre_distrito.strip.empty?
      return nil
    end

    # Buscar el nombre en la tabla y devolver su ID (si existe)
    distrito = self.where("departamento_id = ? AND nombre ILIKE ?",
      Departamento.id_del_nombre(nombre_departamento), nombre_distrito.strip)
    if distrito.size == 1
      return distrito.first.id
    else
      return nil
    end
  end

end
