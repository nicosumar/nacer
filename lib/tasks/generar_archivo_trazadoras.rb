#~~ encoding: utf-8 ~~

# ARCHIVO CE

archivo = File.open("lib/tasks/datos/trazadora_CE.csv", "w")
archivo.set_encoding("CP1252", :crlf_newline => true)

UnidadDeAltaDeDatos.where(:facturacion => true).each do |uad|
  ActiveRecord::Base.connection.schema_search_path = "uad_#{uad.codigo}, public"
  res = ActiveRecord::Base.connection.exec_query "
    SELECT
        e.cuie \"CUIE\",
        pb.clave_de_beneficiario \"Clave beneficiario\",
        cd.codigo \"Clase de documento\",
        td.codigo \"Tipo de documento\",
        a.numero_de_documento \"Numero de documento\",
        a.apellido \"Apellido\",
        a.nombre \"Nombre\",
        s.codigo \"Sexo\",
        a.fecha_de_nacimiento \"Fecha de nacimiento\",
        pb.fecha_de_la_prestacion \"Fecha control\",
        dra_eg.valor_big_decimal::integer \"Edad gestacional\",
        (CASE
          WHEN a.fecha_de_la_ultima_menstruacion < pb.fecha_de_la_prestacion THEN
            a.fecha_de_la_ultima_menstruacion
          ELSE
            NULL::date
          END) \"Fecha de última menstruación\",
        (CASE
          WHEN a.fecha_probable_de_parto > pb.fecha_de_la_prestacion THEN
            a.fecha_probable_de_parto
          ELSE
            NULL::date
          END) \"Fecha probable de parto\",
        to_char(dra_pkg.valor_big_decimal, 'FM999.099') \"Peso\",
        to_char(dra_tas.valor_integer, 'FM000') || '/'::text || to_char(dra_tad.valor_integer, 'FM000') \"Tensión arterial\",
        'S'::char(1) \"Es control\",
        substr(current_schema(), 5, 3) || to_char(pb.id, 'FM000000') \"Id registro provincial\"
      FROM
        prestaciones_brindadas pb
        JOIN efectores e ON e.id = pb.efector_id
        JOIN afiliados a ON a.clave_de_beneficiario = pb.clave_de_beneficiario
        JOIN clases_de_documentos cd ON cd.id = a.clase_de_documento_id
        JOIN tipos_de_documentos td ON td.id = a.tipo_de_documento_id
        JOIN sexos s ON s.id = a.sexo_id
        LEFT JOIN (
          datos_reportables_asociados dra_eg
          JOIN datos_reportables_requeridos drr_eg
            ON (drr_eg.id = dra_eg.dato_reportable_requerido_id AND drr_eg.dato_reportable_id = 3)
        ) ON (pb.id = dra_eg.prestacion_brindada_id)
        LEFT JOIN (
          datos_reportables_asociados dra_pkg
          JOIN datos_reportables_requeridos drr_pkg
            ON (drr_pkg.id = dra_pkg.dato_reportable_requerido_id AND drr_pkg.dato_reportable_id = 1)
        ) ON (pb.id = dra_pkg.prestacion_brindada_id)
        LEFT JOIN (
          datos_reportables_asociados dra_tas
          JOIN datos_reportables_requeridos drr_tas
            ON (drr_tas.id = dra_tas.dato_reportable_requerido_id AND drr_tas.dato_reportable_id = 4)
        ) ON (pb.id = dra_tas.prestacion_brindada_id)
        LEFT JOIN (
          datos_reportables_asociados dra_tad
          JOIN datos_reportables_requeridos drr_tad
            ON (drr_tad.id = dra_tad.dato_reportable_requerido_id AND drr_tad.dato_reportable_id = 5)
        ) ON (pb.id = dra_tad.prestacion_brindada_id)
      WHERE
        pb.prestacion_id IN (258, 259, 262, 324, 325, 326, 327, 353, 354, 369)
        AND pb.fecha_de_la_prestacion BETWEEN '2014-05-01' AND '2014-08-31'
        AND pb.estado_de_la_prestacion_id NOT IN (10, 11)

    UNION

    SELECT
        e.cuie \"CUIE\",
        pb.clave_de_beneficiario \"Clave beneficiario\",
        cd.codigo \"Clase de documento\",
        td.codigo \"Tipo de documento\",
        a.numero_de_documento \"Numero de documento\",
        a.apellido \"Apellido\",
        a.nombre \"Nombre\",
        s.codigo \"Sexo\",
        a.fecha_de_nacimiento \"Fecha de nacimiento\",
        pb.fecha_de_la_prestacion \"Fecha control\",
        dra_eg.valor_big_decimal::integer \"Edad gestacional\",
        (CASE
          WHEN a.fecha_de_la_ultima_menstruacion < pb.fecha_de_la_prestacion THEN
            a.fecha_de_la_ultima_menstruacion
          ELSE
            NULL::date
          END) \"Fecha de última menstruación\",
        (CASE
          WHEN a.fecha_probable_de_parto > pb.fecha_de_la_prestacion THEN
            a.fecha_probable_de_parto
          ELSE
            NULL::date
          END) \"Fecha probable de parto\",
        to_char(dra_pkg.valor_big_decimal, 'FM999.099') \"Peso\",
        to_char(dra_tas.valor_integer, 'FM000') || '/'::text || to_char(dra_tad.valor_integer, 'FM000') \"Tensión arterial\",
        'N'::char(1) \"Es control\",
        substr(current_schema(), 5, 3) || to_char(pb.id, 'FM000000') \"Id registro provincial\"
      FROM
        prestaciones_brindadas pb
        JOIN efectores e ON e.id = pb.efector_id
        JOIN afiliados a ON a.clave_de_beneficiario = pb.clave_de_beneficiario
        JOIN clases_de_documentos cd ON cd.id = a.clase_de_documento_id
        JOIN tipos_de_documentos td ON td.id = a.tipo_de_documento_id
        JOIN sexos s ON s.id = a.sexo_id
        LEFT JOIN (
          datos_reportables_asociados dra_eg
          JOIN datos_reportables_requeridos drr_eg
            ON (drr_eg.id = dra_eg.dato_reportable_requerido_id AND drr_eg.dato_reportable_id = 3)
        ) ON (pb.id = dra_eg.prestacion_brindada_id)
        LEFT JOIN (
          datos_reportables_asociados dra_pkg
          JOIN datos_reportables_requeridos drr_pkg
            ON (drr_pkg.id = dra_pkg.dato_reportable_requerido_id AND drr_pkg.dato_reportable_id = 1)
        ) ON (pb.id = dra_pkg.prestacion_brindada_id)
        LEFT JOIN (
          datos_reportables_asociados dra_tas
          JOIN datos_reportables_requeridos drr_tas
            ON (drr_tas.id = dra_tas.dato_reportable_requerido_id AND drr_tas.dato_reportable_id = 4)
        ) ON (pb.id = dra_tas.prestacion_brindada_id)
        LEFT JOIN (
          datos_reportables_asociados dra_tad
          JOIN datos_reportables_requeridos drr_tad
            ON (drr_tad.id = dra_tad.dato_reportable_requerido_id AND drr_tad.dato_reportable_id = 5)
        ) ON (pb.id = dra_tad.prestacion_brindada_id)
      WHERE
        pb.prestacion_id IN (320, 348)
        AND pb.fecha_de_la_prestacion BETWEEN '2014-05-01' AND '2014-08-31'
        AND pb.estado_de_la_prestacion_id NOT IN (10, 11);
  "
  res.rows.each do |row|
    archivo.puts row.join("\t")
  end
