class AnexoMedicoPrestacion < ActiveRecord::Base
  belongs_to :liquidacion_sumar_anexo_medico
  belongs_to :prestacion_liquidada
  belongs_to :estado_de_la_prestacion
  belongs_to :motivo_de_rechazo
  attr_accessible :estado_de_la_prestacion_id, :motivo_de_rechazo_id, :observaciones

  def self.partos_para_verificar_carga_sip
    self.find_by_sql("
      SELECT amp.*
        FROM
          prestaciones_liquidadas pl
          JOIN prestaciones_incluidas pi ON pl.prestacion_incluida_id = pi.id
          JOIN liquidaciones_informes li ON (li.efector_id = pl.efector_id AND li.liquidacion_sumar_id = pl.liquidacion_id)
          JOIN liquidaciones_sumar_anexos_medicos lsam ON (li.liquidacion_sumar_anexo_medico_id = lsam.id)
          JOIN anexos_medicos_prestaciones amp ON (amp.liquidacion_sumar_anexo_medico_id = lsam.id AND amp.prestacion_liquidada_id = pl.id)
        WHERE
          pi.prestacion_id IN (SELECT id FROM prestaciones WHERE codigo IN ('ITQ001', 'ITQ002'))
          AND li.estado_del_proceso_id IN (2)
          AND lsam.estado_del_proceso_id IN (2, 3)
          AND pl.fecha_de_la_prestacion >= '2014-07-01';
    ")
  end
end
