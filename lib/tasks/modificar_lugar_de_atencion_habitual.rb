# Trabajamos sobre la UAD de la UGSP
ActiveRecord::Base::connection.execute("SET search_path TO uad_006, public;")

prestaciones_ids = Prestacion.where(:modifica_lugar_de_atencion => true).collect{|p| p.id}.join(",")

# Primer búsqueda igual a la implementada por la carga de prestaciones.
Afiliado.joins(:prestacion_ceb).where("\"prestaciones\".\"modifica_lugar_de_atencion\" AND \"afiliados\".\"efector_ceb_id\" <> \"afiliados\".\"lugar_de_atencion_habitual_id\"").each do |afiliado|

  # Verificar el historial de prestaciones de este beneficiario. Si en el último año no registra prestaciones de este mismo tipo
  # que hayan sido brindadas por el efector de atención habitual, se genera automáticamente una modificación de datos que cambia
  # el lugar de atención habitual por este efector que brindó la prestación.
  if VistaGlobalDePrestacionBrindada.where("
      clave_de_beneficiario = '#{afiliado.clave_de_beneficiario}'
      AND fecha_de_la_prestacion > '#{(afiliado.fecha_de_la_ultima_prestacion - 1.year).strftime("%Y-%m-%d")}'
      AND prestacion_id IN (#{prestaciones_ids})
      AND efector_id = #{afiliado.lugar_de_atencion_habitual_id}
      AND estado_de_la_prestacion_id NOT IN (10, 11)
    ").size == 0 then
    novedad = NovedadDelAfiliado.new
    novedad.copiar_atributos_del_afiliado(afiliado)
    novedad.tipo_de_novedad_id = 3
    novedad.categoria_de_afiliado_id = novedad.categorizar
    novedad.apellido = novedad.apellido.mb_chars.upcase.to_s
    novedad.nombre = novedad.nombre.mb_chars.upcase.to_s
    novedad.generar_advertencias
    novedad.creator_id = 1
    novedad.updater_id = 1
    if novedad.advertencias && novedad.advertencias.size > 0
      novedad.estado_de_la_novedad_id = 1
    else
      novedad.estado_de_la_novedad_id = 2
    end
    novedad.lugar_de_atencion_habitual_id = afiliado.efector_ceb_id
    novedad.fecha_de_la_novedad = Date.new(2014, 5, 31)
    novedad.centro_de_inscripcion_id = 316
    novedad.save
  end

end

prestaciones_ids =
  ActiveRecord::Base.connection.exec_query("
    SELECT DISTINCT prestacion_ceb_id
      FROM afiliados
      ORDER BY prestacion_ceb_id;
  ").rows.collect{|r| r[0].to_i}.join(",")

# Segunda búsqueda (el resto de las que dan CEB pero no modifican el lugar de atención), modificamos si no encontramos ninguna
# otra que otorgue CEB en el historial que pertenezca al efector de atención habitual
Afiliado.joins(:prestacion_ceb).where("NOT \"prestaciones\".\"modifica_lugar_de_atencion\" AND \"afiliados\".\"efector_ceb_id\" <> \"afiliados\".\"lugar_de_atencion_habitual_id\"").each do |afiliado|

  # Verificar el historial de prestaciones de este beneficiario. Si en el último año no registra prestaciones de este mismo tipo
  # que hayan sido brindadas por el efector de atención habitual, se genera automáticamente una modificación de datos que cambia
  # el lugar de atención habitual por este efector que brindó la prestación.
  if VistaGlobalDePrestacionBrindada.where("
      clave_de_beneficiario = '#{afiliado.clave_de_beneficiario}'
      AND fecha_de_la_prestacion > '#{(afiliado.fecha_de_la_ultima_prestacion - 1.year).strftime("%Y-%m-%d")}'
      AND prestacion_id IN (#{prestaciones_ids})
      AND efector_id = #{afiliado.lugar_de_atencion_habitual_id}
      AND estado_de_la_prestacion_id NOT IN (10, 11)
    ").size == 0 then
    novedad = NovedadDelAfiliado.new
    novedad.copiar_atributos_del_afiliado(afiliado)
    novedad.tipo_de_novedad_id = 3
    novedad.categoria_de_afiliado_id = novedad.categorizar
    novedad.apellido = novedad.apellido.mb_chars.upcase.to_s
    novedad.nombre = novedad.nombre.mb_chars.upcase.to_s
    novedad.generar_advertencias
    novedad.creator_id = 1
    novedad.updater_id = 1
    if novedad.advertencias && novedad.advertencias.size > 0
      novedad.estado_de_la_novedad_id = 1
    else
      novedad.estado_de_la_novedad_id = 2
    end
    novedad.lugar_de_atencion_habitual_id = afiliado.efector_ceb_id
    novedad.fecha_de_la_novedad = Date.new(2014, 5, 31)
    novedad.centro_de_inscripcion_id = 316
    novedad.save
  end

end
