class MotivoBajaBeneficiario < ActiveRecord::Base
  attr_accessible :nombre, :id
  has_many :novedad_del_afiliado
end
