class SubgrupoDePrestaciones < ActiveRecord::Base
  belongs_to :grupo_de_prestaciones

  validates_presence_of :grupo_de_prestaciones_id, :nombre
end
