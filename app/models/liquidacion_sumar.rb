# -*- encoding : utf-8 -*-
class LiquidacionSumar < ActiveRecord::Base
  belongs_to :grupo_de_efectores_liquidacion
  belongs_to :concepto_de_facturacion
  belongs_to :periodo
  belongs_to :plantilla_de_reglas
  belongs_to :parametro_liquidacion_sumar


  attr_accessible :descripcion, :grupo_de_efectores_liquidacion_id, :concepto_de_facturacion_id, :periodo_id, :plantilla_de_reglas_id, :parametro_liquidacion_sumar_id

  validates_presence_of :descripcion, :grupo_de_efectores_liquidacion, :concepto_de_facturacion, :periodo, :parametro_liquidacion_sumar_id
  
  #private 

  def generar_prestaciones_incluidas

  	#Traigo Grupo de efectores y nomenclador
  	efectores =  self.grupo_de_efectores_liquidacion.efectores.all.collect {|ef| ef.id}
    esquemas = UnidadDeAltaDeDatos.joins(:efectores).merge(Efector.where(id: efectores))
    nomenclador = self.parametro_liquidacion_sumar.nomenclador
    vigencia_perstaciones = self.parametro_liquidacion_sumar.dias_de_prestacion
    fecha_de_recepcion = self.periodo.fecha_recepcion.to_s

    cq = CustomQuery.ejecutar (
      {
        esquemas: esquemas,
        sql:  "INSERT INTO public.prestaciones_incluidas\n"+
              "( liquidacion_id, \n"+
              "  nomenclador_id, nomenclador_nombre, \n"+
              "  prestacion_id, prestacion_nombre, prestacion_codigo, \n"+
              "  prestacion_cobertura, prestacion_comunitaria, prestacion_requiere_hc, prestacion_concepto_nombre, created_at, updated_at) \n"+
              " SELECT distinct #{self.id}, \n"+
              "               nom.id as nomenclador_id, nom.nombre as nomenclador_nombre, \n"+
              "               pr.id as prestacion_id, pr.nombre, pr.codigo as prestacion_codigo,  \n"+
              "               pr.otorga_cobertura as prestacion_cobertura, pr.comunitaria as prestacion_comunitaria, pr.requiere_historia_clinica as prestacion_requiere_hc \n"+
              "              ,cdf.concepto as prestacion_concepto_nombre,now(), now()\n"+
              "FROM prestaciones_brindadas pb\n"+
              "  INNER JOIN prestaciones pr ON (pr.id = pb.prestacion_id) \n"+
              "  INNER JOIN conceptos_de_facturacion cdf on (cdf.id = pr.concepto_de_facturacion_id)\n"+
              "  INNER JOIN afiliados af ON (af.clave_de_beneficiario = pb.clave_de_beneficiario) \n"+
              "  INNER JOIN efectores ef ON (ef.id = pb.efector_id) \n"+
              "  INNER JOIN asignaciones_de_precios ap \n"+
              "    ON (\n"+
              "      ap.prestacion_id = pb.prestacion_id\n"+
              "      AND ap.area_de_prestacion_id = ef.area_de_prestacion_id\n"+
              "    )\n"+
              "  INNER JOIN nomencladores nom  ON ( nom.id = ap.nomenclador_id ) \n"+
              "  WHERE estado_de_la_prestacion_id IN (2,3)\n"+
              "  AND cdf.id = #{self.concepto_de_facturacion.id}    \n"+
              "  AND ef.id in (#{efectores.join(", ")})   \n"+
              "  AND nom.id = #{nomenclador.id}     \n"+
              "  AND pb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_de_recepcion}','yyyy-mm-dd') "
      })

    if cq 
      logger.warn ("Tabla de prestaciones incluidas generada")
    else
      logger.warn ("Tabla de prestaciones incluidas NO generada")
    end

    cq = CustomQuery.ejecutar ({
      esquemas: esquemas,
      sql:  "INSERT INTO public.prestaciones_liquidadas \n "+
            "       (liquidacion_id, unidad_de_alta_de_datos_id, efector_id, \n "+
            "        prestacion_incluida_id, fecha_de_la_prestacion, \n "+
            "        estado_de_la_prestacion_id, historia_clinica, es_catastrofica, \n "+
            "        diagnostico_id, diagnostico_nombre, \n "+
            "        cantidad_de_unidades, observaciones, \n "+
            "        clave_de_beneficiario, \n "+
            "        created_at, updated_at) \n "+
            "SELECT distinct #{self.id} liquidacion_id, ef.unidad_de_alta_de_datos_id as unidad_de_alta_de_datos_id, pb.efector_id,\n "+
            "       pi.id as prestacion_incluida_id, pb.fecha_de_la_prestacion,\n "+
            "       pb.estado_de_la_prestacion_id, pb.historia_clinica, pb.es_catastrofica, \n "+
            "       pb.diagnostico_id, diag.nombre diagnostico_nombre,\n "+
            "       pb.cantidad_de_unidades, pb.observaciones,\n "+
            "       af.clave_de_beneficiario,\n "+
            "       now(), now()\n "+
            "  FROM prestaciones_brindadas pb\n "+
            "  INNER JOIN prestaciones pr ON (pr.id = pb.prestacion_id) \n "+
            "  INNER JOIN prestaciones_incluidas pi on pb.prestacion_id = pi.prestacion_id\n "+
            " INNER JOIN diagnosticos diag on diag.id = pb.diagnostico_id\n "+
            "  INNER JOIN afiliados af ON (af.clave_de_beneficiario = pb.clave_de_beneficiario) \n "+
            "  INNER JOIN efectores ef ON (ef.id = pb.efector_id) \n "+
            "  INNER JOIN asignaciones_de_precios ap  \n "+
            "    ON (\n "+
            "      ap.prestacion_id = pb.prestacion_id\n "+
            "      AND ap.area_de_prestacion_id = ef.area_de_prestacion_id\n "+
            "    )\n "+
            "  INNER JOIN nomencladores nom  \n "+
            "    ON ( nom.id = ap.nomenclador_id )\n "+
            "  \n "+
            "  WHERE pb.estado_de_la_prestacion_id IN (2,3)\n "+
            "  AND ef.id in (#{efectores.join(", ")})   \n"+
            "  AND nom.id = #{nomenclador.id}     \n"+
            "  AND pb.fecha_de_la_prestacion BETWEEN (to_date('#{fecha_de_recepcion}','yyyy-mm-dd') - #{vigencia_perstaciones}) and to_date('#{fecha_de_recepcion}','yyyy-mm-dd') "
      })

    if cq 
      logger.warn ("Tabla de prestaciones incluidas generada")
    else
      logger.warn ("Tabla de prestaciones incluidas NO generada")
    end



  end


end
