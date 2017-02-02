# -*- encoding : utf-8 -*-
class UserGroupUser < ActiveRecord::Base
  belongs_to :user_group
  belongs_to :user
end
