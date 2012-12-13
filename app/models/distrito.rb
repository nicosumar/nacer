# -*- encoding : utf-8 -*-
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
      logger.warn "ADVERTENCIA: No se encontró el distrito '#{nombre_distrito.strip}' en el departamento '#{nombre_departamento.strip}'."
      return nil
    end
  end

  # ordenados_por_frecuencia
  # Devuelve un vector con los elementos de la tabla asociada ordenados de acuerdo con la frecuencia
  # de uso del ID del elemento en la columna de la tabla pasados como parámetros
  def self.ordenados_por_frecuencia(tabla, columna, departamento_id)
    Distrito.find_by_sql("
      SELECT distritos.id, distritos.nombre, count(distritos.id) AS \"frecuencia\"
        FROM
          distritos
          LEFT JOIN #{tabla.to_s}
            ON (distritos.id = #{tabla.to_s}.#{columna.to_s})
        WHERE departamento_id = '#{departamento_id}'
        GROUP BY distritos.id, distritos.nombre
        ORDER BY \"frecuencia\" DESC, distritos.nombre ASC;
    ")
  end

end
