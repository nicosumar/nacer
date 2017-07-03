# -*- encoding : utf-8 -*-
class Banco < ActiveRecord::Base
  has_many :sucursales_bancarias
  attr_accessible :nombre
end
