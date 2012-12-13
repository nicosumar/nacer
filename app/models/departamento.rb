# -*- encoding : utf-8 -*-
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
      logger.warn "ADVERTENCIA: No se pudo encontrar el departamento '#{nombre}'."
      return nil
    end
  end

  # ordenados_por_frecuencia
  # Devuelve un vector con los elementos de la tabla asociada ordenados de acuerdo con la frecuencia
  # de uso del ID del elemento en la columna de la tabla pasados como parámetros
  def self.ordenados_por_frecuencia(tabla, columna)
    Departamento.find_by_sql("
      SELECT departamentos.id, departamentos.nombre, count(departamentos.id) AS \"frecuencia\"
        FROM
          departamentos
          LEFT JOIN #{tabla.to_s}
            ON (departamentos.id = #{tabla.to_s}.#{columna.to_s})
        WHERE provincia_id = #{Parametro.valor_del_parametro(:id_de_esta_provincia)}
        GROUP BY departamentos.id, departamentos.nombre
        ORDER BY \"frecuencia\" DESC, departamentos.nombre ASC;
    ")
  end

end
