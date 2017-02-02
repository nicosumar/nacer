class AsistenteTaller < ActiveRecord::Base
  belongs_to :efector
  belongs_to :prestacion_brindada
  belongs_to :clase_de_documento
  belongs_to :tipo_de_documento
  belongs_to :sexo
  attr_accessible :apellido, :fecha_de_nacimiento, :nombre, :numero_de_documento
end
