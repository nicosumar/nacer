# -*- encoding : utf-8 -*-
class Periodo < ActiveRecord::Base

  belongs_to :tipo_periodo
  belongs_to :concepto_de_facturacion
  has_many :liquidaciones_sumar
  has_many :consolidados_sumar
  has_many :expedientes_sumar
  
  attr_accessible :fecha_cierre, :fecha_recepcion, :periodo, :tipo_periodo_id, :concepto_de_facturacion_id, :fecha_limite_prestaciones
  attr_accessible :dias_de_prestacion

  validates :fecha_cierre, presence: true
  validates :periodo, presence: true
  validates :tipo_periodo, presence: true

  def prestacion_html
  	"Nombre: #{self.periodo} Fecha de Cierre: #{self.fecha_cierre}
  	 Fecha de Recepción: #{self.fecha_recepcion}
  	 Tipo de periodo: #{self.tipo_periodo.descripcion}
  	"
  end

  # Este método devuelve el padrón de prestaciones que debe subirse al SIRGe para este periodo
  def padron_de_prestaciones_sirge
    # Buscamos todos los ID de prestaciones que requieren datos reportables para el SIRGe
    prestacion_ids =
      DatoReportableRequeridoSirge.select([:prestacion_id]).order(:id).
      map{|drrs| drrs.prestacion_id}.uniq

    selects = []
    prestacion_ids.each do |prestacion_id|
      # Obtenemos todos los datos reportables requeridos para esta prestación (entre 1 y 4)
      drrs =
        DatoReportableRequeridoSirge.includes(:dato_reportable_sirge).
        where(prestacion_id: prestacion_id, orden: 1).first
      drr1_id = drrs.present? ? drrs.dato_reportable_sirge.sirge_id : nil
      drr1_funcion = drrs.present? ? drrs.dato_reportable_sirge.funcion_de_transformacion : nil
      drrs =
        DatoReportableRequeridoSirge.includes(:dato_reportable_sirge).
        where(prestacion_id: prestacion_id, orden: 2).first
      drr2_id = drrs.present? ? drrs.dato_reportable_sirge.sirge_id : nil
      drr2_funcion = drrs.present? ? drrs.dato_reportable_sirge.funcion_de_transformacion : nil
      drrs = 
        DatoReportableRequeridoSirge.includes(:dato_reportable_sirge).
        where(prestacion_id: prestacion_id, orden: 3).first
      drr3_id = drrs.present? ? drrs.dato_reportable_sirge.sirge_id : nil
      drr3_funcion = drrs.present? ? drrs.dato_reportable_sirge.funcion_de_transformacion : nil
      drrs =
        DatoReportableRequeridoSirge.includes(:dato_reportable_sirge).
        where(prestacion_id: prestacion_id, orden: 4).first
      drr4_id = drrs.present? ? drrs.dato_reportable_sirge.sirge_id : nil
      drr4_funcion = drrs.present? ? drrs.dato_reportable_sirge.funcion_de_transformacion : nil

      # Generamos un SELECT para traer todos los registros que tienen este ID de prestación
      # con todos sus datos reportables completos
      selects << <<-SQL
          SELECT
              pl.id "prestacion_liquidada_id",
              #{drr1_id.present? ? drr1_id : "NULL"}::integer "id_dato_reportable1",
              #{drr1_funcion.present? ? drr1_funcion + "(pl.id)" : "NULL"}::varchar(255) "dato_reportable1",
              #{drr2_id.present? ? drr2_id : "NULL"}::integer "id_dato_reportable2",
              #{drr2_funcion.present? ? drr2_funcion + "(pl.id)" : "NULL"}::varchar(255) "dato_reportable2",
              #{drr3_id.present? ? drr3_id : "NULL"}::integer "id_dato_reportable3",
              #{drr3_funcion.present? ? drr3_funcion + "(pl.id)" : "NULL"}::varchar(255) "dato_reportable3",
              #{drr4_id.present? ? drr4_id : "NULL"}::integer "id_dato_reportable4",
              #{drr4_funcion.present? ? drr4_funcion + "(pl.id)" : "NULL"}::varchar(255) "dato_reportable4"
            FROM
              prestaciones_liquidadas pl
              INNER JOIN prestaciones_incluidas pi ON (pi.id = pl.prestacion_incluida_id)
              INNER JOIN liquidaciones_sumar ls ON ls.id = pl.liquidacion_id
            WHERE
              pl.estado_de_la_prestacion_liquidada_id IN (4,5,12)
              AND pi.prestacion_id = #{prestacion_id}
              AND ls.periodo_id = #{self.id}
        SQL
    end

    # Creamos una tabla temporal para guardar las prestaciones liquidadas con sus cuatro campos
    # de datos reportables completos
    ActiveRecord::Base.connection.execute(
     "DROP TABLE IF EXISTS datos_reportables_del_periodo; CREATE TEMPORARY TABLE datos_reportables_del_periodo AS (" + selects.join(" UNION ") + ");"
    )
