# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  # Definir esta clase como base para autenticación de usuarios usando Devise
  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable, :timeoutable, :lockable, :confirmable

  # NULLificar blancos
  nilify_blanks

  # Seguridad para asignaciones masivas
  attr_accessible :nombre, :apellido, :sexo_id, :fecha_de_nacimiento
  attr_accessible :email, :password, :password_confirmation, :observaciones, :cuenta_eliminada
  attr_readonly :observaciones

  # Asociaciones
  belongs_to :sexo
  has_many :user_groups_users
  has_many :user_groups, :through => :user_groups_users
  has_many :unidades_de_alta_de_datos_users
  has_many :unidades_de_alta_de_datos, :through => :unidades_de_alta_de_datos_users
  has_many :cargas_masivas

  # No mostrar cuentas de usuario eliminadas -- FUE UNA MALA IDEA, porque se elimina de todas las consultas
  #default_scope where(:cuenta_eliminada => false)

  scope :no_eliminado, where(:cuenta_eliminada => false)

  # Validaciones
  validates_presence_of :nombre, :apellido, :observaciones

  def in_group?(group)
    if group && group.is_a?(Array)
      return group.any?{ |g| has_group?(g) }
    else
      return has_group?(group)
    end
  end

  def has_group?(group)
    user_groups.each do | ug |
      return true if (ug.user_group_name.downcase.to_sym == group || ug.user_group_name == "administradores")
    end
    return false
  end

  # Modificación del comportamiento de Devise para verificar si un usuario ya fue autorizado
  def active_for_authentication?
    super && authorized?
  end

  def inactive_message
    (!confirmed_at || authorized?) ? super : :confirmed_but_unauthorized
  end

  def nombre_completo
    (nombre + " " + apellido).titleize
  end

end
