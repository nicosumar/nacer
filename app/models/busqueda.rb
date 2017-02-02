# -*- encoding : utf-8 -*-
class Busqueda < ActiveRecord::Base
  # Listado de clases que se pueden buscar usando FTS
  @@clases_fts = [
    :afiliados, :novedades_de_los_afiliados, :contactos, :convenios_de_gestion, :convenios_de_administracion, :efectores,
    :users, :addendas, :prestaciones_brindadas, :convenios_de_gestion_sumar, :convenios_de_administracion_sumar
  ]

  # Devuelve todos los registros coincidentes de la tabla de 'Busquedas'
  def self.busqueda_fts(terminos, opciones = {})
    # Verificamos las opciones pasadas
    if opciones.size > 0
      case
        when opciones.has_key?(:solo)
          case
            when opciones[:solo].is_a?(Array)
              modelos_a_buscar = @@clases_fts - (@@clases_fts - opciones[:solo])
            when opciones[:solo].is_a?(Symbol)
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

      # Crear la vista temporal con los objetos coincidentes de la tabla de búsquedas
      connection.execute "
        CREATE OR REPLACE TEMPORARY VIEW objetos_encontrados AS
          SELECT id, modelo_type, modelo_id
            FROM busquedas
            WHERE
              \'#{tsquery}\'::tsquery @@ vector_fts
              AND modelo_type IN (\'#{modelos_a_buscar.collect{ |m| m.to_s.singularize.camelize }.join("', '")}\')
          UNION
          SELECT id, modelo_type, modelo_id
            FROM busquedas_locales
            WHERE
              \'#{tsquery}\'::tsquery @@ vector_fts
              AND modelo_type IN (\'#{modelos_a_buscar.collect{ |m| m.to_s.singularize.camelize }.join("', '")}\');
      "

      # Crear la vista temporal que da finalmente los resultados de la consulta
      connection.execute "
        CREATE OR REPLACE TEMPORARY VIEW resultados_de_la_busqueda AS
          SELECT row_number() OVER () AS orden, *
            FROM (
              SELECT id, modelo_type, modelo_id, titulo, texto
                FROM (
                  SELECT
                    id, modelo_type, modelo_id, titulo, vector_fts,
                    ts_headline('public.indices_fts', texto, \'#{tsquery}\'::tsquery,
                      'StartSel=\"<span class=\"\"destacado\"\">\",StopSel=\"</span>\",MaxFragments=8') AS \"texto\"
                    FROM busquedas
                    WHERE
                      \'#{tsquery}\'::tsquery @@ vector_fts
                      AND modelo_type IN (\'#{modelos_a_buscar.collect{ |m| m.to_s.singularize.camelize }.join("', '")}\')
                  UNION
                  SELECT
                    id, modelo_type, modelo_id, titulo, vector_fts,
                    ts_headline('public.indices_fts', texto, \'#{tsquery}\'::tsquery,
                      'StartSel=\"<span class=\"\"destacado\"\">\",StopSel=\"</span>\",MaxFragments=8') AS \"texto\"
                    FROM busquedas_locales
                    WHERE
                      \'#{tsquery}\'::tsquery @@ vector_fts
                      AND modelo_type IN (\'#{modelos_a_buscar.collect{ |m| m.to_s.singularize.camelize }.join("', '")}\')
                ) AS subconsulta_interna
                ORDER BY ts_rank(vector_fts, \'#{tsquery}\'::tsquery) DESC
            ) AS subconsulta_externa;
      "
    else
      # Si no quedaron modelos que buscar, modificar las vistas para que no devuelvan nada
      connection.execute "
        CREATE OR REPLACE TEMPORARY VIEW objetos_encontrados AS
          SELECT id, modelo_type
            FROM busquedas
            WHERE
              false;
      "
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
    terminos_sql = sanitize_sql_for_conditions(['?', terminos.mb_chars.downcase.to_s])
    lexemas = connection.execute("SELECT lexemes FROM ts_debug('public.terminos_fts', unaccent(#{terminos_sql}));")
    tsquery = []
    lexemas.column_values(0).each do |l|
      if !l.blank? && l.to_s != "{}"
        tsquery << l.gsub(/\{/, "(").gsub(/,/, " | ").gsub(/\}/, ")")
      end
    end
    return tsquery.join(" & ")
  end

end
