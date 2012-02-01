class User < ActiveRecord::Base
  belongs_to :sexo
  has_and_belongs_to_many :user_groups
  validates_presence_of :firstname, :lastname

  acts_as_authentic do | c |
#    c.logged_in_timeout = 15.minutes
  end

  def in_group?(group)
    user_groups.each do | ug |
      return true if ug.user_group_name.downcase.to_sym == group
    end
    return false
  end
end