end

archivo.close

# Archivo CN

archivo = File.open("lib/tasks/datos/trazadora_CN.csv", "w")
archivo.set_encoding("CP1252", :crlf_newline => true)

UnidadDeAltaDeDatos.where(:facturacion => true).each do |uad|
  ActiveRecord::Base.connection.schema_search_path = "uad_#{uad.codigo}, public"
  res = ActiveRecord::Base.connection.exec_query "
    SELECT
        e.cuie \"CUIE\",
        pb.clave_de_beneficiario \"Clave beneficiario\",
        cd.codigo \"Clase de documento\",
        td.codigo \"Tipo de documento\",
        a.numero_de_documento \"Numero de documento\",
        a.apellido \"Apellido\",
        a.nombre \"Nombre\",
        s.codigo \"Sexo\",
        a.fecha_de_nacimiento \"Fecha de nacimiento\",
        d.departamento_indec_id \"Departamento de residencia\",
        pb.fecha_de_la_prestacion \"Fecha control\",
        to_char(dra_pkg.valor_big_decimal, 'FM999.099') \"Peso\",
        dra_tcm.valor_integer \"Talla\",
        to_char(dra_pc.valor_integer, 'FM99.0') \"Perímetro cefálico\",
        NULL::text \"Percentilo P/E\",
        NULL::text \"Percentilo T/E\",
        NULL::text \"Percentilo PC/E\",
        NULL::text \"Percentilo P/T\",
        NULL::text \"Tensión arterial\",
        substr(current_schema(), 5, 3) || to_char(pb.id, 'FM000000') \"Id registro provincial\"
      FROM
        prestaciones_brindadas pb
        JOIN efectores e ON e.id = pb.efector_id
        JOIN afiliados a ON a.clave_de_beneficiario = pb.clave_de_beneficiario
        JOIN clases_de_documentos cd ON cd.id = a.clase_de_documento_id
        JOIN tipos_de_documentos td ON td.id = a.tipo_de_documento_id
        JOIN sexos s ON s.id = a.sexo_id
        LEFT JOIN departamentos d ON d.id = a.domicilio_departamento_id
        LEFT JOIN (
          datos_reportables_asociados dra_pkg
          JOIN datos_reportables_requeridos drr_pkg
            ON (drr_pkg.id = dra_pkg.dato_reportable_requerido_id AND drr_pkg.dato_reportable_id = 1)
        ) ON (pb.id = dra_pkg.prestacion_brindada_id)
        LEFT JOIN (
          datos_reportables_asociados dra_tcm
          JOIN datos_reportables_requeridos drr_tcm
            ON (drr_tcm.id = dra_tcm.dato_reportable_requerido_id AND drr_tcm.dato_reportable_id = 26)
        ) ON (pb.id = dra_tcm.prestacion_brindada_id)
        LEFT JOIN (
          datos_reportables_asociados dra_pc
          JOIN datos_reportables_requeridos drr_pc
            ON (drr_pc.id = dra_pc.dato_reportable_requerido_id AND drr_pc.dato_reportable_id = 27)
        ) ON (pb.id = dra_pc.prestacion_brindada_id)
      WHERE
        pb.prestacion_id IN (455)
        AND pb.fecha_de_la_prestacion BETWEEN '2014-01-01' AND '2014-08-31'
        AND pb.estado_de_la_prestacion_id NOT IN (10, 11)

    UNION

    SELECT
        e.cuie \"CUIE\",
        pb.clave_de_beneficiario \"Clave beneficiario\",
        cd.codigo \"Clase de documento\",
        td.codigo \"Tipo de documento\",
        a.numero_de_documento \"Numero de documento\",
        a.apellido \"Apellido\",
        a.nombre \"Nombre\",
        s.codigo \"Sexo\",
        a.fecha_de_nacimiento \"Fecha de nacimiento\",
        d.departamento_indec_id \"Departamento de residencia\",
        pb.fecha_de_la_prestacion \"Fecha control\",
        to_char(dra_pkg.valor_big_decimal, 'FM999.099') \"Peso\",
        dra_tcm.valor_integer \"Talla\",
        NULL::text \"Perímetro cefálico\",
        NULL::text \"Percentilo P/E\",
        NULL::text \"Percentilo T/E\",
        NULL::text \"Percentilo PC/E\",
        NULL::text \"Percentilo P/T\",
        NULL::text \"Tensión arterial\",
        substr(current_schema(), 5, 3) || to_char(pb.id, 'FM000000') \"Id registro provincial\"
      FROM
        prestaciones_brindadas pb
        JOIN efectores e ON e.id = pb.efector_id
        JOIN afiliados a ON a.clave_de_beneficiario = pb.clave_de_beneficiario
        JOIN clases_de_documentos cd ON cd.id = a.clase_de_documento_id
        JOIN tipos_de_documentos td ON td.id = a.tipo_de_documento_id
        JOIN sexos s ON s.id = a.sexo_id
        LEFT JOIN departamentos d ON d.id = a.domicilio_departamento_id
        LEFT JOIN (
          datos_reportables_asociados dra_pkg
          JOIN datos_reportables_requeridos drr_pkg
            ON (drr_pkg.id = dra_pkg.dato_reportable_requerido_id AND drr_pkg.dato_reportable_id = 1)
        ) ON (pb.id = dra_pkg.prestacion_brindada_id)
        LEFT JOIN (
          datos_reportables_asociados dra_tcm
          JOIN datos_reportables_requeridos drr_tcm
            ON (drr_tcm.id = dra_tcm.dato_reportable_requerido_id AND drr_tcm.dato_reportable_id = 26)
        ) ON (pb.id = dra_tcm.prestacion_brindada_id)
      WHERE
        pb.prestacion_id IN (456, 493, 494)
        AND pb.fecha_de_la_prestacion BETWEEN '2014-01-01' AND '2014-08-31'
        AND pb.estado_de_la_prestacion_id NOT IN (10, 11)

    UNION

    SELECT
        e.cuie \"CUIE\",
        pb.clave_de_beneficiario \"Clave beneficiario\",
        cd.codigo \"Clase de documento\",
        td.codigo \"Tipo de documento\",
        a.numero_de_documento \"Numero de documento\",
        a.apellido \"Apellido\",
        a.nombre \"Nombre\",
        s.codigo \"Sexo\",
        a.fecha_de_nacimiento \"Fecha de nacimiento\",
        d.departamento_indec_id \"Departamento de residencia\",
        pb.fecha_de_la_prestacion \"Fecha control\",
        to_char(dra_pkg.valor_big_decimal, 'FM999.099') \"Peso\",
        (dra_tm.valor_big_decimal * 100.0::numeric(5,2))::integer \"Talla\",
        NULL::text \"Perímetro cefálico\",
        NULL::text \"Percentilo P/E\",
        NULL::text \"Percentilo T/E\",
        NULL::text \"Percentilo PC/E\",
        NULL::text \"Percentilo P/T\",
        to_char(dra_tas.valor_integer, 'FM000') || '/'::text || to_char(dra_tad.valor_integer, 'FM000') \"Tensión arterial\",
        substr(current_schema(), 5, 3) || to_char(pb.id, 'FM000000') \"Id registro provincial\"
      FROM
        prestaciones_brindadas pb
        JOIN efectores e ON e.id = pb.efector_id
        JOIN afiliados a ON a.clave_de_beneficiario = pb.clave_de_beneficiario
        JOIN clases_de_documentos cd ON cd.id = a.clase_de_documento_id
        JOIN tipos_de_documentos td ON td.id = a.tipo_de_documento_id
        JOIN sexos s ON s.id = a.sexo_id
        LEFT JOIN departamentos d ON d.id = a.domicilio_departamento_id
        LEFT JOIN (
          datos_reportables_asociados dra_pkg
          JOIN datos_reportables_requeridos drr_pkg
            ON (drr_pkg.id = dra_pkg.dato_reportable_requerido_id AND drr_pkg.dato_reportable_id = 1)
        ) ON (pb.id = dra_pkg.prestacion_brindada_id)
        LEFT JOIN (
          datos_reportables_asociados dra_tm
          JOIN datos_reportables_requeridos drr_tm
            ON (drr_tm.id = dra_tm.dato_reportable_requerido_id AND drr_tm.dato_reportable_id = 2)
        ) ON (pb.id = dra_tm.prestacion_brindada_id)
        LEFT JOIN (
          datos_reportables_asociados dra_tas
          JOIN datos_reportables_requeridos drr_tas
            ON (drr_tas.id = dra_tas.dato_reportable_requerido_id AND drr_tas.dato_reportable_id = 4)
        ) ON (pb.id = dra_tas.prestacion_brindada_id)
        LEFT JOIN (
          datos_reportables_asociados dra_tad
          JOIN datos_reportables_requeridos drr_tad
            ON (drr_tad.id = dra_tad.dato_reportable_requerido_id AND drr_tad.dato_reportable_id = 5)
        ) ON (pb.id = dra_tad.prestacion_brindada_id)
      WHERE
        pb.prestacion_id IN (516, 517, 518, 519, 521, 522, 554, 555, 556, 557)
        AND pb.fecha_de_la_prestacion BETWEEN '2014-01-01' AND '2014-08-31'
        AND pb.estado_de_la_prestacion_id NOT IN (10, 11);
  "
  res.rows.each do |row|
    archivo.puts row.join("\t")
  end
