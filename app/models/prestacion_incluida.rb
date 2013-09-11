class PrestacionIncluida < ActiveRecord::Base
  attr_accessible :efector_nombre, :monto, :nomenclador_nombre, :prestacion_area_nombre, :prestacion_cobertura, :prestacion_codigo, :prestacion_comunitaria, :prestacion_concepto_nombre, :prestacion_grupo_nombre, :prestacion_nombre, :prestacion_requiere_hc, :prestacion_subgrupo_nombre, :uad_nombre
end
