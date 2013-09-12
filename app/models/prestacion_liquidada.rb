class PrestacionLiquidada < ActiveRecord::Base
  attr_accessible :cantidad_de_unidades, :clave_de_beneficiario, :diagnostico_id, :diagnostico_nombre, :efector_id, :es_catastrofica, :estado_de_la_prestacion_id, :fecha_de_la_prestacion, :historia_clinica, :liquidacion_id, :observaciones, :prestacion_incluida_id, :unidad_de_alta_de_datos_id
end