end

archivo.close

# ARCHIVO IA

archivo = File.open("lib/tasks/datos/trazadora_IA.csv", "w")
archivo.set_encoding("CP1252", :crlf_newline => true)

UnidadDeAltaDeDatos.where(:facturacion => true).each do |uad|
  ActiveRecord::Base.connection.schema_search_path = "uad_#{uad.codigo}, public"
  res = ActiveRecord::Base.connection.exec_query "
    SELECT
        e.cuie \"CUIE\",
        pb.clave_de_beneficiario \"Clave beneficiario\",
        cd.codigo \"Clase de documento\",
        td.codigo \"Tipo de documento\",
        a.numero_de_documento \"Numero de documento\",
        a.apellido \"Apellido\",
        a.nombre \"Nombre\",
        s.codigo \"Sexo\",
        a.fecha_de_nacimiento \"Fecha de nacimiento\",
        pb.fecha_de_la_prestacion \"Fecha de vacunación cuádruple\",
        NULL::date \"Fecha de vacunación antipoliomielítica\",
        substr(current_schema(), 5, 3) || to_char(pb.id, 'FM000000') \"Id registro provincial\"
      FROM
        prestaciones_brindadas pb
        JOIN efectores e ON e.id = pb.efector_id
        JOIN afiliados a ON a.clave_de_beneficiario = pb.clave_de_beneficiario
        JOIN clases_de_documentos cd ON cd.id = a.clase_de_documento_id
        JOIN tipos_de_documentos td ON td.id = a.tipo_de_documento_id
        JOIN sexos s ON s.id = a.sexo_id
      WHERE
        pb.prestacion_id IN (460, 462)
        AND (a.fecha_de_nacimiento + '24 months'::interval)::date BETWEEN '2014-05-01' AND '2014-08-31'
        AND pb.estado_de_la_prestacion_id NOT IN (10, 11)

    UNION

    SELECT
        e.cuie \"CUIE\",
        pb.clave_de_beneficiario \"Clave beneficiario\",
        cd.codigo \"Clase de documento\",
        td.codigo \"Tipo de documento\",
        a.numero_de_documento \"Numero de documento\",
        a.apellido \"Apellido\",
        a.nombre \"Nombre\",
        s.codigo \"Sexo\",
        a.fecha_de_nacimiento \"Fecha de nacimiento\",
        NULL::date \"Fecha de vacunación cuádruple\",
        pb.fecha_de_la_prestacion \"Fecha de vacunación antipoliomielítica\",
        substr(current_schema(), 5, 3) || to_char(pb.id, 'FM000000') \"Id registro provincial\"
      FROM
        prestaciones_brindadas pb
        JOIN efectores e ON e.id = pb.efector_id
        JOIN afiliados a ON a.clave_de_beneficiario = pb.clave_de_beneficiario
        JOIN clases_de_documentos cd ON cd.id = a.clase_de_documento_id
        JOIN tipos_de_documentos td ON td.id = a.tipo_de_documento_id
        JOIN sexos s ON s.id = a.sexo_id
      WHERE
        pb.prestacion_id IN (464, 501)
        AND (a.fecha_de_nacimiento + '24 months'::interval)::date BETWEEN '2014-05-01' AND '2014-08-31'
        AND pb.estado_de_la_prestacion_id NOT IN (10, 11);
  "
  res.rows.each do |row|
    archivo.puts row.join("\t")
  end