byebug
    # Finalmente, ejecutar la consulta que devuelve los campos formateados de acuerdo con el
    # documento del diccionario de datos del SIRGe (e implementación de datos reportables
    # según DOIU 20).
    ActiveRecord::Base.connection.exec_query <<-SQL
      SELECT
          'A'::char(1) "operacion",
          'L'::char(1) "estado",
          REGEXP_REPLACE(lsc.numero_cuasifactura, '[ -]', '', 'g') "numero_comprobante",
          p.codigo || d.codigo "codigo_prestacion",
          NULL::char(3) "subcodigo_prestacion",
          sq.pl_monto::numeric(15, 2) "precio_unitario",
          sq.pl_fecha_de_la_prestacion "fecha_prestacion",
          (
            CASE
              WHEN sq.pl_clave_de_beneficiario IS NULL THEN
                '9999999999999999'::char(16)
              ELSE
                sq.pl_clave_de_beneficiario
              END
          ) "clave_beneficiario",
          (
            CASE
              WHEN sq.pl_clave_de_beneficiario IS NULL THEN
                'COM'::varchar(3)
              ELSE
                t.codigo::varchar(3)
              END
          ) "tipo_documento",
          (
            CASE
              WHEN sq.pl_clave_de_beneficiario IS NULL THEN
                'C'::char(1)
              ELSE
                c.codigo::char(1)
              END
          ) "clase_documento",
          a.numero_de_documento::varchar(14) "numero_documento",
          (
            CASE
              WHEN drp.dato_reportable1 IS NOT NULL THEN
                drp.id_dato_reportable1
              ELSE
                NULL::integer
            END
          ) "id_dato_reportable1",
          drp.dato_reportable1 "dato_reportable1",
          (
            CASE
              WHEN drp.dato_reportable2 IS NOT NULL THEN
                drp.id_dato_reportable2
              ELSE
                NULL::integer
            END
          ) "id_dato_reportable2",
          drp.dato_reportable2 "dato_reportable2",
          (
            CASE
              WHEN drp.dato_reportable3 IS NOT NULL THEN
                drp.id_dato_reportable3
              ELSE
                NULL::integer
            END
          ) "id_dato_reportable3",
          drp.dato_reportable3 "dato_reportable3",
          (
            CASE
              WHEN drp.dato_reportable4 IS NOT NULL THEN
                drp.id_dato_reportable4
              ELSE
                NULL::integer
            END
          ) "id_dato_reportable4",
          drp.dato_reportable4 "dato_reportable4",
          row_number() OVER (
            PARTITION BY
              sq.pl_efector_id,
              sq.pl_fecha_de_la_prestacion,
              p.codigo || d.codigo,
              sq.pl_clave_de_beneficiario
          ) "orden",
          e.cuie "efector"
        FROM
          (
            SELECT
                pl.efector_id "pl_efector_id",
                pl.fecha_de_la_prestacion "pl_fecha_de_la_prestacion",
                pi.prestacion_id "pi_prestacion_id",
                pl.diagnostico_id "pl_diagnostico_id",
                pl.clave_de_beneficiario "pl_clave_de_beneficiario",
                pl.monto "pl_monto",
                pl.id "pl_id"
              FROM
                prestaciones_liquidadas pl
                INNER JOIN prestaciones_incluidas pi ON (pi.id = pl.prestacion_incluida_id)
                INNER JOIN liquidaciones_sumar ls ON (ls.id = pl.liquidacion_id)
              WHERE
                pl.estado_de_la_prestacion_liquidada_id IN (4,5,12)
                AND ls.periodo_id = #{self.id}
              ORDER BY 1, 2, 3, 4, 5
          ) "sq"
          INNER JOIN efectores e ON (e.id = sq.pl_efector_id)
          INNER JOIN liquidaciones_sumar_cuasifacturas_detalles lscd ON (
            lscd.prestacion_liquidada_id = sq.pl_id
          )
          INNER JOIN liquidaciones_sumar_cuasifacturas lsc ON (
            lsc.id = lscd.liquidaciones_sumar_cuasifacturas_id
          )
          INNER JOIN prestaciones p ON (p.id = sq.pi_prestacion_id)
          INNER JOIN diagnosticos d ON (d.id = sq.pl_diagnostico_id)
          LEFT JOIN afiliados a ON (a.clave_de_beneficiario = sq.pl_clave_de_beneficiario)
          LEFT JOIN tipos_de_documentos t ON (t.id = a.tipo_de_documento_id)
          LEFT JOIN clases_de_documentos c ON (c.id = a.clase_de_documento_id)
          LEFT JOIN datos_reportables_del_periodo drp ON (sq.pl_id = drp.prestacion_liquidada_id);
    SQL

  end

  # Este método devuelve el padrón de prestaciones que debe subirse al SIRGe para este periodo
