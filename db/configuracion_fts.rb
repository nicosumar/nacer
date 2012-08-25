# Crear las restricciones adicionales en la base de datos
# Los archivos indicados en esta configuración deben adaptarse según su necesidad,
# y luego deben copiarse (o enlazarse) desde la ubicación actual en el directorio
# 'lib/tsearch_data/*' de esta aplicación al directorio de diccionarios
# compartidos de PostgreSQL (este directorio varía de acuerdo a la instalación).
class ConfiguracionFTS < ActiveRecord::Migration
  execute "
    CREATE EXTENSION unaccent;
  "
  execute "
    CREATE EXTENSION dict_xsyn;
  "
  execute "
    ALTER TEXT SEARCH DICTIONARY xsyn (RULES='nacer_xsyn', KEEPORIG=true, MATCHSYNONYMS=true);
  "
  execute "
    CREATE TEXT SEARCH CONFIGURATION public.indices_fts ( COPY = pg_catalog.spanish );
  "
  execute "
    CREATE TEXT SEARCH CONFIGURATION public.terminos_fts ( COPY = pg_catalog.spanish );
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
    ALTER TEXT SEARCH CONFIGURATION indices_fts
      ALTER MAPPING FOR asciiword, word, asciihword, hword, hword_asciipart, hword_part, int, uint
        WITH unaccent, nacer_tesauro, es_ar_hunspell, simple;
  "
  execute "
    ALTER TEXT SEARCH CONFIGURATION terminos_fts
      ALTER MAPPING FOR asciiword, word, asciihword, hword, hword_asciipart, hword_part, int, uint
        WITH xsyn, nacer_tesauro, es_ar_hunspell, simple;
  "
  execute "
    SET default_text_search_config = 'public.indices_fts';
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