end

archivo.close

# ARCHIVO IB

archivo = File.open("lib/tasks/datos/trazadora_IB.csv", "w")
archivo.set_encoding("CP1252", :crlf_newline => true)

UnidadDeAltaDeDatos.where(:facturacion => true).each do |uad|
  ActiveRecord::Base.connection.schema_search_path = "uad_#{uad.codigo}, public"
  res = ActiveRecord::Base.connection.exec_query "
    SELECT
        e.cuie \"CUIE\",
        pb.clave_de_beneficiario \"Clave beneficiario\",
        cd.codigo \"Clase de documento\",
        td.codigo \"Tipo de documento\",
        a.numero_de_documento \"Numero de documento\",
        a.apellido \"Apellido\",
        a.nombre \"Nombre\",
        s.codigo \"Sexo\",
        a.fecha_de_nacimiento \"Fecha de nacimiento\",
        pb.fecha_de_la_prestacion \"Fecha de vacunación triple bacteriana\",
        NULL::date \"Fecha de vacunación triple viral\",
        NULL::date \"Fecha de vacunación antipoliomielítica\",
        substr(current_schema(), 5, 3) || to_char(pb.id, 'FM000000') \"Id registro provincial\"
      FROM
        prestaciones_brindadas pb
        JOIN efectores e ON e.id = pb.efector_id
        JOIN afiliados a ON a.clave_de_beneficiario = pb.clave_de_beneficiario
        JOIN clases_de_documentos cd ON cd.id = a.clase_de_documento_id
        JOIN tipos_de_documentos td ON td.id = a.tipo_de_documento_id
        JOIN sexos s ON s.id = a.sexo_id
      WHERE
        pb.prestacion_id = 463
        AND (a.fecha_de_nacimiento + '7 years'::interval)::date BETWEEN '2014-05-01' AND '2014-08-31'
        AND pb.estado_de_la_prestacion_id NOT IN (10, 11)

    UNION

    SELECT
        e.cuie \"CUIE\",
        pb.clave_de_beneficiario \"Clave beneficiario\",
        cd.codigo \"Clase de documento\",
        td.codigo \"Tipo de documento\",
        a.numero_de_documento \"Numero de documento\",
        a.apellido \"Apellido\",
        a.nombre \"Nombre\",
        s.codigo \"Sexo\",
        a.fecha_de_nacimiento \"Fecha de nacimiento\",
        NULL::date \"Fecha de vacunación triple bacteriana\",
        pb.fecha_de_la_prestacion \"Fecha de vacunación triple viral\",
        NULL::date \"Fecha de vacunación antipoliomielítica\",
        substr(current_schema(), 5, 3) || to_char(pb.id, 'FM000000') \"Id registro provincial\"
      FROM
        prestaciones_brindadas pb
        JOIN efectores e ON e.id = pb.efector_id
        JOIN afiliados a ON a.clave_de_beneficiario = pb.clave_de_beneficiario
        JOIN clases_de_documentos cd ON cd.id = a.clase_de_documento_id
        JOIN tipos_de_documentos td ON td.id = a.tipo_de_documento_id
        JOIN sexos s ON s.id = a.sexo_id
      WHERE
        pb.prestacion_id IN (465, 502, 765)
        AND (a.fecha_de_nacimiento + '7 years'::interval)::date BETWEEN '2014-05-01' AND '2014-08-31'
        AND pb.estado_de_la_prestacion_id NOT IN (10, 11)

    UNION

    SELECT
        e.cuie \"CUIE\",
        pb.clave_de_beneficiario \"Clave beneficiario\",
        cd.codigo \"Clase de documento\",
        td.codigo \"Tipo de documento\",
        a.numero_de_documento \"Numero de documento\",
        a.apellido \"Apellido\",
        a.nombre \"Nombre\",
        s.codigo \"Sexo\",
        a.fecha_de_nacimiento \"Fecha de nacimiento\",
        NULL::date \"Fecha de vacunación triple bacteriana\",
        NULL::date \"Fecha de vacunación triple viral\",
        pb.fecha_de_la_prestacion \"Fecha de vacunación antipoliomielítica\",
        substr(current_schema(), 5, 3) || to_char(pb.id, 'FM000000') \"Id registro provincial\"
      FROM
        prestaciones_brindadas pb
        JOIN efectores e ON e.id = pb.efector_id
        JOIN afiliados a ON a.clave_de_beneficiario = pb.clave_de_beneficiario
        JOIN clases_de_documentos cd ON cd.id = a.clase_de_documento_id
        JOIN tipos_de_documentos td ON td.id = a.tipo_de_documento_id
        JOIN sexos s ON s.id = a.sexo_id
      WHERE
        pb.prestacion_id IN (464, 501)
        AND (a.fecha_de_nacimiento + '7 years'::interval)::date BETWEEN '2014-05-01' AND '2014-08-31'
        AND pb.estado_de_la_prestacion_id NOT IN (10, 11);
  "
  res.rows.each do |row|
    archivo.puts row.join("\t")
  end
