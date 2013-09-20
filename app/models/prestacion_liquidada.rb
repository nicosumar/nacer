# -*- encoding : utf-8 -*-
class PrestacionLiquidada < ActiveRecord::Base

  belongs_to :liquidacion, class_name: "LiquidacionSumar"
  belongs_to :efector
  belongs_to :unidad_de_alta_de_datos
  belongs_to :prestacion_incluida
  belongs_to :estado_de_la_prestacion
  belongs_to :diagnostico
  belongs_to :prestacion_brindada #solo agregada por referencia para simplificar los querys
  belongs_to :afiliado, class_name: "Afiliado", foreign_key: :clave_de_beneficiario 


  attr_accessible :cantidad_de_unidades, :clave_de_beneficiario, :diagnostico_id, :diagnostico_nombre, :efector_id, :es_catastrofica, :estado_de_la_prestacion_id, :fecha_de_la_prestacion, :historia_clinica, :liquidacion_id, :observaciones, :prestacion_incluida_id, :unidad_de_alta_de_datos_id
end
