# -*- encoding : utf-8 -*-
class CategoriaDeAfiliado < ActiveRecord::Base
  has_and_belongs_to_many :prestaciones

end
