class User < ActiveRecord::Base
  belongs_to :sexo
  has_and_belongs_to_many :user_groups
  has_many :unidades_de_alta_de_datos_users
  has_many :unidades_de_alta_de_datos, :through => :unidades_de_alta_de_datos_users
  validates_presence_of :firstname, :lastname

  acts_as_authentic do |a|
  end

  def in_group?(group)
    user_groups.each do | ug |
      return true if ug.user_group_name.downcase.to_sym == group
    end
    return false
  end
end
