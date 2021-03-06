# -*- encoding : utf-8 -*-
class PrestacionLiquidada < ActiveRecord::Base

  belongs_to :liquidacion, class_name: "LiquidacionSumar"
  belongs_to :efector
  belongs_to :unidad_de_alta_de_datos
  belongs_to :prestacion_incluida
  belongs_to :estado_de_la_prestacion
  belongs_to :estado_de_la_prestacion_liquidada, :class_name => "EstadoDeLaPrestacion"
  belongs_to :diagnostico
  belongs_to :prestacion_brindada #solo agregada por referencia para simplificar los querys
  belongs_to :afiliado, class_name: "Afiliado", foreign_key: :clave_de_beneficiario, primary_key: :clave_de_beneficiario
  has_many   :prestaciones_liquidadas_datos
  has_one    :detalle_de_debito_prestacional
  has_one    :prestacion, through: :prestacion_incluida
  has_one    :liquidacion_sumar_cuasifactura_detalle, :inverse_of => :prestacion_liquidada
  has_one    :liquidaciones_sumar_cuasifacturas, :through => :liquidacion_sumar_cuasifactura_detalle, :class_name => "LiquidacionSumarCuasifactura"
  has_one    :periodo, :through => :liquidacion
  has_one    :anexo_administrativo_prestacion, :inverse_of => :prestacion_liquidada
  has_one    :anexo_medico_prestacion, :inverse_of => :prestacion_liquidada

  scope :pagadas_por_efector, lambda {|efector| where(efector_id: efector.id, estado_de_la_prestacion_liquidada_id: 12)}
  scope :pagadas_por_efector_y_concepto,
    lambda { |efector, concepto|
      joins(" join prestaciones_incluidas on prestaciones_incluidas.id = prestaciones_liquidadas.prestacion_incluida_id\n"+
            " join prestaciones on prestaciones.id = prestaciones_incluidas.prestacion_id\n")
      .includes(:prestacion_incluida)
      .where("prestaciones.concepto_de_facturacion_id = ? \n"+
             "and prestaciones_liquidadas.efector_id = ? \n"+
             "and estado_de_la_prestacion_liquidada_id = 12 ", concepto, efector)
    }

  scope :pagadas_por_afiliado_efector_y_concepto,
    lambda{ |afiliado, efector, concepto|
      joins(" join prestaciones_incluidas on prestaciones_incluidas.id = prestaciones_liquidadas.prestacion_incluida_id\n"+
            " join prestaciones on prestaciones.id = prestaciones_incluidas.prestacion_id\n"+
            " join afiliados on afiliados.clave_de_beneficiario = prestaciones_liquidadas.clave_de_beneficiario ")
      .includes(:prestacion_incluida, :efector, :afiliado)
      .where("prestaciones.concepto_de_facturacion_id = ? \n"+
             "and prestaciones_liquidadas.efector_id = ? \n"+
             "and afiliados.clave_de_beneficiario = ? \n"+
             "and estado_de_la_prestacion_liquidada_id < 102 ", concepto, efector, afiliado.clave_de_beneficiario)

    }
  scope :pagadas_por_efector_y_concepto_comunitarias,
    lambda{ |efector, concepto|
      joins(" join prestaciones_incluidas on prestaciones_incluidas.id = prestaciones_liquidadas.prestacion_incluida_id\n"+
            " join prestaciones on prestaciones.id = prestaciones_incluidas.prestacion_id\n")
      .includes(:prestacion_incluida, :efector)
      .where("prestaciones.concepto_de_facturacion_id = ? \n"+
             "and prestaciones_liquidadas.efector_id = ? \n"+
             "and prestaciones_liquidadas.clave_de_beneficiario IS NULL \n"+
             "and estado_de_la_prestacion_liquidada_id = 12 ", concepto, efector )

    }

  attr_accessible :cantidad_de_unidades, :clave_de_beneficiario, :diagnostico_id, :diagnostico_nombre
  attr_accessible :efector_id, :es_catastrofica, :estado_de_la_prestacion_id, :fecha_de_la_prestacion
  attr_accessible :historia_clinica, :liquidacion_id, :observaciones, :prestacion_incluida_id
  attr_accessible :unidad_de_alta_de_datos_id, :detalle_de_debito_prestacional

  def prestacion_liquidada_nombre
    self.prestacion_incluida.prestacion_codigo + " - "+ self.prestacion_incluida.nombre_corto
  end

  def rechazo_administrativo?
    anexo_administrativo_prestacion.present? && anexo_administrativo_prestacion.motivo_de_rechazo.present?
  end

  def motivo_de_rechazo_administrativo
    anexo_administrativo_prestacion.motivo_de_rechazo.nombre if self.rechazo_administrativo? or nil
  end

  def rechazo_medico?
    anexo_medico_prestacion.present? && !anexo_medico_prestacion.motivo_de_rechazo.blank?
  end

  def motivo_de_rechazo_medico
    anexo_medico_prestacion.motivo_de_rechazo.nombre if self.rechazo_medico? or nil
  end

  def rechazada?
    self.rechazo_administrativo? || self.rechazo_medico?
  end

end