end

archivo.close

# ARCHIVO CU

archivo = File.open("lib/tasks/datos/trazadora_CU.csv", "w")
archivo.set_encoding("CP1252", :crlf_newline => true)

UnidadDeAltaDeDatos.where(:facturacion => true).each do |uad|
  ActiveRecord::Base.connection.schema_search_path = "uad_#{uad.codigo}, public"
  res = ActiveRecord::Base.connection.exec_query "
    SELECT
        e.cuie \"CUIE\",
        pb.clave_de_beneficiario \"Clave beneficiario\",
        cd.codigo \"Clase de documento\",
        td.codigo \"Tipo de documento\",
        a.numero_de_documento \"Numero de documento\",
        a.apellido \"Apellido\",
        a.nombre \"Nombre\",
        s.codigo \"Sexo\",
        a.fecha_de_nacimiento \"Fecha de nacimiento\",
        pb.fecha_de_la_prestacion \"Fecha de diagnóstico histológico\",
        dra_diag.valor_string \"Diagnóstico\",
        NULL::date \"Fecha de inicio de tratamiento\",
        substr(current_schema(), 5, 3) || to_char(pb.id, 'FM000000') \"Id registro provincial\"
      FROM
        prestaciones_brindadas pb
        JOIN efectores e ON e.id = pb.efector_id
        JOIN afiliados a ON a.clave_de_beneficiario = pb.clave_de_beneficiario
        JOIN clases_de_documentos cd ON cd.id = a.clase_de_documento_id
        JOIN tipos_de_documentos td ON td.id = a.tipo_de_documento_id
        JOIN sexos s ON s.id = a.sexo_id
        LEFT JOIN (
          datos_reportables_asociados dra_diag
          JOIN datos_reportables_requeridos drr_diag
            ON (drr_diag.id = dra_diag.dato_reportable_requerido_id AND drr_diag.dato_reportable_id = 37)
        ) ON (pb.id = dra_diag.prestacion_brindada_id)
      WHERE
        pb.prestacion_id = 586
        AND pb.fecha_de_la_prestacion BETWEEN '2013-09-01' AND '2014-08-31'
        AND pb.estado_de_la_prestacion_id NOT IN (10, 11);
  "
  res.rows.each do |row|
    archivo.puts row.join("\t")
  end
