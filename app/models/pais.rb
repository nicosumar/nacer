# -*- encoding : utf-8 -*-
class Pais < ActiveRecord::Base

  has_many :provincias
  
  # id_del_nombre
  # Devuelve el id asociado con el código pasado
  def self.id_del_nombre(nombre)
    if !nombre || nombre.strip.empty?
      return nil
    end

    # Buscar el nombre en la tabla y devolver su ID
    pais = self.where("UPPER(nombre) = ?", nombre.strip.mb_chars.upcase.to_s)
    if pais.size == 1
      return pais.first.id
    else
      return nil
    end
  end

  # ordenados_por_frecuencia
  # Devuelve un vector con los elementos de la tabla asociada ordenados de acuerdo con la frecuencia
  # de uso del ID del elemento en la columna de la tabla pasados como parámetros
  def self.ordenados_por_frecuencia(tabla, columna)
    Pais.find_by_sql("
      SELECT paises.id, paises.nombre, count(paises.id) AS \"frecuencia\"
        FROM
          paises
          LEFT JOIN #{tabla.to_s}
            ON (paises.id = #{tabla.to_s}.#{columna.to_s})
        GROUP BY paises.id, paises.nombre
        ORDER BY \"frecuencia\" DESC, paises.nombre ASC;
    ")
  end

end
