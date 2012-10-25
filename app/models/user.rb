class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :trackable,
    :validatable, :timeoutable, :lockable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :nombre, :apellido, :fecha_de_nacimiento
  attr_accessible :email, :password, :password_confirmation

  belongs_to :sexo
  has_many :user_groups_users
  has_many :user_groups, :through => :user_groups_users
  has_many :unidades_de_alta_de_datos_users
  has_many :unidades_de_alta_de_datos, :through => :unidades_de_alta_de_datos_users
  validates_presence_of :nombre, :apellido

  def in_group?(group)
    user_groups.each do | ug |
      return true if ug.user_group_name.downcase.to_sym == group
    end
    return false
  end
end
