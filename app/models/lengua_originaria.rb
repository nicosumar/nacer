class LenguaOriginaria < ActiveRecord::Base

  # ordenados_por_frecuencia
  # Devuelve un vector con los elementos de la tabla asociada ordenados de acuerdo con la frecuencia
  # de uso del ID del elemento en la columna de la tabla pasados como parámetros
  def self.ordenados_por_frecuencia(tabla, columna)
    LenguaOriginaria.find_by_sql("
      SELECT lenguas_originarias.id, lenguas_originarias.nombre, count(lenguas_originarias.id) AS \"frecuencia\"
        FROM
          lenguas_originarias
          LEFT JOIN #{tabla.to_s}
            ON (lenguas_originarias.id = #{tabla.to_s}.#{columna.to_s})
        GROUP BY lenguas_originarias.id, lenguas_originarias.nombre
        ORDER BY \"frecuencia\" DESC, lenguas_originarias.nombre ASC;
    ")
  end

end
