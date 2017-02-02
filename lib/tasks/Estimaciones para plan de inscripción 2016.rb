# ~~ encoding: utf-8 ~~

fecha = Date.new(2014, 10, 1)
archivo = File.open('lib/tasks/datos/Estimaciones_CA_2016.csv', "w")
serie_menores_de_6 = {:activos => [], :ceb => [], :altas_actividad => [], :altas_ceb => [], :bajas_actividad => [], :bajas_ceb => []}
serie_6_a_9 = {:activos => [], :ceb => [], :altas_actividad => [], :altas_ceb => [], :bajas_actividad => [], :bajas_ceb => []}
serie_adolescentes = {:activos => [], :ceb => [], :altas_actividad => [], :altas_ceb => [], :bajas_actividad => [], :bajas_ceb => []}
serie_mujeres = {:activos => [], :ceb => [], :altas_actividad => [], :altas_ceb => [], :bajas_actividad => [], :bajas_ceb => []}
serie_hombres = {:activos => [], :ceb => [], :altas_actividad => [], :altas_ceb => [], :bajas_actividad => [], :bajas_ceb => []}
i = 0

while fecha <= Date.new(2015, 9, 1) do

  serie_menores_de_6[:activos][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Afiliados activos (por grupo etario)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON pa.afiliado_id = a.afiliado_id
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Filtro para grupo 0-5 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '6 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          );
      SQL
    ).rows[0][0].to_i

  serie_6_a_9[:activos][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Afiliados activos (por grupo etario)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON pa.afiliado_id = a.afiliado_id
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Filtro para grupo 6 a 9 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '10 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '6 years')
          );
      SQL
    ).rows[0][0].to_i

  serie_adolescentes[:activos][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Afiliados activos (por grupo etario)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON pa.afiliado_id = a.afiliado_id
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Filtro para grupo 10 a 19 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '10 years')
          );
      SQL
    ).rows[0][0].to_i

  serie_mujeres[:activos][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Afiliados activos (por grupo etario)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON pa.afiliado_id = a.afiliado_id
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
      SQL
    ).rows[0][0].to_i

  serie_hombres[:activos][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Afiliados activos (por grupo etario)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON pa.afiliado_id = a.afiliado_id
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
      SQL
    ).rows[0][0].to_i

  serie_menores_de_6[:ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Afiliados activos con CEB (por grupo etario)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON pa.afiliado_id = a.afiliado_id
          JOIN periodos_de_cobertura pc ON pc.afiliado_id = a.afiliado_id
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Filtro para grupo 0-5 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '6 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          );
        SQL
      ).rows[0][0].to_i

  serie_6_a_9[:ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Afiliados activos con CEB (por grupo etario)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON pa.afiliado_id = a.afiliado_id
          JOIN periodos_de_cobertura pc ON pc.afiliado_id = a.afiliado_id
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Filtro para grupo 6-9 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '10 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '6 years')
          );
      SQL
    ).rows[0][0].to_i

  serie_adolescentes[:ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Afiliados activos con CEB (por grupo etario)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON pa.afiliado_id = a.afiliado_id
          JOIN periodos_de_cobertura pc ON pc.afiliado_id = a.afiliado_id
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Filtro para grupo 10-19 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '10 years')
          );
        SQL
      ).rows[0][0].to_i

  serie_mujeres[:ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Afiliados activos con CEB (por grupo etario)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON pa.afiliado_id = a.afiliado_id
          JOIN periodos_de_cobertura pc ON pc.afiliado_id = a.afiliado_id
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          AND a.sexo_id IS NOT NULL
          -- Filtro para mujeres 20-64 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.sexo_id = 1
          );
      SQL
    ).rows[0][0].to_i

  serie_hombres[:ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Afiliados activos con CEB (por grupo etario)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON pa.afiliado_id = a.afiliado_id
          JOIN periodos_de_cobertura pc ON pc.afiliado_id = a.afiliado_id
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          AND a.sexo_id IS NOT NULL
          -- Filtro para hombres 20-64 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.sexo_id = 2
          );
      SQL
    ).rows[0][0].to_i

  serie_menores_de_6[:altas_actividad][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Altas por activación de beneficiarios con CEB (por inscripción o reactivación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Únicamente activaciones de ese mes
          AND pa.fecha_de_inicio >= '#{fecha.iso8601}'::date
          AND pa.fecha_de_inicio < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          -- Filtro para grupo 0-5 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '6 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          );
      SQL
    ).rows[0][0].to_i

  serie_6_a_9[:altas_actividad][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Altas por activación de beneficiarios con CEB (por inscripción o reactivación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Únicamente activaciones de ese mes
          AND pa.fecha_de_inicio >= '#{fecha.iso8601}'::date
          AND pa.fecha_de_inicio < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          -- Filtro para grupo 6-9 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '10 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '6 years')
          );
      SQL
    ).rows[0][0].to_i

  serie_adolescentes[:altas_actividad][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Altas por activación de beneficiarios con CEB (por inscripción o reactivación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Únicamente activaciones de ese mes
          AND pa.fecha_de_inicio >= '#{fecha.iso8601}'::date
          AND pa.fecha_de_inicio < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          -- Filtro para grupo 10-19 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '10 years')
          );
      SQL
    ).rows[0][0].to_i

  serie_mujeres[:altas_actividad][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Altas por activación de beneficiarios con CEB (por inscripción o reactivación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          AND a.sexo_id IS NOT NULL
          -- Únicamente activaciones de ese mes
          AND pa.fecha_de_inicio >= '#{fecha.iso8601}'::date
          AND pa.fecha_de_inicio < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          -- Filtro para mujeres 20-64 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.sexo_id = 1
          );
      SQL
    ).rows[0][0].to_i

  serie_hombres[:altas_actividad][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Altas por activación de beneficiarios con CEB (por inscripción o reactivación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          AND a.sexo_id IS NOT NULL
          -- Únicamente activaciones de ese mes
          AND pa.fecha_de_inicio >= '#{fecha.iso8601}'::date
          AND pa.fecha_de_inicio < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          -- Filtro para hombres 20-64 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.sexo_id = 2
          );
      SQL
    ).rows[0][0].to_i

  serie_menores_de_6[:altas_ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Altas por recuperación de CEB en beneficiarios activos (por prestación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Únicamente recuperación de CEB de ese mes
          AND pc.fecha_de_inicio >= '#{fecha.iso8601}'::date
          AND pc.fecha_de_inicio < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          -- Filtro para grupo 0-5 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '6 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          );
      SQL
    ).rows[0][0].to_i

  serie_6_a_9[:altas_ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Altas por recuperación de CEB en beneficiarios activos (por prestación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Únicamente recuperación de CEB de ese mes
          AND pc.fecha_de_inicio >= '#{fecha.iso8601}'::date
          AND pc.fecha_de_inicio < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          -- Filtro para grupo 6-9 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '10 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '6 years')
          );
      SQL
    ).rows[0][0].to_i

  serie_adolescentes[:altas_ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Altas por recuperación de CEB en beneficiarios activos (por prestación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Únicamente recuperación de CEB de ese mes
          AND pc.fecha_de_inicio >= '#{fecha.iso8601}'::date
          AND pc.fecha_de_inicio < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          -- Filtro para grupo 10-19 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '10 years')
          );
      SQL
    ).rows[0][0].to_i

  serie_mujeres[:altas_ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Altas por recuperación de CEB en beneficiarios activos (por prestación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          AND a.sexo_id IS NOT NULL
          -- Únicamente recuperación de CEB de ese mes
          AND pc.fecha_de_inicio >= '#{fecha.iso8601}'::date
          AND pc.fecha_de_inicio < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          -- Filtro para mujeres 20-64 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.sexo_id = 1
          );
      SQL
    ).rows[0][0].to_i

  serie_hombres[:altas_ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Altas por recuperación de CEB en beneficiarios activos (por prestación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          AND a.sexo_id IS NOT NULL
          -- Únicamente recuperación de CEB de ese mes
          AND pc.fecha_de_inicio >= '#{fecha.iso8601}'::date
          AND pc.fecha_de_inicio < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          -- Filtro para hombres 20-64 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.sexo_id = 2
          );
      SQL
    ).rows[0][0].to_i

  serie_menores_de_6[:bajas_actividad][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Bajas por pase a inactividad de beneficiarios con CEB (por cobertura de la seguridad social o depuración del padrón)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Únicamente inactivaciones de ese mes
          AND pa.fecha_de_finalizacion = '#{fecha.iso8601}'::date
          -- Filtro para grupo 0-5 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '6 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          );
      SQL
    ).rows[0][0].to_i

  serie_6_a_9[:bajas_actividad][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Bajas por pase a inactividad de beneficiarios con CEB (por cobertura de la seguridad social o depuración del padrón)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Únicamente inactivaciones de ese mes
          AND pa.fecha_de_finalizacion = '#{fecha.iso8601}'::date
          -- Filtro para grupo 6-9 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '10 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '6 years')
          );
      SQL
    ).rows[0][0].to_i

  serie_adolescentes[:bajas_actividad][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Bajas por pase a inactividad de beneficiarios con CEB (por cobertura de la seguridad social o depuración del padrón)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Únicamente inactivaciones de ese mes
          AND pa.fecha_de_finalizacion = '#{fecha.iso8601}'::date
          -- Filtro para grupo 10-19 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '10 years')
          );
      SQL
    ).rows[0][0].to_i

  serie_mujeres[:bajas_actividad][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Bajas por pase a inactividad de beneficiarios con CEB (por cobertura de la seguridad social o depuración del padrón)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          AND a.sexo_id IS NOT NULL
          -- Únicamente inactivaciones de ese mes
          AND pa.fecha_de_finalizacion = '#{fecha.iso8601}'::date
          -- Filtro para mujeres 20-64 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.sexo_id = 1
          );
      SQL
    ).rows[0][0].to_i

  serie_hombres[:bajas_actividad][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Bajas por pase a inactividad de beneficiarios con CEB (por cobertura de la seguridad social o depuración del padrón)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pc.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pc.fecha_de_finalizacion IS NULL
            OR pc.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          AND a.sexo_id IS NOT NULL
          -- Únicamente inactivaciones de ese mes
          AND pa.fecha_de_finalizacion = '#{fecha.iso8601}'::date
          -- Filtro para hombres 20-64 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.sexo_id = 1
          );
      SQL
    ).rows[0][0].to_i

  serie_menores_de_6[:bajas_ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Bajas por vencimiento de CEB en beneficiarios activos (por inscripción o prestación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Únicamente vencimientos de CEB de ese mes
          AND pc.fecha_de_finalizacion = '#{fecha.iso8601}'::date
          -- Filtro para grupo 0-5 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '6 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date + INTERVAL '1 month')
          );
      SQL
    ).rows[0][0].to_i

  serie_6_a_9[:bajas_ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Bajas por vencimiento de CEB en beneficiarios activos (por inscripción o prestación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Únicamente vencimientos de CEB de ese mes
          AND pc.fecha_de_finalizacion = '#{fecha.iso8601}'::date
          -- Filtro para grupo 6-9 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '10 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '6 years')
          );
      SQL
    ).rows[0][0].to_i

  serie_adolescentes[:bajas_ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Bajas por vencimiento de CEB en beneficiarios activos (por inscripción o prestación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          -- Únicamente vencimientos de CEB de ese mes
          AND pc.fecha_de_finalizacion = '#{fecha.iso8601}'::date
          -- Filtro para grupo 10-19 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '10 years')
          );
      SQL
    ).rows[0][0].to_i

  serie_mujeres[:bajas_ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Bajas por vencimiento de CEB en beneficiarios activos (por inscripción o prestación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          AND a.sexo_id IS NOT NULL
          -- Únicamente vencimientos de CEB de ese mes
          AND pc.fecha_de_finalizacion = '#{fecha.iso8601}'::date
          -- Filtro para mujeres 20-64 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.sexo_id = 1
          );
      SQL
    ).rows[0][0].to_i

  serie_hombres[:bajas_ceb][i] = ActiveRecord::Base.connection.exec_query( <<-SQL
      -- Bajas por vencimiento de CEB en beneficiarios activos (por inscripción o prestación)
      SELECT COUNT(DISTINCT a.afiliado_id)
        FROM
          afiliados a
          JOIN periodos_de_actividad pa ON (pa.afiliado_id = a.afiliado_id)
          JOIN periodos_de_cobertura pc ON (pc.afiliado_id = a.afiliado_id)
        WHERE
          pa.fecha_de_inicio <= '#{fecha.iso8601}'
          AND (
            pa.fecha_de_finalizacion IS NULL
            OR pa.fecha_de_finalizacion > '#{fecha.iso8601}'
          )
          AND a.fecha_de_nacimiento IS NOT NULL
          AND a.sexo_id IS NOT NULL
          -- Únicamente vencimientos de CEB de ese mes
          AND pc.fecha_de_finalizacion = '#{fecha.iso8601}'::date
          -- Filtro para hombres 20-64 años
          AND (
            a.fecha_de_nacimiento >= ('#{fecha.iso8601}'::date - INTERVAL '65 years')
            AND a.fecha_de_nacimiento < ('#{fecha.iso8601}'::date - INTERVAL '20 years')
            AND a.sexo_id = 2
          );
      SQL
    ).rows[0][0].to_i

  fecha += 1.month
  i += 1

