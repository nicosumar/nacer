# ~~ encoding: utf-8 ~~

fecha = Date.new(2014, 1, 1)
archivo = File.open('lib/tasks/datos/Estimaciones_CA_2015.csv', "w")
serie_menores_de_6 = {:activos => [], :ceb => [], :ceb_prestacion => []}
serie_6_a_9 = {:activos => [], :ceb => [], :ceb_prestacion => []}
serie_adolescentes = {:activos => [], :ceb => [], :ceb_prestacion => []}
serie_mujeres = {:activos => [], :ceb => [], :ceb_prestacion => []}
serie_hombres = {:activos => [], :ceb => [], :ceb_prestacion => []}
i = 0

while fecha <= Date.new(2015, 9, 1) do

  serie_menores_de_6[:activos][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_actividad pa
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        -- Filtro para grupo 0-5 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '6 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
        );
    ").rows[0][0].to_i

  serie_6_a_9[:activos][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_actividad pa
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        -- Filtro para grupo 6-9 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '10 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '6 years')
        );
    ").rows[0][0].to_i

  serie_adolescentes[:activos][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_actividad pa
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        -- Filtro para grupo 10-19 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '20 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '10 years')
        );
    ").rows[0][0].to_i

  serie_mujeres[:activos][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_actividad pa
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        -- Filtro para mujeres 20-64 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
          AND a.sexo_id = 1
        );
    ").rows[0][0].to_i

  serie_hombres[:activos][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_actividad pa
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        -- Filtro para hombres 20-64 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
          AND a.sexo_id = 2
        );
    ").rows[0][0].to_i

  serie_menores_de_6[:ceb][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_cobertura pc
        JOIN periodos_de_actividad pa ON pc.afiliado_id = pa.afiliado_id
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pc.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pc.fecha_de_finalizacion IS NULL
          OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        -- Filtro para grupo 0-5 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '6 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
        );
    ").rows[0][0].to_i

  serie_6_a_9[:ceb][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_cobertura pc
        JOIN periodos_de_actividad pa ON pc.afiliado_id = pa.afiliado_id
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pc.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pc.fecha_de_finalizacion IS NULL
          OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        -- Filtro para grupo 6-9 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '10 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '6 years')
        );
    ").rows[0][0].to_i

  serie_adolescentes[:ceb][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_cobertura pc
        JOIN periodos_de_actividad pa ON pc.afiliado_id = pa.afiliado_id
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pc.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pc.fecha_de_finalizacion IS NULL
          OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        -- Filtro para grupo 10-19 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '20 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '10 years')
        );
    ").rows[0][0].to_i

  serie_mujeres[:ceb][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_cobertura pc
        JOIN periodos_de_actividad pa ON pc.afiliado_id = pa.afiliado_id
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pc.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pc.fecha_de_finalizacion IS NULL
          OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        -- Filtro para mujeres 20-64 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
          AND a.sexo_id = 1
        );
    ").rows[0][0].to_i

  serie_hombres[:ceb][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_cobertura pc
        JOIN periodos_de_actividad pa ON pc.afiliado_id = pa.afiliado_id
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pc.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pc.fecha_de_finalizacion IS NULL
          OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        -- Filtro para hombres 20-64 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
          AND a.sexo_id = 2
        );
    ").rows[0][0].to_i

  serie_menores_de_6[:ceb_prestacion][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_cobertura pc
        JOIN periodos_de_actividad pa ON pc.afiliado_id = pa.afiliado_id
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pc.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pc.fecha_de_finalizacion IS NULL
          OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        AND (
          -- Considero CEB por prestación la que tiene una prestación cuya fecha se incluye en el periodo de un año
          -- al mes evaluado, o bien el afiliado que tiene más de ocho meses desde su inscripción y posee un periodo de CEB
          -- ESTO NO ESTA BIEN, debo modificar el proceso de actualización del padrón y la tabla de periodos de CEB para registrar
          -- los cambios en la fecha de la última prestacion y la prestación de CEB.
          a.fecha_de_la_ultima_prestacion >= ('#{fecha.iso8601}'::date - INTERVAL '1 year')
          OR (a.fecha_de_inscripcion + INTERVAL '8 months') < '#{fecha.iso8601}'::date
        )
        -- Filtro para grupo 0-5 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '6 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
        );
    ").rows[0][0].to_i

  serie_6_a_9[:ceb_prestacion][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_cobertura pc
        JOIN periodos_de_actividad pa ON pc.afiliado_id = pa.afiliado_id
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pc.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pc.fecha_de_finalizacion IS NULL
          OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        AND (
          -- Considero CEB por prestación la que tiene una prestación cuya fecha se incluye en el periodo de un año
          -- al mes evaluado, o bien el afiliado que tiene más de ocho meses desde su inscripción y posee un periodo de CEB
          -- ESTO NO ESTA BIEN, debo modificar el proceso de actualización del padrón y la tabla de periodos de CEB para registrar
          -- los cambios en la fecha de la última prestacion y la prestación de CEB.
          a.fecha_de_la_ultima_prestacion >= ('#{fecha.iso8601}'::date - INTERVAL '1 year')
          OR (a.fecha_de_inscripcion + INTERVAL '8 months') < '#{fecha.iso8601}'::date
        )
        -- Filtro para grupo 6-9 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '10 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '6 years')
        );
    ").rows[0][0].to_i

  serie_adolescentes[:ceb_prestacion][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_cobertura pc
        JOIN periodos_de_actividad pa ON pc.afiliado_id = pa.afiliado_id
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pc.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pc.fecha_de_finalizacion IS NULL
          OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        AND (
          -- Considero CEB por prestación la que tiene una prestación cuya fecha se incluye en el periodo de un año
          -- al mes evaluado, o bien el afiliado que tiene más de ocho meses desde su inscripción y posee un periodo de CEB
          -- ESTO NO ESTA BIEN, debo modificar el proceso de actualización del padrón y la tabla de periodos de CEB para registrar
          -- los cambios en la fecha de la última prestacion y la prestación de CEB.
          a.fecha_de_la_ultima_prestacion >= ('#{fecha.iso8601}'::date - INTERVAL '1 year')
          OR (a.fecha_de_inscripcion + INTERVAL '8 months') < '#{fecha.iso8601}'::date
        )
        -- Filtro para grupo 10-19 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '20 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '10 years')
        );
    ").rows[0][0].to_i

  serie_mujeres[:ceb_prestacion][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_cobertura pc
        JOIN periodos_de_actividad pa ON pc.afiliado_id = pa.afiliado_id
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pc.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pc.fecha_de_finalizacion IS NULL
          OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        AND (
          -- Considero CEB por prestación la que tiene una prestación cuya fecha se incluye en el periodo de un año
          -- al mes evaluado, o bien el afiliado que tiene más de ocho meses desde su inscripción y posee un periodo de CEB
          -- ESTO NO ESTA BIEN, debo modificar el proceso de actualización del padrón y la tabla de periodos de CEB para registrar
          -- los cambios en la fecha de la última prestacion y la prestación de CEB.
          a.fecha_de_la_ultima_prestacion >= ('#{fecha.iso8601}'::date - INTERVAL '1 year')
          OR (a.fecha_de_inscripcion + INTERVAL '8 months') < '#{fecha.iso8601}'::date
        )
        -- Filtro para hombres 20-64 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
          AND a.sexo_id = 2
        );
    ").rows[0][0].to_i

  serie_mujeres[:ceb_prestacion][i] = ActiveRecord::Base.connection.exec_query("
    -- Afiliados activos (por grupo etario)
    SELECT COUNT(*)
      FROM
        periodos_de_cobertura pc
        JOIN periodos_de_actividad pa ON pc.afiliado_id = pa.afiliado_id
        JOIN afiliados a ON a.afiliado_id = pa.afiliado_id
      WHERE
        pc.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pc.fecha_de_finalizacion IS NULL
          OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND pa.fecha_de_inicio <= '#{fecha.iso8601}'
        AND (
          pa.fecha_de_finalizacion IS NULL
          OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
        )
        AND a.fecha_de_nacimiento IS NOT NULL
        AND a.sexo_id IS NOT NULL
        AND (
          -- Considero CEB por prestación la que tiene una prestación cuya fecha se incluye en el periodo de un año
          -- al mes evaluado, o bien el afiliado que tiene más de ocho meses desde su inscripción y posee un periodo de CEB
          -- ESTO NO ESTA BIEN, debo modificar el proceso de actualización del padrón y la tabla de periodos de CEB para registrar
          -- los cambios en la fecha de la última prestacion y la prestación de CEB.
          a.fecha_de_la_ultima_prestacion >= ('#{fecha.iso8601}'::date - INTERVAL '1 year')
          OR (a.fecha_de_inscripcion + INTERVAL '8 months') < '#{fecha.iso8601}'::date
        )
        -- Filtro para mujeres 20-64 años
        AND (
          a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
          AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
          AND a.sexo_id = 1
        );
    ").rows[0][0].to_i

  fecha += 1.month
  i += 1

end

archivo.puts "Menores de 6 años"
archivo.puts "Activos\t" + serie_menores_de_6[:activos].join("\t")
archivo.puts "Con CEB\t" + serie_menores_de_6[:ceb].join("\t")
archivo.puts "Con CEB por prestación\t" + serie_menores_de_6[:ceb_prestacion].join("\t")
archivo.puts ""

archivo.puts "De 6 a 9 años"
archivo.puts "Activos\t" + serie_6_a_9[:activos].join("\t")
archivo.puts "Con CEB\t" + serie_6_a_9[:ceb].join("\t")
archivo.puts "Con CEB por prestación\t" + serie_6_a_9[:ceb_prestacion].join("\t")
archivo.puts ""

archivo.puts "Adolescentes"
archivo.puts "Activos\t" + serie_adolescentes[:activos].join("\t")
archivo.puts "Con CEB\t" + serie_adolescentes[:ceb].join("\t")
archivo.puts "Con CEB por prestación\t" + serie_adolescentes[:ceb_prestacion].join("\t")
archivo.puts ""

archivo.puts "Mujeres"
archivo.puts "Activas\t" + serie_mujeres[:activos].join("\t")
archivo.puts "Con CEB\t" + serie_mujeres[:ceb].join("\t")
archivo.puts "Con CEB por prestación\t" + serie_mujeres[:ceb_prestacion].join("\t")
archivo.puts ""

archivo.puts "Hombres"
archivo.puts "Activos\t" + serie_hombres[:activos].join("\t")
archivo.puts "Con CEB\t" + serie_hombres[:ceb].join("\t")
archivo.puts "Con CEB por prestación\t" + serie_hombres[:ceb_prestacion].join("\t")
archivo.puts ""

archivo.close
