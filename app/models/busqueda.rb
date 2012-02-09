class Busqueda < ActiveRecord::Base

  def self.busqueda_fts(terminos)
    tsquery = self.texto_a_consulta_fts(terminos)
    Busqueda.find_by_sql("
      SELECT * FROM busquedas
        WHERE '#{tsquery}'::tsquery @@ vector_fts
        ORDER BY ts_rank(vector_fts, '#{tsquery}'::tsquery) DESC;")
  end

private
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
