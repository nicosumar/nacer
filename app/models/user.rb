class User < ActiveRecord::Base
  # Definir esta clase como base para autenticación de usuarios usando Devise
  devise :database_authenticatable, :registerable, :recoverable, :trackable,
    :validatable, :timeoutable, :lockable, :confirmable

  # NULLificar blancos
  nilify_blanks

  # Seguridad para asignaciones masivas
  attr_accessible :nombre, :apellido, :sexo_id, :fecha_de_nacimiento
  attr_accessible :email, :password, :password_confirmation
  attr_readonly :observaciones

  # Asociaciones
  belongs_to :sexo
  has_many :user_groups_users
  has_many :user_groups, :through => :user_groups_users
  has_many :unidades_de_alta_de_datos_users
  has_many :unidades_de_alta_de_datos, :through => :unidades_de_alta_de_datos_users

  # Validaciones
  validates_presence_of :nombre, :apellido

  def in_group?(group)
    user_groups.each do | ug |
      return true if ug.user_group_name.downcase.to_sym == group
    end
    return false
  end
end
