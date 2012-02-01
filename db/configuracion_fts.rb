# Crear las restricciones adicionales en la base de datos
# Los archivos indicados en esta configuración deben adaptarse según su necesidad,
# y luego deben copiarse (o enlazarse) desde la ubicación actual en el directorio
# 'lib/tsearch_data/*' de esta aplicación al directorio de diccionarios
# compartidos de PostgreSQL (este directorio varía de acuerdo a la instalación).
class ConfiguracionFTS < ActiveRecord::Migration
  execute "
    CREATE TEXT SEARCH CONFIGURATION public.es_ar ( COPY = pg_catalog.spanish );
  "
  execute "
    CREATE TEXT SEARCH DICTIONARY es_ar_hunspell (
      TEMPLATE = ispell,
      DictFile = es_ar_hunspell,
      AffFile = es_ar_hunspell,
      StopWords = es_ar );
  "
  execute "
    CREATE TEXT SEARCH DICTIONARY nacer_tesauro (
      TEMPLATE = thesaurus,
      DictFile = nacer,
      Dictionary = simple );
  "
  execute "
    CREATE TEXT SEARCH DICTIONARY nacer_sinonimos (
      TEMPLATE = synonym,
      SYNONYMS = nacer );
  "
  execute "
    ALTER TEXT SEARCH CONFIGURATION es_ar
      ALTER MAPPING FOR asciiword, word, asciihword, hword, hword_asciipart, hword_part, int
        WITH nacer_sinonimos, nacer_tesauro, es_ar_hunspell, simple;
  "
  execute "
    SET default_text_search_config = 'public.es_ar';
  "

  # Creación de índices en la tabla de búsquedas
  execute "
    CREATE UNIQUE INDEX idx_unq_modelo ON busquedas (modelo_type, modelo_id);
  "
  execute "
    CREATE INDEX idx_gin_on_vector_fts ON busquedas USING gin (vector_fts);
  "

  # Creación del lenguaje procedural 'PL/PGsql'
  execute "
    CREATE LANGUAGE plpgsql;
  "
end