def padron_de_prestaciones_ace
  # Buscamos todos los ID de prestaciones que requieren datos reportables para el SIRGe
  prestacion_ids =
    DatoReportableRequeridoSirge.select([:prestacion_id]).order(:id).
    map{|drrs| drrs.prestacion_id}.uniq

  selects = []
  prestacion_ids.each do |prestacion_id|
    # Obtenemos todos los datos reportables requeridos para esta prestación (entre 1 y 4)
    drrs =
      DatoReportableRequeridoSirge.includes(:dato_reportable_sirge).
      where(prestacion_id: prestacion_id, orden: 1).first
    drr1_id = drrs.present? ? drrs.dato_reportable_sirge.sirge_id : nil
    drr1_funcion = drrs.present? ? drrs.dato_reportable_sirge.funcion_de_transformacion : nil
    drrs =
      DatoReportableRequeridoSirge.includes(:dato_reportable_sirge).
      where(prestacion_id: prestacion_id, orden: 2).first
    drr2_id = drrs.present? ? drrs.dato_reportable_sirge.sirge_id : nil
    drr2_funcion = drrs.present? ? drrs.dato_reportable_sirge.funcion_de_transformacion : nil
    drrs = 
      DatoReportableRequeridoSirge.includes(:dato_reportable_sirge).
      where(prestacion_id: prestacion_id, orden: 3).first
    drr3_id = drrs.present? ? drrs.dato_reportable_sirge.sirge_id : nil
    drr3_funcion = drrs.present? ? drrs.dato_reportable_sirge.funcion_de_transformacion : nil
    drrs =
      DatoReportableRequeridoSirge.includes(:dato_reportable_sirge).
      where(prestacion_id: prestacion_id, orden: 4).first
    drr4_id = drrs.present? ? drrs.dato_reportable_sirge.sirge_id : nil
    drr4_funcion = drrs.present? ? drrs.dato_reportable_sirge.funcion_de_transformacion : nil

    # Generamos un SELECT para traer todos los registros que tienen este ID de prestación
    # con todos sus datos reportables completos
    selects << <<-SQL
        SELECT
            pl.id "prestacion_liquidada_id",
            #{drr1_id.present? ? drr1_id : "NULL"}::integer "id_dato_reportable1",
            #{drr1_funcion.present? ? drr1_funcion + "(pl.id)" : "NULL"}::varchar(255) "dato_reportable1",
            #{drr2_id.present? ? drr2_id : "NULL"}::integer "id_dato_reportable2",
            #{drr2_funcion.present? ? drr2_funcion + "(pl.id)" : "NULL"}::varchar(255) "dato_reportable2",
            #{drr3_id.present? ? drr3_id : "NULL"}::integer "id_dato_reportable3",
            #{drr3_funcion.present? ? drr3_funcion + "(pl.id)" : "NULL"}::varchar(255) "dato_reportable3",
            #{drr4_id.present? ? drr4_id : "NULL"}::integer "id_dato_reportable4",
            #{drr4_funcion.present? ? drr4_funcion + "(pl.id)" : "NULL"}::varchar(255) "dato_reportable4"
          FROM
            prestaciones_liquidadas pl
            INNER JOIN prestaciones_incluidas pi ON (pi.id = pl.prestacion_incluida_id)
            INNER JOIN liquidaciones_sumar ls ON ls.id = pl.liquidacion_id
          WHERE
            pl.estado_de_la_prestacion_liquidada_id IN (5, 12)
            AND pi.prestacion_id = #{prestacion_id}
            AND ls.periodo_id = #{self.id}
      SQL
  end

  # Creamos una tabla temporal para guardar las prestaciones liquidadas con sus cuatro campos
  # de datos reportables completos
  ActiveRecord::Base.connection.execute(
    "DROP TABLE IF EXISTS datos_reportables_del_periodo; CREATE TEMPORARY TABLE datos_reportables_del_periodo AS (" + selects.join(" UNION ") + ");"
  )

  # Finalmente, ejecutar la consulta que devuelve los campos formateados de acuerdo con el
  # documento del diccionario de datos del SIRGe (e implementación de datos reportables
  # según DOIU 20).
     ActiveRecord::Base.connection.exec_query <<-SQL
    SELECT
        p.id "Prestacion_id",
        p.codigo || d.codigo "Codigo_prestacion",
        e.cuie "CUIE efector",
        sq.pl_fecha_de_la_prestacion "Fecha_prestacion",
        a.apellido "Apellido",
        a.nombre "Nombre",
        (
          CASE
            WHEN a.clave_de_beneficiario IS NULL THEN
              '9999999999999999'::char(16)
            ELSE
              sq.pl_clave_de_beneficiario
            END
        ) "Clave_beneficiario",
        (
          CASE
            WHEN sq.pl_clave_de_beneficiario IS NULL THEN
              'COM'::varchar(3)
            ELSE
              t.codigo::varchar(3)
            END
        ) "Tipo_documento",
        (
          CASE
            WHEN sq.pl_clave_de_beneficiario IS NULL THEN
              'C'::char(1)
            ELSE
              c.codigo::char(1)
            END
        ) "Clase_documento",
        a.numero_de_documento "Numero_de_documento",
        s.nombre "Sexo",
        a.fecha_de_nacimiento "Fecha_de_nacimiento",
        sq.pl_monto::numeric(15, 2) "Precio_unitario",
        sq.pl_unidades::numeric(15, 2) "Cantidad",
        REGEXP_REPLACE(lsc.numero_cuasifactura, '[ -]', '', 'g') "numero_comprobante",
        to_char(lsc.created_at, 'YYYY-MM-DD') "Fecha_de_comprobante",
        sq.pl_numero_de_expediente "Numero_de_expediente",
        NULL "fecha_recepcion_expediente",
        (sq.pl_monto::numeric(15, 2) * sq.pl_unidades::numeric(15, 2)) "Monto_facturado",
        sq.pl_monto "Monto_liquidado",
        NULL "Fecha_liquidacion",
        NULL "Numero_de_orden_de_pago",
        NULL "Fecha_de_debito_bancario",
        NULL "Fecha_de_notificacion",
        p.es_catastrofica "Es_catastrofica?",
        sq.pl_concepto_de_facturacion "Concepto_de_facturación",
        (
          CASE
            WHEN drp.dato_reportable1 IS NOT NULL THEN
              drp.id_dato_reportable1
            ELSE
              NULL::integer
          END
        ) "id_dato_reportable1",
        drp.dato_reportable1 "dato_reportable1",
        (
          CASE
            WHEN drp.dato_reportable2 IS NOT NULL THEN
              drp.id_dato_reportable2
            ELSE
              NULL::integer
          END
        ) "id_dato_reportable2",
        drp.dato_reportable2 "dato_reportable2",
        (
          CASE
            WHEN drp.dato_reportable3 IS NOT NULL THEN
              drp.id_dato_reportable3
            ELSE
              NULL::integer
          END
        ) "id_dato_reportable3",
        drp.dato_reportable3 "dato_reportable3",
        (
          CASE
            WHEN drp.dato_reportable4 IS NOT NULL THEN
              drp.id_dato_reportable4
            ELSE
              NULL::integer
          END
        ) "id_dato_reportable4",
        drp.dato_reportable4 "dato_reportable4"
      FROM
        (
          SELECT
              pl.efector_id "pl_efector_id",
              pl.fecha_de_la_prestacion "pl_fecha_de_la_prestacion",
              pi.prestacion_id "pi_prestacion_id",
              pl.diagnostico_id "pl_diagnostico_id",
              pl.clave_de_beneficiario "pl_clave_de_beneficiario",
              pl.monto "pl_monto",
              pl.cantidad_de_unidades "pl_unidades",
              pl.id "pl_id",
              ex.numero "pl_numero_de_expediente",
              cf.concepto "pl_concepto_de_facturacion"

            FROM
              prestaciones_liquidadas pl
              LEFT JOIN prestaciones_incluidas pi ON (pi.id = pl.prestacion_incluida_id)
              LEFT JOIN liquidaciones_sumar ls ON (ls.id = pl.liquidacion_id)
              LEFT JOIN expedientes_sumar ex ON (ls.id = ex.liquidacion_sumar_id AND pl.efector_id = ex.efector_id)
              LEFT JOIN conceptos_de_facturacion cf ON (cf.id = ls.concepto_de_facturacion_id)
            WHERE
              pl.estado_de_la_prestacion_liquidada_id IN (5, 12)
              AND ls.periodo_id = #{self.id}
            ORDER BY 1, 2, 3, 4, 5
        ) "sq"
        INNER JOIN efectores e ON (e.id = sq.pl_efector_id)
        INNER JOIN liquidaciones_sumar_cuasifacturas_detalles lscd ON (
          lscd.prestacion_liquidada_id = sq.pl_id
        )
        INNER JOIN liquidaciones_sumar_cuasifacturas lsc ON (
          lsc.id = lscd.liquidaciones_sumar_cuasifacturas_id
        )
        INNER JOIN prestaciones p ON (p.id = sq.pi_prestacion_id)
        INNER JOIN diagnosticos d ON (d.id = sq.pl_diagnostico_id)
        LEFT JOIN afiliados a ON (a.clave_de_beneficiario = sq.pl_clave_de_beneficiario)
        LEFT JOIN tipos_de_documentos t ON (t.id = a.tipo_de_documento_id)
        LEFT JOIN clases_de_documentos c ON (c.id = a.clase_de_documento_id)
        LEFT JOIN datos_reportables_del_periodo drp ON (sq.pl_id = drp.prestacion_liquidada_id)
        LEFT JOIN sexos s ON (a.sexo_id = s.id);

  SQL

end
end
