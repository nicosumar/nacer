# -*- encoding : utf-8 -*-
class UserGroup < ActiveRecord::Base
  attr_accessible :user_group_name, :user_group_description
  has_and_belongs_to_many :users
end
