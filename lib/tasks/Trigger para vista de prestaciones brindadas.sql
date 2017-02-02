CREATE OR REPLACE FUNCTION modificar_vista_de_prestaciones_brindadas() RETURNS trigger AS $$
  DECLARE
    sql_text text;
    codigos_de_uads CURSOR FOR
      SELECT codigo FROM unidades_de_alta_de_datos WHERE facturacion = 't'::boolean;
  BEGIN
    sql_text := '';
    FOR uad IN codigos_de_uads LOOP
      IF length(sql_text) > 0 THEN
        sql_text :=
          sql_text ||
          ' UNION SELECT ''uad_' ||
          uad.codigo ||
          '''::text AS esquema, * FROM "uad_' ||
          uad.codigo || 
          '"."prestaciones_brindadas"';
      ELSE
        sql_text := 
          'SELECT ''uad_' ||
          uad.codigo ||
          '''::text AS esquema, * FROM "uad_' ||
          uad.codigo ||
          '"."prestaciones_brindadas"';
      END IF;
    END LOOP;

    EXECUTE '
      -- Creamos la vista que trae los datos completos de todas las prestaciones brindadas registradas
      CREATE OR REPLACE VIEW "public"."vista_de_prestaciones_brindadas" AS
        SELECT
            pb.esquema AS "esquema",
            pb.id AS "prestacion_brindada_id",
            edlp.nombre AS "estado_de_la_prestacion",
            pb.clave_de_beneficiario AS "clave_de_beneficiario",
            pb.historia_clinica AS "historia_clinica",
            pb.fecha_de_la_prestacion AS "fecha_de_la_prestacion",
            e.nombre AS "efector",
            p.codigo || d.codigo AS "codigo_de_la_prestacion",
            p.nombre AS "prestacion",
            d.nombre AS "diagnostico",
            pb.es_catastrofica AS "catastrofica",
            pb.cantidad_de_unidades AS "cantidad",
            pb.observaciones AS "observaciones"
          FROM
            (' || sql_text || ') AS pb
            JOIN "public"."estados_de_las_prestaciones" edlp ON (edlp.id = pb.estado_de_la_prestacion_id)
            JOIN "public"."efectores" e ON (e.id = pb.efector_id)
            JOIN "public"."prestaciones" p ON (p.id = pb.prestacion_id)
            JOIN "public"."diagnosticos" d ON (d.id = pb.diagnostico_id);
      ';
    RETURN NULL;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_modificar_vista_de_prestaciones_brindadas
  AFTER INSERT OR UPDATE OF facturacion ON unidades_de_alta_de_datos
  FOR EACH STATEMENT EXECUTE PROCEDURE modificar_vista_de_prestaciones_brindadas();