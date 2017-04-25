class GrupoPermitido < ActiveRecord::Base
  # Los atributos siguientes pueden asignarse en forma masiva
  attr_accessible :grupo_poblacional_id, :grupo_pdss_id, :sexo_id
end
