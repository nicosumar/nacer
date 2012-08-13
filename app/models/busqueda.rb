class Busqueda < ActiveRecord::Base
  # Listado de clases que se pueden buscar usando FTS
  @@clases_fts = [:afiliados, :contactos, :convenios_de_gestion, :convenios_de_administracion, :efectores]

  # Devuelve todos los registros coincidentes de la tabla de 'Busquedas' exceptuando datos de los afiliados
  def self.busqueda_fts(terminos, opciones = {})
    # Verificamos las opciones pasadas
    if opciones.size > 0
      case
        when opciones.has_key?(:solo)
          case
            when opciones[:solo].is_a?(Array)
              modelos_a_buscar = @@clases_fts - (@@clases_fts - opciones[:solo])
            when ocpiones[:solo].is_a?(Symbol)
              modelos_a_buscar = @@clases_fts - (@@clases_fts - [opciones[:solo]])
          end
        when opciones.has_key?(:excepto)
          case
            when opciones[:excepto].is_a?(Array)
              modelos_a_buscar = @@clases_fts - opciones[:excepto]
            when opciones[:excepto].is_a?(Symbol)
              modelos_a_buscar = @@clases_fts - [opciones[:excepto]]
          end
      end
    else
      modelos_a_buscar = @@clases_fts.dup
    end

    # Realizamos la búsqueda si quedaron uno o más modelos para buscar
    if modelos_a_buscar.size > 0
      # Construir la cadena de consulta FTS
      tsquery = self.texto_a_consulta_fts(terminos)

      # Crear la vista temporal con los resultados de la consulta
      connection.execute "
        CREATE OR REPLACE TEMPORARY VIEW resultados_de_la_busqueda AS
          SELECT row_number() OVER () AS orden, *
            FROM busquedas
            WHERE
              \'#{tsquery}\'::tsquery @@ vector_fts
              AND modelo_type IN (\'#{modelos_a_buscar.collect{ |m| m.to_s.singularize.camelize }.join("', '")}\')
            ORDER BY ts_rank(vector_fts, \'#{tsquery}\'::tsquery) DESC;
      "
    else
      # Si no quedaron modelos que buscar, modificar la vista para que no devuelva nada
      connection.execute "
        CREATE OR REPLACE TEMPORARY VIEW resultados_de_la_busqueda AS
          SELECT row_number() OVER () AS orden, *
            FROM busquedas
            WHERE false;
      "
    end

  end

private
  # Devuelve una cadena 'tsquery' válida para búsquedas de texto completo en PostgreSQL de acuerdo con los términos pasados
  def self.texto_a_consulta_fts(terminos)
    terminos_sql = sanitize_sql_for_conditions(['?', terminos])
    lexemas = connection.execute("SELECT lexemes FROM ts_debug('public.es_ar', #{terminos_sql});")
    tsquery = []
    lexemas.column_values(0).each do |l|
      if !l.blank? && l.to_s != "{}"
        tsquery << l.gsub(/\{/, "(").gsub(/,/, " | ").gsub(/\}/, ")")
      end
    end
    return tsquery.join(" & ")
  end

end
