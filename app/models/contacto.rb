class Contacto < ActiveRecord::Base
  # NULLificar los campos de texto en blanco
  nilify_blanks

  # Seguridad de asignaciones masivas
  attr_accessible :nombres, :apellidos, :mostrado, :sexo_id, :dni, :domicilio, :email, :email_adicional
  attr_accessible :telefono, :telefono_movil, :observaciones

  # Asociaciones
  belongs_to :sexo

  # Validaciones
  validates_presence_of :mostrado
end
