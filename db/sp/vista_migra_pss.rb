# -*- encoding : utf-8 -*-

ActiveRecord::Base.connection.execute <<-SQL

  CREATE VIEW "public"."vista_migra_pss" AS 
      SELECT 'Anexos' "origen", ''AS "grupo", '' AS "subgrupo", rural, id_subrrogada_foranea
      FROM migra_anexos ma
      WHERE id_subrrogada_foranea IS NOT NULL
    UNION
      SELECT 'Modulos' AS "origen", grupo::varchar(10), subgrupo::varchar(10), '' AS "rural", id_subrrogada_foranea
      FROM migra_modulos mo
      WHERE id_subrrogada_foranea IS NOT NULL
    UNION
      SELECT 'Prestaciones' AS "origen", grupo::varchar(10), subgrupo::varchar(10), rural, id_subrrogada_foranea
      FROM migra_prestaciones mp 
      WHERE id_subrrogada_foranea IS NOT NULL
SQL

