# -*- encoding : utf-8 -*-

ActiveRecord::Base.transaction do

  #
  liquidaciones = LiquidacionSumar.where(:id => [3,4,5,6])
  liquidaciones.each do |l|
    # 3) Actualiza las prestaciones brindadas para que no sean modificadas
    efectores =  l.grupo_de_efectores_liquidacion.efectores.all.collect {|ef| ef.id}
    esquemas = UnidadDeAltaDeDatos.joins(:efectores).merge(Efector.where(id: efectores))

    cq = CustomQuery.ejecutar ({
      esquemas: esquemas,
      sql:  "update prestaciones_brindadas \n "+
            "   set estado_de_la_prestacion_id = p.estado_de_la_prestacion_id \n "+
            "from prestaciones_liquidadas p \n "+
            "    join liquidaciones_sumar_cuasifacturas lsc on (lsc.liquidacion_sumar_id = p.liquidacion_id and lsc.efector_id = p.efector_id ) \n "+
            "where p.liquidacion_id = #{l.id} \n "+
            "and p.efector_id in (select ef.id \n "+
            "                                      from efectores ef \n "+
            "                                         join unidades_de_alta_de_datos u on ef.unidad_de_alta_de_datos_id = u.id \n "+
            "                                      where 'uad_' ||  u.codigo = current_schema() )\n "+
            "and prestaciones_brindadas.id = p.prestacion_brindada_id"
      })
  end

  # Volver hacia atrás las secuencias
  cuasi_facturas = LiquidacionSumarCuasifactura.where(:liquidacion_sumar_id => [3,4,5,6])
  cuasi_facturas.each do |cf|
    ultima_secuencia = ActiveRecord::Base.connection.exec_query("SELECT * FROM public.cuasi_factura_sumar_seq_efector_id_#{cf.efector_id};").first["last_value"].to_i
    if ultima_secuencia > 1
      ActiveRecord::Base.connection.execute "
        SELECT setval('public.cuasi_factura_sumar_seq_efector_id_#{cf.efector_id}', #{ultima_secuencia - 1}, 't');
      "
    else
      ActiveRecord::Base.connection.execute "
        SELECT setval('public.cuasi_factura_sumar_seq_efector_id_#{cf.efector_id}', 1, 'f');
      "
    end
  end

  ActiveRecord::Base.connection.execute "
    DELETE FROM liquidaciones_sumar_cuasifacturas_detalles WHERE liquidaciones_sumar_cuasifacturas_id IN (
      SELECT id FROM liquidaciones_sumar_cuasifacturas WHERE liquidacion_sumar_id IN (3,4,5,6));
    DELETE FROM liquidaciones_sumar_cuasifacturas WHERE liquidacion_sumar_id IN (3,4,5,6);
  "

end
