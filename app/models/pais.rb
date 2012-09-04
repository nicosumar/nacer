class Pais < ActiveRecord::Base

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
