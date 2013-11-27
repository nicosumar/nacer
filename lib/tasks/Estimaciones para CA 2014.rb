# ~~encoding: utf-8~~

archivo = File.open('lib/tasks/datos/Estimaciones_CA_2014.csv', "w")

archivo.puts "Niños de 0 a 5 años"

(0..9).each do |meses|
  ar_result = ActiveRecord::Base.connection.exec_query(
    "
      SELECT 'Inscriptos de 0 a 5 años'::text \"Indicador\", count(*) \"Cantidad\"
        FROM
          afiliados af
          JOIN periodos_de_actividad pa ON pa.afiliado_id = af.afiliado_id
        WHERE
          -- Edad del beneficiario entre 0 y 5 años en el mes evaluado: total de inscriptos.
          af.fecha_de_nacimiento >= '#{Date.new(2007, 1, 1) + meses.months}'
          AND af.fecha_de_nacimiento < '#{Date.new(2013, 2, 1) + meses.months}'
          -- Que no estén duplicados
          AND (af.motivo_de_la_baja_id IS NULL OR af.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          -- Con fecha de inscripción anterior al mes evaluado
          AND af.fecha_de_inscripcion < '#{Date.new(2013, 2, 1) + meses.months}'

      UNION

      SELECT 'Inscriptos activos de 0 a 5 años'::text \"Indicador\", count(*) \"Cantidad\"
        FROM
          afiliados af
          JOIN periodos_de_actividad pa ON pa.afiliado_id = af.afiliado_id
        WHERE
          -- Edad del beneficiario entre 0 y 5 años en el mes evaluado: total de inscriptos.
          af.fecha_de_nacimiento >= '#{Date.new(2007, 1, 1) + meses.months}'
          AND af.fecha_de_nacimiento < '#{Date.new(2013, 2, 1) + meses.months}'
          -- Activo en el mes evaluado: total de activos.
          AND pa.fecha_de_inicio < '#{Date.new(2013, 2, 1) + meses.months}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion >= '#{Date.new(2013, 2, 1) + meses.months}'
          )
          -- Que no estén duplicados
          AND (af.motivo_de_la_baja_id IS NULL OR af.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          -- Con fecha de inscripción anterior al mes evaluado
          AND af.fecha_de_inscripcion < '#{Date.new(2013, 2, 1) + meses.months}'

      UNION

      SELECT 'Inscriptos activos de 0 a 5 años con CEB por prestación'::text \"Indicador\", count(*) \"Cantidad\"
        FROM
          afiliados af
          JOIN periodos_de_actividad pa ON pa.afiliado_id = af.afiliado_id
        WHERE
          -- Edad del beneficiario entre 0 y 5 años en el mes evaluado: total de inscriptos.
          af.fecha_de_nacimiento >= '#{Date.new(2007, 1, 1) + meses.months}'
          AND af.fecha_de_nacimiento < '#{Date.new(2013, 2, 1) + meses.months}'
          -- Activo en el mes evaluado: total de activos.
          AND pa.fecha_de_inicio < '#{Date.new(2013, 2, 1) + meses.months}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion >= '#{Date.new(2013, 2, 1) + meses.months}'
          )
          -- Con una prestación durante el último año: total de activos con CEB por prestación.
          AND af.fecha_de_la_ultima_prestacion >= '#{Date.new(2012, 1, 1) + meses.months}'
          AND af.fecha_de_la_ultima_prestacion < '#{Date.new(2013, 2, 1) + meses.months}'
          -- Que no estén duplicados
          AND (af.motivo_de_la_baja_id IS NULL OR af.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          -- Con fecha de inscripción anterior al mes evaluado
          AND af.fecha_de_inscripcion < '#{Date.new(2013, 2, 1) + meses.months}'
        ORDER BY 2 DESC;
    "
  )
  archivo.puts I18n::localize(Date.new(2013, 1, 1) + meses.months, :format => :month_and_year)
  archivo.puts ar_result.columns.join("\t")
  ar_result.rows.each do |row|
    archivo.puts row.join("\t")
  end
end

archivo.puts "\nNiños de 6 a 9 años"

(0..9).each do |meses|
  ar_result = ActiveRecord::Base.connection.exec_query(
    "
      SELECT 'Inscriptos de 6 a 9 años'::text \"Indicador\", count(*) \"Cantidad\"
        FROM
          afiliados af
          JOIN periodos_de_actividad pa ON pa.afiliado_id = af.afiliado_id
        WHERE
          -- Edad del beneficiario entre 6 y 9 años en el mes evaluado: total de inscriptos.
          af.fecha_de_nacimiento >= '#{Date.new(2003, 1, 1) + meses.months}'
          AND af.fecha_de_nacimiento < '#{Date.new(2007, 1, 1) + meses.months}'
          -- Que no estén duplicados
          AND (af.motivo_de_la_baja_id IS NULL OR af.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          -- Con fecha de inscripción anterior al mes evaluado
          AND af.fecha_de_inscripcion < '#{Date.new(2013, 2, 1) + meses.months}'

      UNION

      SELECT 'Inscriptos activos de 6 a 9 años'::text \"Indicador\", count(*) \"Cantidad\"
        FROM
          afiliados af
          JOIN periodos_de_actividad pa ON pa.afiliado_id = af.afiliado_id
        WHERE
          -- Edad del beneficiario entre 6 y 9 años en el mes evaluado: total de inscriptos.
          af.fecha_de_nacimiento >= '#{Date.new(2003, 1, 1) + meses.months}'
          AND af.fecha_de_nacimiento < '#{Date.new(2007, 1, 1) + meses.months}'
          -- Activo en el mes evaluado: total de activos.
          AND pa.fecha_de_inicio < '#{Date.new(2013, 2, 1) + meses.months}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion >= '#{Date.new(2013, 2, 1) + meses.months}'
          )
          -- Que no estén duplicados
          AND (af.motivo_de_la_baja_id IS NULL OR af.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          -- Con fecha de inscripción anterior al mes evaluado
          AND af.fecha_de_inscripcion < '#{Date.new(2013, 2, 1) + meses.months}'

      UNION

      SELECT 'Inscriptos activos de 6 a 9 años con CEB por prestación'::text \"Indicador\", count(*) \"Cantidad\"
        FROM
          afiliados af
          JOIN periodos_de_actividad pa ON pa.afiliado_id = af.afiliado_id
        WHERE
          -- Edad del beneficiario entre 6 y 9 años en el mes evaluado: total de inscriptos.
          af.fecha_de_nacimiento >= '#{Date.new(2003, 1, 1) + meses.months}'
          AND af.fecha_de_nacimiento < '#{Date.new(2007, 1, 1) + meses.months}'
          -- Activo en el mes evaluado: total de activos.
          AND pa.fecha_de_inicio < '#{Date.new(2013, 2, 1) + meses.months}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion >= '#{Date.new(2013, 2, 1) + meses.months}'
          )
          -- Con una prestación durante el último año: total de activos con CEB por prestación.
          AND af.fecha_de_la_ultima_prestacion >= '#{Date.new(2012, 1, 1) + meses.months}'
          AND af.fecha_de_la_ultima_prestacion < '#{Date.new(2013, 2, 1) + meses.months}'
          -- Que no estén duplicados
          AND (af.motivo_de_la_baja_id IS NULL OR af.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          -- Con fecha de inscripción anterior al mes evaluado
          AND af.fecha_de_inscripcion < '#{Date.new(2013, 2, 1) + meses.months}'
        ORDER BY 2 DESC;
    "
  )
  archivo.puts I18n::localize(Date.new(2013, 1, 1) + meses.months, :format => :month_and_year)
  archivo.puts ar_result.columns.join("\t")
  ar_result.rows.each do |row|
    archivo.puts row.join("\t")
  end
end

archivo.puts "\nAdolescentes de 10 a 19 años"

(0..9).each do |meses|
  ar_result = ActiveRecord::Base.connection.exec_query(
    "
      SELECT 'Inscriptos de 10 a 19 años'::text \"Indicador\", count(*) \"Cantidad\"
        FROM
          afiliados af
          JOIN periodos_de_actividad pa ON pa.afiliado_id = af.afiliado_id
        WHERE
          -- Edad del beneficiario entre 6 y 9 años en el mes evaluado: total de inscriptos.
          af.fecha_de_nacimiento >= '#{Date.new(1993, 1, 1) + meses.months}'
          AND af.fecha_de_nacimiento < '#{Date.new(2003, 1, 1) + meses.months}'
          -- Que no estén duplicados
          AND (af.motivo_de_la_baja_id IS NULL OR af.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          -- Con fecha de inscripción anterior al mes evaluado
          AND af.fecha_de_inscripcion < '#{Date.new(2013, 2, 1) + meses.months}'

      UNION

      SELECT 'Inscriptos activos de 10 a 19 años'::text \"Indicador\", count(*) \"Cantidad\"
        FROM
          afiliados af
          JOIN periodos_de_actividad pa ON pa.afiliado_id = af.afiliado_id
        WHERE
          -- Edad del beneficiario entre 6 y 9 años en el mes evaluado: total de inscriptos.
          af.fecha_de_nacimiento >= '#{Date.new(1993, 1, 1) + meses.months}'
          AND af.fecha_de_nacimiento < '#{Date.new(2003, 1, 1) + meses.months}'
          -- Activo en el mes evaluado: total de activos.
          AND pa.fecha_de_inicio < '#{Date.new(2013, 2, 1) + meses.months}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion >= '#{Date.new(2013, 2, 1) + meses.months}'
          )
          -- Que no estén duplicados
          AND (af.motivo_de_la_baja_id IS NULL OR af.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          -- Con fecha de inscripción anterior al mes evaluado
          AND af.fecha_de_inscripcion < '#{Date.new(2013, 2, 1) + meses.months}'

      UNION

      SELECT 'Inscriptos activos de 10 a 19 años con CEB por prestación'::text \"Indicador\", count(*) \"Cantidad\"
        FROM
          afiliados af
          JOIN periodos_de_actividad pa ON pa.afiliado_id = af.afiliado_id
        WHERE
          -- Edad del beneficiario entre 6 y 9 años en el mes evaluado: total de inscriptos.
          af.fecha_de_nacimiento >= '#{Date.new(1993, 1, 1) + meses.months}'
          AND af.fecha_de_nacimiento < '#{Date.new(2003, 1, 1) + meses.months}'
          -- Activo en el mes evaluado: total de activos.
          AND pa.fecha_de_inicio < '#{Date.new(2013, 2, 1) + meses.months}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion >= '#{Date.new(2013, 2, 1) + meses.months}'
          )
          -- Con una prestación durante el último año: total de activos con CEB por prestación.
          AND af.fecha_de_la_ultima_prestacion >= '#{Date.new(2012, 1, 1) + meses.months}'
          AND af.fecha_de_la_ultima_prestacion < '#{Date.new(2013, 2, 1) + meses.months}'
          -- Que no estén duplicados
          AND (af.motivo_de_la_baja_id IS NULL OR af.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          -- Con fecha de inscripción anterior al mes evaluado
          AND af.fecha_de_inscripcion < '#{Date.new(2013, 2, 1) + meses.months}'
        ORDER BY 2 DESC;
    "
  )
  archivo.puts I18n::localize(Date.new(2013, 1, 1) + meses.months, :format => :month_and_year)
  archivo.puts ar_result.columns.join("\t")
  ar_result.rows.each do |row|
    archivo.puts row.join("\t")
  end
end

archivo.puts "\nMujeres de 20 a 64 años"

(0..9).each do |meses|
  ar_result = ActiveRecord::Base.connection.exec_query(
    "
      SELECT 'Inscriptas de 20 a 64 años'::text \"Indicador\", count(*) \"Cantidad\"
        FROM
          afiliados af
          JOIN periodos_de_actividad pa ON pa.afiliado_id = af.afiliado_id
        WHERE
          -- Edad de la beneficiaria entre 20 y 64 años en el mes evaluado: total de inscriptos.
          af.fecha_de_nacimiento >= '#{Date.new(1948, 1, 1) + meses.months}'
          AND af.fecha_de_nacimiento < '#{Date.new(1993, 1, 1) + meses.months}'
          -- Sexo femenino
          AND sexo_id = 1
          -- Que no estén duplicados
          AND (af.motivo_de_la_baja_id IS NULL OR af.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          -- Con fecha de inscripción anterior al mes evaluado
          AND af.fecha_de_inscripcion < '#{Date.new(2013, 2, 1) + meses.months}'

      UNION

      SELECT 'Inscriptas activas de 20 a 64 años'::text \"Indicador\", count(*) \"Cantidad\"
        FROM
          afiliados af
          JOIN periodos_de_actividad pa ON pa.afiliado_id = af.afiliado_id
        WHERE
          -- Edad de la beneficiaria entre 20 y 64 años en el mes evaluado: total de inscriptos.
          af.fecha_de_nacimiento >= '#{Date.new(1948, 1, 1) + meses.months}'
          AND af.fecha_de_nacimiento < '#{Date.new(1993, 1, 1) + meses.months}'
          -- Sexo femenino
          AND sexo_id = 1
          -- Activo en el mes evaluado: total de activos.
          AND pa.fecha_de_inicio < '#{Date.new(2013, 2, 1) + meses.months}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion >= '#{Date.new(2013, 2, 1) + meses.months}'
          )
          -- Que no estén duplicados
          AND (af.motivo_de_la_baja_id IS NULL OR af.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          -- Con fecha de inscripción anterior al mes evaluado
          AND af.fecha_de_inscripcion < '#{Date.new(2013, 2, 1) + meses.months}'

      UNION

      SELECT 'Inscriptas activas de 20 a 64 años con CEB por prestación'::text \"Indicador\", count(*) \"Cantidad\"
        FROM
          afiliados af
          JOIN periodos_de_actividad pa ON pa.afiliado_id = af.afiliado_id
        WHERE
          -- Edad de la beneficiaria entre 20 y 64 años en el mes evaluado: total de inscriptos.
          af.fecha_de_nacimiento >= '#{Date.new(1948, 1, 1) + meses.months}'
          AND af.fecha_de_nacimiento < '#{Date.new(1993, 1, 1) + meses.months}'
          -- Sexo femenino
          AND sexo_id = 1
          -- Activo en el mes evaluado: total de activos.
          AND pa.fecha_de_inicio < '#{Date.new(2013, 2, 1) + meses.months}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion >= '#{Date.new(2013, 2, 1) + meses.months}'
          )
          -- Con una prestación durante el último año: total de activos con CEB por prestación.
          AND af.fecha_de_la_ultima_prestacion >= '#{Date.new(2012, 1, 1) + meses.months}'
          AND af.fecha_de_la_ultima_prestacion < '#{Date.new(2013, 2, 1) + meses.months}'
          -- Que no estén duplicados
          AND (af.motivo_de_la_baja_id IS NULL OR af.motivo_de_la_baja_id NOT IN (14, 51, 81, 82, 83))
          -- Con fecha de inscripción anterior al mes evaluado
          AND af.fecha_de_inscripcion < '#{Date.new(2013, 2, 1) + meses.months}'
        ORDER BY 2 DESC;
    "
  )
  archivo.puts I18n::localize(Date.new(2013, 1, 1) + meses.months, :format => :month_and_year)
  archivo.puts ar_result.columns.join("\t")
  ar_result.rows.each do |row|
    archivo.puts row.join("\t")
  end
end

archivo.close
