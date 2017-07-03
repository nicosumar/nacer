class AddMontoAprobadoToLiquidacionInforme < ActiveRecord::Migration
  def up
    add_column :liquidaciones_informes, :monto_aprobado, "numeric(15,4)"
    add_column :liquidaciones_informes, :devueltos_administracion_monto, "numeric(15,4)"
    add_column :liquidaciones_informes, :devueltos_administracion_cantidad, :integer
    add_column :liquidaciones_informes, :devueltos_medica_monto, "numeric(15,4)"
    add_column :liquidaciones_informes, :devueltos_medica_cantidad, :integer
    add_column :liquidaciones_informes, :rechazos_administracion_monto, "numeric(15,4)"
    add_column :liquidaciones_informes, :rechazos_administracion_cantidad, :integer
    add_column :liquidaciones_informes, :rechazos_medica_monto, "numeric(15,4)"
    add_column :liquidaciones_informes, :rechazos_medica_cantidad, :integer
    add_column :liquidaciones_informes, :aprobados_administracion_cantidad, :integer
    add_column :liquidaciones_informes, :aprobados_administracion_monto, "numeric(15,4)"
    add_column :liquidaciones_informes, :aprobados_medica_cantidad, :integer
    add_column :liquidaciones_informes, :aprobados_medica_monto, "numeric(15,4)"


    LiquidacionInforme.where(estado_del_proceso_id: 4).each do |li|
      r = ActiveRecord::Base.connection.exec_query <<-SQL
        select  sum(CASE WHEN ( 
                                COALESCE(amp.estado_de_la_prestacion_id, 5) = 5 
                                and COALESCE(aap.estado_de_la_prestacion_id, 5) = 5 
                                and not ( amp.estado_de_la_prestacion_id is null AND 
                                          aap.estado_de_la_prestacion_id is null )  
                              )
                               THEN pl.monto
                               ELSE 0::NUMERIC
                          END 
                                    ) monto_aprobado,
                      sum(CASE WHEN aap.estado_de_la_prestacion_id = 7 THEN pl.monto ELSE 0::numeric END) "Devueltos Administracion ($)",
                      sum(CASE WHEN aap.estado_de_la_prestacion_id = 7 THEN 1 ELSE 0::numeric END) "Devueltos Administracion (cant.)",
                      sum(CASE WHEN amp.estado_de_la_prestacion_id = 7 THEN pl.monto ELSE 0::numeric END) "Devueltos Medicos($)",
                      sum(CASE WHEN amp.estado_de_la_prestacion_id = 7 THEN 1 ELSE 0::numeric END) "Devueltos Medicos(cant.)",
                      sum(CASE WHEN aap.estado_de_la_prestacion_id in(6,10, 11) THEN pl.monto ELSE 0::numeric END) "Rechazos Administracion($)",
                      sum(CASE WHEN aap.estado_de_la_prestacion_id in(6,10, 11) THEN 1 ELSE 0::numeric END) "Rechazos Administracion(cant.)",
                      sum(CASE WHEN amp.estado_de_la_prestacion_id in(6,10, 11) THEN pl.monto ELSE 0::numeric END) "Rechazos Medicos($)", 
                      sum(CASE WHEN amp.estado_de_la_prestacion_id in(6,10, 11) THEN 1 ELSE 0::numeric END) "Rechazos Medicos(cant.)",
                      sum(CASE WHEN aap.estado_de_la_prestacion_id = 5 THEN 1 ELSE 0::numeric END) "Aprobados Administracion(cant.)",
                      sum(CASE WHEN aap.estado_de_la_prestacion_id = 5 THEN pl.monto ELSE 0::numeric END) "Aprobado Administracion($)",
                      sum(CASE WHEN amp.estado_de_la_prestacion_id = 5 THEN 1 ELSE 0::numeric END) "Aprobado Medicos(cant.)",
                      sum(CASE WHEN amp.estado_de_la_prestacion_id = 5 THEN pl.monto ELSE 0::numeric END) "Aprobado Medica($)"
        from liquidaciones_sumar l
          join liquidaciones_sumar_cuasifacturas c on c.liquidacion_sumar_id = l.id
          join efectores e on e.id  = c.efector_id
          join liquidaciones_informes li on li.efector_id = e.id and li.liquidacion_sumar_id = l.id 
          join estados_de_los_procesos estados on estados.id = li.estado_del_proceso_id
          join prestaciones_liquidadas pl ON pl.liquidacion_id = l.id and pl.efector_id = e.id 
          join expedientes_sumar es on es.id = li.expediente_sumar_id
          left join anexos_medicos_prestaciones amp ON amp.prestacion_liquidada_id = pl.id 
          left JOIN anexos_administrativos_prestaciones aap ON aap.prestacion_liquidada_id = pl.id
        where li.id = #{li.id}
        group by es.numero, e.cuie, c.monto_total, estados.id
      SQL

      li.update_attributes( monto_aprobado: r.rows[0][0].to_f,
                            devueltos_administracion_monto: r.rows[0][1].to_f,
                            devueltos_administracion_cantidad: r.rows[0][2].to_i,
                            devueltos_medica_monto: r.rows[0][3].to_f,
                            devueltos_medica_cantidad: r.rows[0][4].to_i,
                            rechazos_administracion_monto: r.rows[0][5].to_f,
                            rechazos_administracion_cantidad: r.rows[0][6].to_i,
                            rechazos_medica_monto: r.rows[0][7].to_f,
                            rechazos_medica_cantidad: r.rows[0][8].to_i,
                            aprobados_administracion_cantidad: r.rows[0][9].to_i,
                            aprobados_administracion_monto: r.rows[0][10].to_f,
                            aprobados_medica_cantidad: r.rows[0][11].to_i,
                            aprobados_medica_monto: r.rows[0][12].to_f)
    end

  end

  def down
    remove_column :liquidaciones_informes, :monto_aprobado
    remove_column :liquidaciones_informes, :monto_aprobado
    remove_column :liquidaciones_informes, :devueltos_administracion_monto
    remove_column :liquidaciones_informes, :devueltos_administracion_cantidad
    remove_column :liquidaciones_informes, :devueltos_medica_monto
    remove_column :liquidaciones_informes, :devueltos_medica_cantidad
    remove_column :liquidaciones_informes, :rechazos_administracion_monto
    remove_column :liquidaciones_informes, :rechazos_administracion_cantidad
    remove_column :liquidaciones_informes, :rechazos_medica_monto
    remove_column :liquidaciones_informes, :rechazos_medica_cantidad
    remove_column :liquidaciones_informes, :aprobados_administracion_cantidad
    remove_column :liquidaciones_informes, :aprobados_administracion_monto
    remove_column :liquidaciones_informes, :aprobados_medica_cantidad
    remove_column :liquidaciones_informes, :aprobados_medica_monto
  end
end