end

archivo.puts "Menores de 6 años"
archivo.puts "Activos\t" + serie_menores_de_6[:activos].join("\t")
archivo.puts "Con CEB\t" + serie_menores_de_6[:ceb].join("\t")
archivo.puts "Altas por activación\t" + serie_menores_de_6[:altas_actividad].join("\t")
archivo.puts "Altas por recuperación de CEB\t" + serie_menores_de_6[:altas_ceb].join("\t")
archivo.puts "Bajas por inactivación\t" + serie_menores_de_6[:bajas_actividad].join("\t")
archivo.puts "Bajas por vencimiento de CEB\t" + serie_menores_de_6[:bajas_ceb].join("\t")
archivo.puts ""

archivo.puts "De 6 a 9 años"
archivo.puts "Activos\t" + serie_6_a_9[:activos].join("\t")
archivo.puts "Con CEB\t" + serie_6_a_9[:ceb].join("\t")
archivo.puts "Altas por activación\t" + serie_6_a_9[:altas_actividad].join("\t")
archivo.puts "Altas por recuperación de CEB\t" + serie_6_a_9[:altas_ceb].join("\t")
archivo.puts "Bajas por inactivación\t" + serie_6_a_9[:bajas_actividad].join("\t")
archivo.puts "Bajas por vencimiento de CEB\t" + serie_6_a_9[:bajas_ceb].join("\t")
archivo.puts ""

