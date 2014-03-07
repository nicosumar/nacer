class ExpedienteSumar < ActiveRecord::Base

  belongs_to :tipo_de_expediente
  attr_accessible :numero, :tipo_de_expediente

end
