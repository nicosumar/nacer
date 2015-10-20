load 'lib/tasks/registro_masivo_de_prestaciones.rb'

uads_a_procesar = ActiveRecord::Base.connection.exec_query <<-SQL
                    SELECT DISTINCT
                        uad.id "unidad_de_alta_de_datos_id"
                      FROM
                        vista_global_de_prestaciones_brindadas vgpb
                        JOIN unidades_de_alta_de_datos uad ON ('uad_' || uad.codigo = vgpb.esquema)
                        JOIN afiliados a ON (a.clave_de_beneficiario = vgpb.clave_de_beneficiario)
                        JOIN clases_de_documentos cd ON (a.clase_de_documento_id = cd.id)
                        JOIN tipos_de_documentos td ON (a.tipo_de_documento_id = td.id)
                        JOIN prestaciones p ON vgpb.prestacion_id = p.id
                        JOIN diagnosticos d ON vgpb.diagnostico_id = d.id
                      WHERE
                        vgpb.fecha_de_la_prestacion >= '2015-07-01'
                        AND vgpb.estado_de_la_prestacion_id IN (2, 3, 7)
                        AND NOT p.activa
                      ORDER BY 1 DESC;
                    SQL

uads_a_procesar.each do |uad|
  efectores_a_procesar =  ActiveRecord::Base.connection.exec_query <<-SQL
                            SELECT DISTINCT
                              vgpb.efector_id "efector_id"
                            FROM
                              vista_global_de_prestaciones_brindadas vgpb
                              JOIN unidades_de_alta_de_datos uad ON ('uad_' || uad.codigo = vgpb.esquema)
                              JOIN afiliados a ON (a.clave_de_beneficiario = vgpb.clave_de_beneficiario)
                              JOIN clases_de_documentos cd ON (a.clase_de_documento_id = cd.id)
                              JOIN tipos_de_documentos td ON (a.tipo_de_documento_id = td.id)
                              JOIN prestaciones p ON vgpb.prestacion_id = p.id
                              JOIN diagnosticos d ON vgpb.diagnostico_id = d.id
                            WHERE
                              vgpb.fecha_de_la_prestacion >= '2015-07-01'
                              AND vgpb.estado_de_la_prestacion_id IN (2, 3, 7)
                              AND NOT p.activa
                              AND uad.id = '#{uad["unidad_de_alta_de_datos_id"]}'
                            ORDER BY 1;
                          SQL
  efectores_a_procesar.each do |efector|
    archivo = File.open("lib/tasks/datos/#{uad['unidad_de_alta_de_datos_id']}_#{efector['efector_id']}.csv", 'w')

    prestaciones_a_procesar = ActiveRecord::Base.connection.exec_query <<-SQL
                                SELECT
                                    vgpb.id "prestacion_brindada_id",
                                    vgpb.fecha_de_la_prestacion,
                                    vgpb.clave_de_beneficiario,
                                    a.apellido,
                                    a.nombre,
                                    cd.codigo "clase_de_documento",
                                    td.codigo "tipo_de_documento",
                                    a.numero_de_documento,
                                    vgpb.historia_clinica,
                                    p.codigo || d.codigo "codigo_de_prestacion"
                                  FROM
                                    vista_global_de_prestaciones_brindadas vgpb
                                    JOIN unidades_de_alta_de_datos uad ON ('uad_' || uad.codigo = vgpb.esquema)
                                    JOIN afiliados a ON (a.clave_de_beneficiario = vgpb.clave_de_beneficiario)
                                    JOIN clases_de_documentos cd ON (a.clase_de_documento_id = cd.id)
                                    JOIN tipos_de_documentos td ON (a.tipo_de_documento_id = td.id)
                                    JOIN prestaciones p ON vgpb.prestacion_id = p.id
                                    JOIN diagnosticos d ON vgpb.diagnostico_id = d.id
                                  WHERE
                                    vgpb.fecha_de_la_prestacion >= '2015-07-01'
                                    AND vgpb.estado_de_la_prestacion_id IN (2, 3, 7)
                                    AND NOT p.activa
                                    AND uad.id = #{uad["unidad_de_alta_de_datos_id"]}
                                    AND vgpb.efector_id = #{efector["efector_id"]}
                                  ORDER BY 1, 2, 3;
                              SQL

    prestaciones_a_procesar.each do |fila|
      archivo.puts fila.except("prestacion_brindada_id").values.map{|v| v.gsub("\t", "")}.join("\t")
    end # Prestaciones a procesar

    archivo.close

    proc = RegistroMasivoDePrestaciones.new
    proc.procesar(
      "lib/tasks/datos/#{uad['unidad_de_alta_de_datos_id']}_#{efector['efector_id']}.csv",
      UnidadDeAltaDeDatos.find(uad["unidad_de_alta_de_datos_id"]),
      Efector.find(efector["efector_id"])
    )

  end # Efectores a procesar

end # Unidades de alta de datos a procesar