archivo.puts "Adolescentes"
archivo.puts "Activos\t" + serie_adolescentes[:activos].join("\t")
archivo.puts "Con CEB\t" + serie_adolescentes[:ceb].join("\t")
archivo.puts "Altas por activación\t" + serie_adolescentes[:altas_actividad].join("\t")
archivo.puts "Altas por recuperación de CEB\t" + serie_adolescentes[:altas_ceb].join("\t")
archivo.puts "Bajas por inactivación\t" + serie_adolescentes[:bajas_actividad].join("\t")
archivo.puts "Bajas por vencimiento de CEB\t" + serie_adolescentes[:bajas_ceb].join("\t")
archivo.puts ""

archivo.puts "Mujeres"
archivo.puts "Activas\t" + serie_mujeres[:activos].join("\t")
archivo.puts "Con CEB\t" + serie_mujeres[:ceb].join("\t")
archivo.puts "Altas por activación\t" + serie_mujeres[:altas_actividad].join("\t")
archivo.puts "Altas por recuperación de CEB\t" + serie_mujeres[:altas_ceb].join("\t")
archivo.puts "Bajas por inactivación\t" + serie_mujeres[:bajas_actividad].join("\t")
archivo.puts "Bajas por vencimiento de CEB\t" + serie_mujeres[:bajas_ceb].join("\t")
archivo.puts ""

archivo.puts "Hombres"
archivo.puts "Activos\t" + serie_hombres[:activos].join("\t")
archivo.puts "Con CEB\t" + serie_hombres[:ceb].join("\t")
archivo.puts "Altas por activación\t" + serie_hombres[:altas_actividad].join("\t")
archivo.puts "Altas por recuperación de CEB\t" + serie_hombres[:altas_ceb].join("\t")
archivo.puts "Bajas por inactivación\t" + serie_hombres[:bajas_actividad].join("\t")
archivo.puts "Bajas por vencimiento de CEB\t" + serie_hombres[:bajas_ceb].join("\t")
archivo.puts ""

archivo.close
