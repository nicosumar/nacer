SET SEARCH_PATH TO uad_007, public;
--SELECT SUM(precio_por_unidad * cantidad_de_unidades + adicional_por_prestacion) FROM prestaciones_brindadas pb
SELECT pb.id, pb.fecha_de_la_prestacion, af.apellido, af.nombre, pr.nombre, dr.nombre, (pb.cantidad_de_unidades * ap.precio_por_unidad + ap.adicional_por_prestacion)::decimal(15,4) AS monto FROM prestaciones_brindadas pb
  INNER JOIN prestaciones pr ON (pr.id = pb.prestacion_id) -- Este join trae los datos de la prestación
  INNER JOIN afiliados af ON (af.clave_de_beneficiario = pb.clave_de_beneficiario) -- Este join trae los datos del afiliado a la vez que elimina las prestaciones asociadas a novedades que aún no se han procesado
  INNER JOIN efectores ef ON (ef.id = pb.efector_id) -- Este join es para obtener el área de prestación del efector
  INNER JOIN asignaciones_de_precios ap  -- Este join trae los datos de la asignación de precios correspondiente al área de prestación del efector
    ON (
      ap.prestacion_id = pb.prestacion_id
      AND ap.area_de_prestacion_id = ef.area_de_prestacion_id
    )
  INNER JOIN nomencladores nom  -- Este join selecciona únicamente las AP correspondientes al nomenclador activo en el momento de la prestación
    ON (
      nom.id = ap.nomenclador_id
      AND pb.fecha_de_la_prestacion >= nom.fecha_de_inicio
      -- AND (pb.fecha_de_la_prestacion < nom.fecha_de_finalizacion OR nom.fecha_de_finalizacion IS NULL)
    )
  LEFT JOIN (  -- Este join añade la información de los datos reportables asociados a las AP que los requieren (para obtener las cantidades)
      datos_reportables_asociados dra
      INNER JOIN
        datos_reportables_requeridos drr ON (drr.id = dra.dato_reportable_requerido_id)
      INNER JOIN
        datos_reportables dr ON (drr.dato_reportable_id = dr.id)
    )
    ON (
      dra.prestacion_brindada_id = pb.id
      AND ap.dato_reportable_id = drr.dato_reportable_id
    )
--  WHERE estado_de_la_prestacion_id IN (3);
--  WHERE estado_de_la_prestacion_id IN (1,2,3,7)
  WHERE estado_de_la_prestacion_id IN (3)
  ORDER BY af.clave_de_beneficiario, pb.fecha_de_la_prestacion, pb.id;