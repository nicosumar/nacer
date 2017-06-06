
class ExtraerBajas

    def extraer_bajas(periodo)

      archivo = File.open("vendor/data/Bajas_#{periodo}.csv", 'w')
      #archivo = File.open("'"vendor/data/Bajas_2017-02.csv', 'w')

      ActiveRecord::Base.transaction do
        UnidadDeAltaDeDatos.find(:all).each do |u|
          resultado = ActiveRecord::Base.connection.exec_query "
            SELECT
              'uad_#{u.codigo}'::text AS \"CodigoDeUAD\",
              n1.clave_de_beneficiario AS \"ClaveDeBeneficiario\",
              t1.codigo AS \"TipoDeDocumento\",
              c1.codigo AS \"ClaseDeDocumento\",
              n1.numero_de_documento AS \"NumeroDeDocumento\",
              n1.apellido AS \"Apellido\",
              n1.nombre AS \"Nombre\",
              n1.fecha_de_nacimiento AS \"FechaDeNacimiento\",
              n1.nombre_del_agente_inscriptor AS \"SolicitadaPor\",

              coalesce (mbb.nombre , REGEXP_REPLACE(COALESCE(n1.observaciones_generales, ''), E'\\r\\n', '~', 'g') ) AS \"MotivoDeBaja\",
           
              '1'::text AS \"DarDeBaja\",
              coalesce (mbb.id,0) as \"motivo_baja_beneficiario_id\" 
            FROM
              uad_#{u.codigo}.novedades_de_los_afiliados n1
              LEFT JOIN tipos_de_documentos t1 ON (n1.tipo_de_documento_id = t1.id)
              LEFT JOIN clases_de_documentos c1 ON (n1.clase_de_documento_id = c1.id)
              LEFT join motivos_bajas_beneficiarios mbb ON (n1.motivo_baja_beneficiario_id = mbb.id)
            WHERE
              n1.tipo_de_novedad_id = '2'
              AND n1.estado_de_la_novedad_id = '2';
          "

          if resultado.rows.size > 0
            resultado.rows.each do |r|
              archivo.puts r.join("\t")
            end
            ActiveRecord::Base.connection.exec_query "
              SET search_path TO uad_#{u.codigo}, public;
            "
            ActiveRecord::Base.connection.exec_query "
              UPDATE uad_#{u.codigo}.novedades_de_los_afiliados
                SET estado_de_la_novedad_id = '3'
                WHERE
                  tipo_de_novedad_id = '2'
                  AND estado_de_la_novedad_id = '2';
            "
          end
        end
      end

      archivo.close
    end

end