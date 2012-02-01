class Busqueda < ActiveRecord::Base

  def self.busqueda_fts(terminos)
    terminos_sql = sanitize_sql_for_conditions(['?', terminos])
    Busqueda.find_by_sql("
      SELECT * FROM busquedas
        WHERE plainto_tsquery('public.es_ar', #{terminos_sql}) @@ vector_fts
        ORDER BY ts_rank(vector_fts, plainto_tsquery('public.es_ar', #{terminos_sql})) DESC;")
  end

end
