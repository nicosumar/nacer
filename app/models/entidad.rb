# -*- encoding : utf-8 -*-
class Entidad < ActiveRecord::Base
  belongs_to :entidad, polymorphic: true
  has_many :cuentas_bancarias
end