end

archivo.close

# ARCHIVO CM

archivo = File.open("lib/tasks/datos/trazadora_CM.csv", "w")
archivo.set_encoding("CP1252", :crlf_newline => true)

UnidadDeAltaDeDatos.where(:facturacion => true).each do |uad|
  ActiveRecord::Base.connection.schema_search_path = "uad_#{uad.codigo}, public"
  res = ActiveRecord::Base.connection.exec_query "
    SELECT
        e.cuie \"CUIE\",
        pb.clave_de_beneficiario \"Clave beneficiario\",
        cd.codigo \"Clase de documento\",
        td.codigo \"Tipo de documento\",
        a.numero_de_documento \"Numero de documento\",
        a.apellido \"Apellido\",
        a.nombre \"Nombre\",
        s.codigo \"Sexo\",
        a.fecha_de_nacimiento \"Fecha de nacimiento\",
        pb.fecha_de_la_prestacion \"Fecha de diagnóstico histológico\",
        dra_diag.valor_string \"Diagnóstico\",
        NULL::char(2) \"Tamaño\",
        NULL::char(2) \"Ganglios linfáticos\",
        NULL::char(2) \"Metástasis\",
        NULL::varchar(4) \"Estadío\",
        NULL::date \"Fecha de inicio de tratamiento\",
        substr(current_schema(), 5, 3) || to_char(pb.id, 'FM000000') \"Id registro provincial\"
      FROM
        prestaciones_brindadas pb
        JOIN efectores e ON e.id = pb.efector_id
        JOIN afiliados a ON a.clave_de_beneficiario = pb.clave_de_beneficiario
        JOIN clases_de_documentos cd ON cd.id = a.clase_de_documento_id
        JOIN tipos_de_documentos td ON td.id = a.tipo_de_documento_id
        JOIN sexos s ON s.id = a.sexo_id
        LEFT JOIN (
          datos_reportables_asociados dra_diag
          JOIN datos_reportables_requeridos drr_diag
            ON (drr_diag.id = dra_diag.dato_reportable_requerido_id AND drr_diag.dato_reportable_id = 37)
        ) ON (pb.id = dra_diag.prestacion_brindada_id)
      WHERE
        pb.prestacion_id = 585
        AND pb.fecha_de_la_prestacion BETWEEN '2013-09-01' AND '2014-08-31'
        AND pb.estado_de_la_prestacion_id NOT IN (10, 11);
  "
  res.rows.each do |row|
    archivo.puts row.join("\t")
  end
end

archivo.close
