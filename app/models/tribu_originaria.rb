class TribuOriginaria < ActiveRecord::Base

  # ordenados_por_frecuencia
  # Devuelve un vector con los elementos de la tabla asociada ordenados de acuerdo con la frecuencia
  # de uso del ID del elemento en la columna de la tabla pasados como parámetros
  def self.ordenados_por_frecuencia(tabla, columna)
    TribuOriginaria.find_by_sql("
      SELECT tribus_originarias.id, tribus_originarias.nombre, count(tribus_originarias.id) AS \"frecuencia\"
        FROM
          tribus_originarias
          LEFT JOIN #{tabla.to_s}
            ON (tribus_originarias.id = #{tabla.to_s}.#{columna.to_s})
        GROUP BY tribus_originarias.id, tribus_originarias.nombre
        ORDER BY \"frecuencia\" DESC, tribus_originarias.nombre ASC;
    ")
  end

end
