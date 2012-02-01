class Provincia < ActiveRecord::Base
  has_many :departamentos

  validates_presence_of :nombre
end
