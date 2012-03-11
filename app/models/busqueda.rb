class Busqueda < ActiveRecord::Base

  # Devuelve todos los registros coincidentes de la tabla de 'Busquedas' exceptuando datos de los afiliados
  def self.busqueda_fts(terminos)
    tsquery = self.texto_a_consulta_fts(terminos)
    Busqueda.find_by_sql("
      SELECT * FROM busquedas
        WHERE '#{tsquery}'::tsquery @@ vector_fts
        AND modelo_type != 'Afiliado'
        ORDER BY ts_rank(vector_fts, '#{tsquery}'::tsquery) DESC;")
  end

  # Devuelve todos los registros coincidentes de la tabla de 'Afiliados'
  def self.busqueda_afiliados(terminos)
    tsquery = self.texto_a_consulta_fts(terminos)
    Busqueda.find_by_sql("
      SELECT * FROM busquedas
        WHERE '#{tsquery}'::tsquery @@ vector_fts
        AND modelo_type = 'Afiliado'
        ORDER BY ts_rank(vector_fts, '#{tsquery}'::tsquery) DESC;")
  end

private
  # Devuelve una cadena 'tsquery' válida para búsquedas de texto completo en PostgreSQL de acuerdo con los términos pasados
  def self.texto_a_consulta_fts(terminos)
    terminos_sql = sanitize_sql_for_conditions(['?', terminos])
    lexemas = connection.execute("SELECT lexemes FROM ts_debug('public.es_ar', #{terminos_sql});")
    tsquery = []
    lexemas.column_values(0).each do |l|
      if not l.blank?
        tsquery << l.gsub(/\{/, "(").gsub(/,/, " | ").gsub(/\}/, ")")
      end
    end
    return tsquery.join(" & ")
  end

end
